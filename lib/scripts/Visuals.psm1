Function Set-Visuals() {
    Write-Status -Types "+", $TweakType -Status "Applying Wallpaper"
    Write-HostReminder "Wallpaper may not apply until computer is Restarted"
    New-Variable -Name "WallpaperPath" -Value ".\assets\mother.jpg" -Scope Global -Force
    # - Copies wallpaper to roaming themes folder
    Use-Command "Copy-Item -Path `"$WallpaperPath`" -Destination `"$wallpaperDestination`" -Force"
    # - Sets wallpaper to fit to display
    # - Sets wallpaper
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value "2" -Type String
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $wallpaperDestination -Type String
    # - Sets system to light mode
    Set-ItemPropertyVerified -Path "$PathToRegPersonalize" -Name "SystemUsesLightTheme" -Value "1" -Type DWord
    Set-ItemPropertyVerified -Path "$PathToRegPersonalize" -Name "AppsUseLightTheme" -Value "1" -Type DWord
    # - Triggers a user system parameter refresh - Sometimes this can trigger the wallpaper to apply without reboot.
    # - Regardless it will apply on reboot
    Use-Command "Start-Process `"RUNDLL32.EXE`" `"user32.dll, UpdatePerUserSystemParameters`""
    Use-Command "Start-Process `"RUNDLL32.EXE`" `"user32.dll, UpdatePerUserSystemParameters`""
    If ($?) { Write-Status -Types "+", "Visual" -Status "Wallpaper Set`n" } 
    elseif (!$?) { Write-Status -Types "?", "Visual" -Status "Error Applying Wallpaper`n" -WriteWarning }else { }
}

# SIG # Begin signature block
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU844k1X4PsJ5vkkfcWM2f6+YX
# 7AKgggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFO4CAM04KUyPSByVtaHX3AubOCjtMA0GCSqGSIb3DQEB
# AQUABIIBAKxoSYLmbTjJ6LUkWbbNRWnoJBCWo2MBFgR4B9f3XJOjaV3+WKmVMiLH
# f2xpjjDoG39a3QS3QcuhvX6dnHu2onv9l/naVhfyvAXhXklFQz8weNtUSMKBJQ1t
# jMHtOq773Iesdat7Ekg1XvPe80uJXdkFv1sVeU0dBNnk9G4/vYreCAESThZYpSkk
# KNb+0JaIkRnwOdI8CMXO+/Laj+AfXCOFoMrFQwO//iq0C0r90v/D2SrOSelJWD/G
# EdqpKUHSGUKP54ktmmPaYJI49aP+nKB9GQ3z2uA/oIS8YrEEpwzRxDkL2ratNI7Z
# BPQkSX/zBER8BwzoG//k2M/2fHcwTmU=
# SIG # End signature block
