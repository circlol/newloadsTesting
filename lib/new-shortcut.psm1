$Global:NewShortcutLastUpdated = '20220829'
# Adapted From: https://shellgeek.com/create-shortcuts-on-user-desktop-using-powershell/
# Short circuit code: https://stackoverflow.com/a/26768902

function New-Shortcut() {
    [CmdletBinding()]
    param (
        [String] $SourcePath,
        [String] $ShortcutPath = "$([Environment]::GetFolderPath("Desktop"))\$((Split-Path -Path $SourcePath -Leaf).Split('.')[0]).lnk",
        [Parameter(Mandatory = $false)]
        [String] $Description = "Opens $(Split-Path -Path $SourcePath -Leaf)",
        [Parameter(Mandatory = $false)]
        [String] $IconLocation = "$SourcePath, 0",
        [Parameter(Mandatory = $false)]
        [String] $Arguments = '',
        [Parameter(Mandatory = $false)]
        [String] $Hotkey = '',
        [Parameter(Mandatory = $false)]
        [String] $WindowStyle = 1 # I'm not sure, but i'll take the UI as example: 1 = Normal, 2 = Minimized, 3 = Maximized
    )

    If (!(Test-Path -Path (Split-Path -Path $ShortcutPath))) {
        Write-Status -Types "?" -Status "$((Split-Path -Path $ShortcutPath)) does not exist, creating it..."
        New-Item -Path (Split-Path -Path $ShortcutPath) -ItemType Directory -Force
    }

    $WScriptObj = New-Object -ComObject ("WScript.Shell")
    $Shortcut = $WScriptObj.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = $SourcePath

    If ($Hotkey) {
        $Shortcut.Description = "$Description ($Hotkey)"
    } Else {
        $Shortcut.Description = $Description
    }

    $Shortcut.Arguments = $Arguments
    $ShortCut.Hotkey = $Hotkey
    $Shortcut.IconLocation = $IconLocation
    $Shortcut.WindowStyle = $WindowStyle

    $Shortcut.Save()
}

<#
"$env:SystemRoot\System32\shell32.dll, 27"         >>> 27 or 215 is the number of icon to shutdown in SHELL32.dll
"$env:SystemRoot\System32\imageres.dll, 2"         >>> Icons from Windows 10
"$env:SystemRoot\System32\pifmgr.dll, 2"           >>> Icons from Windows 95/98
"$env:SystemRoot\explorer.exe, 2"                  >>> Icons from Windows Explorer
"$env:SystemRoot\System32\accessibilitycpl.dll, 2" >>> Icons from Accessibility
"$env:SystemRoot\System32\ddores.dll, 2"           >>> Icons from Hardware
"$env:SystemRoot\System32\moricons.dll, 2"         >>> Icons from MS-DOS
"$env:SystemRoot\System32\mmcndmgr.dll, 2"         >>> More Icons from Windows 95/98
"$env:SystemRoot\System32\mmres.dll, 2"            >>> Icons from Sound
"$env:SystemRoot\System32\netshell.dll, 2"         >>> Icons from Network
"$env:SystemRoot\System32\netcenter.dll, 2"        >>> More Icons from Network
"$env:SystemRoot\System32\networkexplorer.dll, 2"  >>> More Icons from Network and Printer
"$env:SystemRoot\System32\pnidui.dll, 2"           >>> More Icons from Status in Network
"$env:SystemRoot\System32\sensorscpl.dll, 2"       >>> Icons from Distinct Sensors
"$env:SystemRoot\System32\setupapi.dll, 2"         >>> Icons from Setup Wizard
"$env:SystemRoot\System32\wmploc.dll, 2"           >>> Icons from Player
"$env:SystemRoot\System32\System32\wpdshext.dll, 2">>> Icons from Portable devices and Battery
"$env:SystemRoot\System32\compstui.dll, 2"         >>> Classic Icons from Printer, Phone and Email
"$env:SystemRoot\System32\dmdskres.dll, 2"         >>> Icons from Disk Management
"$env:SystemRoot\System32\dsuiext.dll, 2"          >>> Icons from Services in Network
"$env:SystemRoot\System32\mstscax.dll, 2"          >>> Icons from Remote Connection
"$env:SystemRoot\System32\wiashext.dll, 2"         >>> Icons from Hardware in Image
"$env:SystemRoot\System32\comres.dll, 2"           >>> Icons from Actions
"$env:SystemRoot\System32\comres.dll, 2"           >>> More Icons from Network, Sound and logo from Windows 8
#>
# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUv/KO+sOCbf9k+0Lqkh/gUSJG
# 0OagggMQMIIDDDCCAfSgAwIBAgIQbsRA190DwbdBuskmJyNY4jANBgkqhkiG9w0B
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
# CQQxFgQUZB7omcDVVHhiKgsS92UL36NNBzgwDQYJKoZIhvcNAQEBBQAEggEAPyLy
# 4v1nY/2nmJwP3hMAs4xbbiybyoCbDXgF0PVd3wA+lWJKCRUhopmjOsE09Ls8K8cO
# DPsMszH2XXd/I5kY0WZ4y+7Pn0cXIWwW83aryYTY6hqjdTErRWoI106sfK3+bxAV
# aVSwL/uv58WvMEmRZihIv1dAtWprhoDQiDaJt0th9bRF0RPRwj2hHuofvPSKH0Fu
# foOLu3GkxNLL3LwLH0YPbdUsqF7BW+xqzv1veI5bN6Knp3hxr7A92UKGbQb3y0iE
# DagbH6/apKAPWlHxTIhuEl2X5lxI0aeO7P+fRpEmQTNxHfz+4Zx33Q9Jcj1sh2fX
# vhNuHrs2EFbY2+6ENQ==
# SIG # End signature block
