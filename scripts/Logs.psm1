Function Send-EmailLog() {
    # - Stops Transcript
    Stop-Transcript
    Write-Section -Text "Gathering Logs "
    Write-Caption -Text "System Statistics"
    # - Current Date and Time
    $CurrentDate = Get-Date
    $EndTime = Get-Date -DisplayHint Time
    $ElapsedTime = $EndTime - $StartTime

    # - Gathers some information about host
    $CPU = Get-CPU
    $GPU = Get-GPU
    $RAM = Get-RAM
    $SSD = Get-OSDriveType
    [String]$SystemSpec = Get-SystemSpec
    $SystemSpec | Out-Null
    $Mobo = (Get-CimInstance -ClassName Win32_BaseBoard).Product
    $IP = $(Resolve-DnsName -Name myip.opendns.com -Server 208.67.222.220).IPAddress
    $Displayversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "DisplayVersion").DisplayVersion
    $WindowsVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
    $DriveSpace = Get-DriveSpace
    Get-ComputerInfo | Out-File -Append $log -Encoding ascii


    # - Removes unwanted characters and blank space from log file
    Write-Caption -Text "Cleaning $Log"
    $logFile = Get-Content $Log
    $pattern = "[\[\]><\+@),|=]"
    # - Replace the unwanted characters with nothing
    $newLogFile = $logFile -replace $pattern
    # - Remove empty lines
    $newLogFile = ($newLogFile | Where-Object { $_ -match '\S' }) -join "`n"
    Set-Content -Path $Log -Value $newLogFile

    # - Cleans up Motherboards Output
    Write-Caption -Text "Generating New Loads Summary"
    If ($CurrentWallpaper -eq $Wallpaper) { $WallpaperApplied = "YES" }Else { $WallpaperApplied = "NO" }
    $TempFile = "$Env:Temp\tempmobo.txt" ; $Mobo | Out-File $TempFile -Encoding ASCII
    (Get-Content $TempFile).replace('Product', '') | Set-Content $TempFile
    (Get-Content $TempFile).replace("  ", '') | Set-Content $TempFile
    $Mobo = Get-Content $TempFile
    Remove-Item $TempFile

    # - Checks if all the programs got installed
    $CheckChrome = Find-InstalledPrograms -Keyword "Google Chrome"
    If (!$CheckChrome){ $ChromeYN = "NO" } Else { $ChromeYN = "YES" }
    $CheckVLC = Find-InstalledPrograms -Keyword "VLC"
    If (!$CheckVLC){ $VLCYN = "NO" } Else { $VLCYN = "YES" }
    $CheckZoom = Find-InstalledPrograms -Keyword "Zoom"
    If (!$CheckZoom){ $ZoomYN = "NO" } Else { $ZoomYN = "YES" }
    $CheckAcrobat = Find-InstalledPrograms -Keyword "Acrobat"
    If (!$CheckAcrobat){ $AdobeYN = "NO"} Else { $AdobeYN = "YES"}

    # - Joins log files to send as attachments
    $LogFiles = @()
    if (Test-Path -Path ".\Log.txt") {
    $LogFiles += ".\Log.txt"
    }
    if (Test-Path -Path ".\ErrorLog.txt") {
    $LogFiles += ".\ErrorLog.txt"
    }

    # - Cleans packages removed text and adds it to email
    ForEach ($Package in $PackagesRemoved) {
        Write-Host "$Package"
        $PackagesRemovedOutput = "$PackagesRemovedOutput" + "`n - $Package"
    }

    # - Email Settings
    $smtp = 'smtp.shaw.ca'
    $To = '<newloads@shaw.ca>'
    $From = 'New Loads Log <newloadslogs@shaw.ca>'
    $Sub = "New Loads Log"
    $EmailBody = "
    ############################
    #   NEW LOADS SCRIPT LOG   #
    ############################

New Loads was run on a computer for $ip\$env:computername\$env:USERNAME

On this computer for $Env:Username, New Loads completed in $elapsedtime. This system is equipped with a $cpu, $ram, $gpu

- Script Information:
    - Date: $CurrentDate
    - Elapsed Time: $ElapsedTime
    - Start Time: $StartTime
    - End Time: $EndTime
    - Program Version: $ProgramVersion
    - Script Version: $ScriptVersion

- Computer Information:
    - CPU: $CPU
    - Motherboard: $Mobo
    - RAM: $RAM
    - GPU: $GPU
    - SSD: $SSD
    - Drive Space: $DriveSpace free
    - OS: $WindowsVersion ($DisplayVersion)

- Script Run Information:
    - Applications Installed: $appsyns
    - Chrome: $ChromeYN
    - VLC: $VLCYN
    - Adobe: $AdobeYN
    - Zoom: $ZoomYN
    - Wallpaper Applied: $WallpaperApplied
    - Windows 11 Start Layout Applied: $StartMenuLayout
    - Registry Keys Modified: $ModifiedRegistryKeys
    - Packages Removed During Debloat: $Removed
    $PackagesRemovedOutput
"

    Write-Caption -Text "Sending log + hardware info home"
    # - Sends the mail
    Send-MailMessage -From $From -To $To -Subject $Sub -Body $EmailBody -Attachments $LogFiles -DN OnSuccess, OnFailure -SmtpServer $smtp -EA SilentlyContinue 
    # - Registry Backup - Compressed, usually ~30mb. Sends directly home
    Send-BackupHome
}
# SIG # Begin signature block
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU1kc/7QkmaRCo0IG/DVpwqoeB
# iqagggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFL4L+V55PfF8H904fFOnmar88J9RMA0GCSqGSIb3DQEB
# AQUABIIBAK6KW5+i9/VgGIOao8QkcWZDvf75QPIRb+ykpzQtdfzvvX5LC7FSU5Mg
# 1FcjDxItp3DdIjRBcXsg8xYFnadOib6OJJSYLHOSNl8CDwVqrrhSt55XKzTJmrmx
# 1EhFFlMtmzK55NcPfPYUwx4/3gfZJlxqtSi/oj4aLVr5r+jx1tbFvL+8qHk/d/Zy
# Xy+tP5CWoU2OBLePlUVA98AifaeFebwNNoSlIk/pAoMRb9XsOkgx5hmk/lJ5kuud
# lLpOqOYj1FAp7yGTqRPI3jUYFuBpfHKPjiQ1pO4it2s8SkPFqhB8AtWg5aworirl
# F3XTkUgAaQaqk3zdenu23PkesXgTYkY=
# SIG # End signature block
