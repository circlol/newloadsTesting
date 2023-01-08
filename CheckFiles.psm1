Function CheckFiles() {
    Write-Section -Text "Scanning Exisitng Files"
    Try{
        If (Test-Path ".\tmp.txt") { Write-Status -Types "-" -Status "Removing a previously runs tmp.txt." ; Remove-Item ".\tmp.txt" -Force}
        If (!(Test-Path ".\bin")) { Write-Status -Types "+" -Status "Creating Bin Folder." ; mkdir ".\bin" }
        If (!(Test-Path ".\assets")) { Write-Status -Types "+" -Status "Creating Assets Folder." ; mkdir ".\assets" }
        If (!(Test-Path ".\lib")) { Write-Status -Types "+" -Status "Creating Lib Folder." ; mkdir ".\lib" }
        If (Test-Path .\ErrorLog.txt) { Write-Status -Types "-" -Status "Removing a previous runs ErrorLog.txt." ; Remove-Item -Path ".\ErrorLog.txt"}
        "$(Get-Date) - New Loads Error Log:" | Out-File ".\newloads-errorlog.txt"
        #ForEach ($CurrentLibFile in $CurrentLibFiles){Remove-Item -Path .\lib\"$CurrentLibFile" -Force}
    }Catch{}

    $Files = @(
        "Assets\start.bin"
        "Assets\10.jpg"
        "Assets\10_mGaming.png"
        "Assets\11.jpg"
        "Assets\11_mGaming.png"
        "Assets\Microsoft.HEVCVideoExtension_2.0.51121.0_x64__8wekyb3d8bbwe.appx"
        "lib\get-hardware-info.psm1"
        "lib\gui.psm1"
        "lib\office.psm1"
        "lib\optimization.psm1"
        "lib\remove-uwp-appx.psm1"
        "lib\restart-explorer.psm1"
        "lib\set-scheduled-task-state.psm1"
        "lib\set-service-startup.psm1"
        "lib\set-windows-feature-state.psm1"
        #"lib\show-dialog-window.psm1"
	  "lib\Templates.psm1
        "lib\variables.psm1"
        )
    $Items = [System.Collections.ArrayList]::new()

    # Checks if each file exists on the computer #
    ForEach ($file in $files) {
        If (Test-Path ".\$File") {
            Write-CaptionSucceed -Text "$File Validated"
        }else {
            Write-CaptionFailed -Text "$file Failed to validate."
            $Items += $file
        }
    }

    # Validates files - Downloads missing files from github #
    If (!($Items)) {
        Write-Section -Text "All packages successfully validated."
    }else {

        $ItemsFile = ".\tmp.txt"
        $Items | Out-File $ItemsFile -Encoding ASCII 
        (Get-Content $ItemsFile).replace('\', '/') | Set-Content $ItemsFile
        $urls = Get-Content $ItemsFile
        CheckNetworkStatus
        Write-Section -Text "Downloading Missing Files"
        Try {
            ForEach ($url in $urls) {
                Write-Caption "Attempting to Download $url"
                $link = "https://raw.githubusercontent.com/circlol/newloadsTesting/main/" + $url.replace('\', '/')
                Start-BitsTransfer -Dynamic -Source "$link" -Destination ".\$url" -Verbose -TransferType Download -RetryTimeout 15 -RetryInterval 15 -Confirm:$False | Out-Host
                Check ; ""
            }
        }Catch{Continue}
        Write-Status -Types "-" -Status "Removing $ItemsFile"
        Remove-Item $ItemsFile
    }
}


# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUDbwvKz+t61LfmtdQVMKz5PuL
# MOGgggMQMIIDDDCCAfSgAwIBAgIQbsRA190DwbdBuskmJyNY4jANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIyMTIyNDA1
# MDQzMloXDTIzMTIyNDA1MjQzMlowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKBzm18SMDaGJ9ft
# 4mCIOUCCNB1afaXS8Tx2dAnJ+84pGS4prKCxc7/F+n5uqXtPZcl88tr9VR1N/BBE
# Md4LWvD2o/k5WfkYPtBoatldnZs9d1HBgIrWJoulc3PidboCD4Xz9Z9ktfrcmhc8
# MfDD0DfSKswyi3N9L6t8ZRdLUW+JCh/1WHbt7o3ckvijEuKh9AOnzYtkXJfE+eRd
# DKK2sq46WlZG2Sm3J+WOo2oeoFvvYHRG9RtzSY2EhmVRYWzGFM/GCqLUbh2wZwdY
# uG61lCrkC6ZjEYPhs5ckoijMFC6bb4zYk4lYDzartHYiMxH1Ac0jNpaq+7kB3oRF
# QLXWc+kCAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBRkAPIg1GpPJcyyzANerOe2sUGidTANBgkqhkiG9w0BAQsF
# AAOCAQEABc3czHPSCyEDQ9MzWSiW7EhjXsyyj6JfP0a2onvRPoW0EzBq3BxwpGGJ
# btML2ST94OmT8huibh8Cp2TnbAAxIhNU0tN3XMz2AXfJT5cr4MdHGDksiMj1Hcjn
# wxXAf6uYX3+jovGZbgpog0KUk88p2vhU1oZP0YpaRaOqnjUH+Ml4g1fOx8siBmGu
# vs9L+Kb5w2W8TjCBuGqGY4d8chxQe8A0ViZtp4LB+/1NAkt14GTwqOdWrKNIynMz
# Rpa+Wkey1J0tG5AhNp0hvwmAO6KFSGtXHuNWwua9IpLMJsowj2U2TmzqLSDC2YrO
# BgC97m41lByepRPQwnnV3p8NFn4CyTGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQbsRA190DwbdBuskmJyNY4jAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUXOwf8ot1o5Imyt0ktizWXo74LVswDQYJKoZIhvcNAQEBBQAEggEAcbgM
# /KEdyvz4BHq9OrqTajMVdbtXEoSDNk38iHhFeIYqMGTzhEDcFIHsI+SDpQ1lz4o2
# NhFAajVIyXx1cJFjoI2xdG7y3IE6Hnus+M4GwdynRosvSEy4TlM/066gIXI7jX+V
# zMjn3tSTtYPlZFPI33YwJt/NP4Oobub+QvtAY2vaMPTQg+C3AHmUPEqJcdnVHSdA
# G+jF0ilPrR38Jub9ocEyIzkr/FNzqiCTHzDYQIxzXTPWgPakBBuiPnSMYv+qonSh
# aFcjajntedeWElkagyj1RZiqCYBz1EY/Z5Igobqfjz2v6RgJojmQGRmrwK6oSr5C
# 40+VQoHzPfGxYHdcwA==
# SIG # End signature block
