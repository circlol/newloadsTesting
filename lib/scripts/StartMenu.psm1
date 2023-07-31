Function Set-StartMenu () {
    # Kills explorer to apply start menu
    Taskkill /f /im explorer.exe
    $Windows11BuildVersion = "22000"
    If ($SYSTEMOSVERSION -ge $Windows11BuildVersion) 
    {
    # - Applies start menu layout for Windows 11 22H2+
        Write-Section -Text "Applying Start Menu Layout"
        Write-Status -Types "+", $TweakType -Status "Generating Layout File"
        $StartBinFiles = Get-ChildItem -Path ".\assets" -Filter "*.bin" -File
        $TotalBinFiles = $StartBinFiles.Count * 2
        for ($i = 0; $i -lt $StartBinFiles.Count; $i++) {
            $StartBinFile = $StartBinFiles[$i]
            $progress = ($i * 2) + 1
            Write-Status -Types "+", $TweakType -Status "Copying $($StartBinFile.Name) for new users ($progress/$TotalBinFiles)" -NoNewLine
            xcopy $StartBinFile.FullName $StartBinDefault /y
            Check
            Write-Status -Types "+", $TweakType -Status "Copying $($StartBinFile.Name) to current user ($($progress+1)/$TotalBinFiles)" -NoNewLine
            xcopy $StartBinFile.FullName $StartBinCurrent /y
            Check
    }
        # Kills StartMenuExperience to apply layout
        Use-Command "taskkill /f /im StartMenuExperienceHost.exe" -Suppress
    }
    elseif ($SYSTEMOSVERSION -Lt $Windows11BuildVersion)
    {
        # - Clears Windows 10 Start Pinned
        Write-Status -Types "-", $TweakType -Status "Clearing Windows 10 Start Menu Pins"
        Remove-StartMenuPins
    }


    Write-Status -Types "+", $TweakType -Status "Applying Taskbar Layout" -NoNewLine
$startlayout = @"
    <LayoutModificationTemplate xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification" 
        xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" 
        xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" 
        xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" 
        Version="1">
        <LayoutOptions StartTileGroupCellWidth="6" />
        <DefaultLayoutOverride>
            <StartLayoutCollection>
                <defaultlayout:StartLayout GroupCellWidth="6" />
            </StartLayoutCollection>
        </DefaultLayoutOverride>
            <CustomTaskbarLayoutCollection PinListPlacement="Replace">
                <defaultlayout:TaskbarLayout>
                    <taskbar:TaskbarPinList>
                        <taskbar:DesktopApp DesktopApplicationID="Chrome" />
                        <taskbar:DesktopApp DesktopApplicationID="Microsoft.Windows.Explorer" />
                        <taskbar:UWA AppUserModelID="windows.immersivecontrolpanel_cw5n1h2txyewy!Microsoft.Windows.ImmersiveControlPanel" />
                        <taskbar:UWA AppUserModelID="Microsoft.SecHealthUI_8wekyb3d8bbwe!SecHealthUI" />
                        <taskbar:UWA AppUserModelID="Microsoft.Windows.SecHealthUI_cw5n1h2txyewy!SecHealthUI" />
                    </taskbar:TaskbarPinList>
                </defaultlayout:TaskbarLayout>
            </CustomTaskbarLayoutCollection>
    </LayoutModificationTemplate>
"@
    # - Removes and replaces start layout
    If (Test-Path $layoutFile) { Use-Command "Remove-Item `"$layoutFile`"" | Out-Null }
    $StartLayout | Out-File $layoutFile -Encoding ASCII ; Check 

    # Locks Start Menu layout before its reloaded
    $regAliases = @("HKLM", "HKCU")
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemPropertyVerified -Path "$keyPath" -Name "LockedStartLayout" -Value "1" -Type DWord
        #Set-ItemPropertyVerified -Path "$keyPath" -Name "StartLayoutFile" -Value "$layoutFile" -Type ExpandString
    }

    # Initiates the change
    Restart-Explorer
    Start-Sleep -Seconds 5
    $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
    Start-Sleep -Seconds 5

    # Unlocks Start Menu layout after the reload
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemPropertyVerified -Path "$keyPath" -Name "LockedStartLayout" -Value "0" -Type DWord
    }
}

# SIG # Begin signature block
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUL/FM7Or8O83OcoM8uxtvXix/
# jXSgggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFMN+jNbo/oUxvepwASb5xYGGtF50MA0GCSqGSIb3DQEB
# AQUABIIBACkzC/OfJePIVTwQypvZWZav6ZAu1xZdl3gayr2t+P19WdwlpYkxT0cL
# Rm/p/HpRBDEmsiSiuS0PtMzmkZp3vyPfo415uhmio2LjP6TR2FR+mSGxzOU1uk/Y
# Oo6DWG0zt0xoG0QGthUS3QpVMDLiAVr1B9UTZe12tbIhPD5s1F1ItUYdzUV3wgWk
# 9BUhz6aQxp7bzXpAXHldkZ0CB3cfzJtJ4c5u5D22YIG0UtAMpzpmD9vpylYjbaTB
# Eu6kcKZ0QeK5PAIh9yeVpii/XiRaeeIsGg12JKdr03z57DeNc1+fG/l21UlF0lAR
# X9aydCGN5QEMBlZDLhfrfc5V31+ZJJc=
# SIG # End signature block
