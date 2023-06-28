Function Start-Debloat() {

    # - McAfee Live Safe Removal
    Write-Caption -Text "McAfee"
    If (Test-Path -Path $livesafe -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of McAfee Live Safe..."
        Use-Command "Start-Process `"$livesafe`""
    }    
    
    # - WebAdvisor Removal
    Write-Caption -Text "McAfee WebAdvisor"
    If (Test-Path -Path $webadvisor -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of McAfee WebAdvisor Uninstall."
        Use-Command "Start-Process `"$webadvisor`""
    }
    
    # - Preinsatlled on Acer machines primarily WildTangent Games
    Write-Caption -Text "WildTangent Games"
    If (Test-Path -Path $WildGames -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal WildTangent Games."
        Use-Command "Start-Process `"$WildGames`""
    }
    
    # - Norton cuz LUL Norton
    Write-Caption -Text "Norton x86"
    $Global:NortonPath = "C:\Program Files (x86)\NortonInstaller"
    $Global:CheckNorton = Get-ChildItem -Path $NortonPath -Name "InstStub.exe" -Recurse -ErrorAction SilentlyContinue
    If ($CheckNorton) {
        New-Variable -Name "Norton" -Value "$NortonPath\$CheckNorton" -Scope Global -Force
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of Norton..."
        Use-Command "Start-Process `"$Norton`" -ArgumentList `"/X /ARP`""
    }
    
    # - Avast Cleanup Premium
    Write-Caption -Text "Avast Cleanup"
    $Global:AvastCleanupLocation = "C:\Program Files\Common Files\Avast Software\Icarus\avast-tu\icarus.exe"
    If (Test-Path $AvastCleanupLocation) {
        Use-Command "Start-Process `"$AvastCleanupLocation`" -ArgumentList `"/manual_update /uninstall:avast-tu`""
    }
    
    # - Avast Antivirus
    Write-Caption -Text "Avast AV"
    $Global:AvastLocation = "C:\Program Files\Avast Software\Avast\setup\Instup.exe"
    If (Test-Path $AvastLocation) {
        Use-Command "Start-Process `"$AvastLocation`" -ArgumentList `"/control_panel`""
    }
    
    Write-Section -Text "Checking for Start Menu Ads"
    $apps = @(
        "Adobe offers"
        "Amazon"
        "Booking"
        "Booking.com"
        "ExpressVPN"
        "Forge of Empires"
        "Free Trials"
        "Planet9 Link"
        "Utomik - Play over 1000 games"
    )
    ForEach ($app in $apps) {
        If (Test-Path -Path "$commonapps\$app.url") {
            # - Checks common start menu .urls 
            Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Removing $app.url"
            Use-Command "Remove-Item -Path `"$commonapps\$app.url`" -Force"
        }
        If (Test-Path -Path "$commonapps\$app.lnk") {
            # - Checks common start menu .lnks
            Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Removing $app.lnk"
            Use-Command "Remove-Item -Path `"$commonapps\$app.lnk`" -Force"
        }
    }

    # - UWP Apps
    Write-Section -Text "Checking for UWP Apps"
    $TotalItems = $Programs.Count
    $CurrentItem = 0
    $PercentComplete = 0
    ForEach($Program in $Programs){
        # - Uses blue progress bar to show debloat progress -- ## Doesn't seem to be working currently.
        Write-Progress -Activity "Debloating System" -Status " $PercentComplete% Complete:" -PercentComplete $PercentComplete
        # - Starts Debloating the system
        Remove-UWPAppx -AppxPackages $Program
        $CurrentItem++
        $PercentComplete = [int](($CurrentItem / $TotalItems) * 100)
    }

    # - Debloat Completion
    Write-Host "Debloat Completed!`n" -Foregroundcolor Green
    Write-Host "Packages Removed: " -NoNewline -ForegroundColor Gray ; Write-Host "$Removed" -ForegroundColor Green
    If ($Failed){ Write-Host "Failed: " -NoNewline -ForegroundColor Gray ; Write-Host "$Failed" -ForegroundColor Red }
    Write-Host "Packages Scanned For: " -NoNewline -ForegroundColor Gray ; Write-Host "$NotFound`n" -ForegroundColor Yellow
    Start-Sleep -Seconds 4
}
# SIG # Begin signature block
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUlDM7Ig6J4l+VYNJu4vMVY0EK
# zyWgggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
# AQsFADCBlDELMAkGA1UEBhMCQ0ExCzAJBgNVBAgMAkJDMREwDwYDVQQHDAhWaWN0
# b3JpYTEeMBwGCSqGSIb3DQEJARYPY2lyY2xvbEBzaGF3LmNhMR8wHQYJKoZIhvcN
# AQkBFhBuZXdsb2Fkc0BzaGF3LmNhMRAwDgYDVQQKDAdDaXJjbG9sMRIwEAYDVQQD
# DAlOZXcgTG9hZHMwHhcNMjMwNjIxMDMyMTQ3WhcNMjQwNjIxMDM0MTQ3WjCBlDEL
# MAkGA1UEBhMCQ0ExCzAJBgNVBAgMAkJDMREwDwYDVQQHDAhWaWN0b3JpYTEeMBwG
# CSqGSIb3DQEJARYPY2lyY2xvbEBzaGF3LmNhMR8wHQYJKoZIhvcNAQkBFhBuZXds
# b2Fkc0BzaGF3LmNhMRAwDgYDVQQKDAdDaXJjbG9sMRIwEAYDVQQDDAlOZXcgTG9h
# ZHMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDQt44ecXJMhStrhxP7
# iZBc+ud0YMIoM1ckjS9fAb1hwa8b79DWgMbTLoRx5fQG6Hiq4+1hzCaR9kAFgn8y
# gHkdrv21XbaATgY+KyNk+e0QryyRbjkUtvbO7ZUNkxm1ld3epvJqs4rPGPMpnoj+
# fzbs1YjzEoq1Pd0hfc032DUfmjcay6k5kgFFoCzbrjLQoP8cyneJ8WE7muwbZVUP
# cjA1UujXDeO6O2KMJtnPkCjr+8vlGfkxc6zfdWMxXn5yCFZjKIGwiLvSlXBlGTKp
# dayNTTz8TZC96mtQhVez3WZU9MzP/gicbzXwb6gzkNsJYYTiN+gI+MwqJnSbEPNY
# krRJAgMBAAGjajBoMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcD
# AzAiBgNVHREEGzAZghd3d3cubW90aGVyY29tcHV0ZXJzLmNvbTAdBgNVHQ4EFgQU
# JkPTOiVNkHT7I4KIkYbt1sJ26HMwDQYJKoZIhvcNAQELBQADggEBAIBa7suOeJ5L
# 20Eftw4YffTpYsZHlWBrhJOJWS/kye7LtSUMpusAhLK9kQpbtHclCo7VRIutXNip
# UlMF4pVLBi3LI7hNKPnw1j0PB/4hNwjHMwlcPGvY+wcFPZbJtpwiPNeiIpfA6n8U
# ph2Z3CmdeFOBdSzKYfo77ofOuyuYsnp+272wM6nOrQEsJoqp+TWjeGiKkLZFhXgO
# b6YyAcn+ZKDJzIMoNJ0DuzRUWY4ONdwA4qwvzlOn+PHYivCkvbZUtOc39Hvr7q/h
# 4y6ftOGq7K0MH002S4rkIfuhmKodXxLch1oCzJWE51s64nCfe808LSk7D8J0QbYN
# QMT1YZwc3boxggJLMIICRwIBATCBqTCBlDELMAkGA1UEBhMCQ0ExCzAJBgNVBAgM
# AkJDMREwDwYDVQQHDAhWaWN0b3JpYTEeMBwGCSqGSIb3DQEJARYPY2lyY2xvbEBz
# aGF3LmNhMR8wHQYJKoZIhvcNAQkBFhBuZXdsb2Fkc0BzaGF3LmNhMRAwDgYDVQQK
# DAdDaXJjbG9sMRIwEAYDVQQDDAlOZXcgTG9hZHMCEEhhnG/PjVqLTtJZNdkUw2Ew
# CQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcN
# AQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUw
# IwYJKoZIhvcNAQkEMRYEFFiD/4xbhyeFJbzgih2CKmP7Si5RMA0GCSqGSIb3DQEB
# AQUABIIBAISzonD1qHlqSoUmxda8v8mELHxNFUI6vHR+mojxJ2kcFRpzeFHhc1Hb
# vjDENFvlA6sqUtPtKLOWrwoE2vAsA0fOoBcGO1nkP3V3fMIaiKHS9KYtRXGEhTSa
# SLmP7pgz3o1rAXUkCwPhEzwv1OhVN9hgMTB9G/D4BfEo62yiypFzTrX3/7SSFEps
# FNYeGn/9ofb6AwvLoKAIGr82YpKCC5w7FHyG+2go/rfq7z0ciOGFVfk8hyHSdfkb
# DR3VBX2vefSFmxHO1iB1sjWf9WusayiTKn0P2aVvx82daEueDReGHDIEdgrmEDIw
# FuxvHXmsQW4JrRRgPyBa+XCSUPE+kcs=
# SIG # End signature block
