
Function Optimize-Security() {

    $TweakType = "Security"
    # Initialize all Path variables used to Registry Tweaks
    $PathToLMPoliciesEdge = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge"
    $PathToLMPoliciesMRT = "HKLM:\SOFTWARE\Policies\Microsoft\MRT"
    $PathToCUExplorer = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
    $PathToCUExplorerAdvanced = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

    Write-Title "Security Tweaks"

    Write-Section "Windows Firewall"
    Write-Status -Types "+", $TweakType -Status "Enabling default firewall profiles..."
    Use-Command 'Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True'

    Write-Section "Windows Defender"
    Write-Status -Types "?", $TweakType -Status "If you already use another antivirus, nothing will happen." -Warning
    Write-Status -Types "+", $TweakType -Status "Ensuring your Windows Defender is ENABLED..."
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWORD -Value 0
    Use-Command 'Set-MpPreference -DisableRealtimeMonitoring $false -Force'

    Write-Status -Types "+", $TweakType -Status "Enabling Microsoft Defender Exploit Guard network protection..."
    Use-Command 'Set-MpPreference -EnableNetworkProtection Enabled -Force'

    Write-Status -Types "+", $TweakType -Status "Enabling detection for potentially unwanted applications and block them..."
    Use-Command 'Set-MpPreference -PUAProtection Enabled -Force'

    Write-Section "SmartScreen"
    Write-Status -Types "+", $TweakType -Status "Enabling 'SmartScreen' for Microsoft Edge..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesEdge\PhishingFilter" -Name "EnabledV9" -Type DWord -Value 1

    Write-Status -Types "+", $TweakType -Status "Enabling 'SmartScreen' for Store Apps..."
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Type DWord -Value 1

    Write-Section "Old SMB Protocol"
    # Details: https://techcommunity.microsoft.com/t5/storage-at-microsoft/stop-using-smb1/ba-p/425858
    Write-Status -Types "+", $TweakType -Status "Disabling SMB 1.0 protocol..."
    Use-Command 'Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force'

    Write-Section "Old .NET cryptography"
    # Enable strong cryptography for .NET Framework (version 4 and above) - https://stackoverflow.com/a/47682111
    Write-Status -Types "+", $TweakType -Status "Enabling .NET strong cryptography..."
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1

    Write-Section "Autoplay and Autorun (Removable Devices)"
    Write-Status -Types "-", $TweakType -Status "Disabling Autoplay..."
    Set-ItemPropertyVerified -Path "$PathToCUExplorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1

    Write-Status -Types "-", $TweakType -Status "Disabling Autorun for all Drives..."
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 255

    #Write-Section "Microsoft Store"
    #Disable-SearchAppForUnknownExt

    Write-Section "Windows Explorer"
    Write-Status -Types "+", $TweakType -Status "Enabling Show file extensions in Explorer..."
    Set-ItemPropertyVerified -Path "$PathToCUExplorerAdvanced" -Name "HideFileExt" -Type DWord -Value 0

    Write-Section "User Account Control (UAC)"
    # Details: https://docs.microsoft.com/en-us/windows/security/identity-protection/user-account-control/user-account-control-group-policy-and-registry-key-settings
    Write-Status -Types "+", $TweakType -Status "Raising UAC level..."
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 5
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 1

    Write-Section "Windows Update"
    # Details: https://forums.malwarebytes.com/topic/246740-new-potentially-unwanted-modification-disablemrt/
    Write-Status -Types "+", $TweakType -Status "Enabling offer Malicious Software Removal Tool via Windows Update..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesMRT" -Name "DontOfferThroughWUAU" -Type DWord -Value 0

    Write-Status -Types "?", $TweakType -Status "For more tweaks, edit the '$PSCommandPath' file, then uncomment '#SomethingHere' code lines" -Warning
    # Consumes more RAM - Make Windows Defender run in Sandbox Mode (MsMpEngCP.exe and MsMpEng.exe will run on background)
    # Details: https://www.microsoft.com/security/blog/2018/10/26/windows-defender-antivirus-can-now-run-in-a-sandbox/
    #Write-Status -Types "+", $TweakType -Status "Enabling Windows Defender Sandbox mode..."
    #setx /M MP_FORCE_USE_SANDBOX 1  # Restart the PC to apply the changes, 0 to Revert

    # Disable Windows Script Host. CAREFUL, this may break stuff, including software uninstall.
    #Write-Status -Types "+", $TweakType -Status "Disabling Windows Script Host (execution of *.vbs scripts and alike)..."
    #Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows Script Host\Settings" -Name "Enabled" -Type DWord -Value 0
}





# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUpcYlvxhapPH97/Q+qeBu6Uj3
# 6gGgggMQMIIDDDCCAfSgAwIBAgIQOtpMekE2BIRJ/swv2v8NGDANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIzMDUzMTA0
# MjM1NVoXDTI0MDUzMTA0NDM1NVowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMWf9Y3819xnY6KW
# p0CYtLc6vBDWMvATfsxnp3dXzZ1umVRwI0tqKQ3yTursULPsAZIBm06zN+N74hnR
# +xncqME0LwdqFrodwLlmIso0Cbe70iif+fd3ySrdpHXZQVJfFySPyPjOoq9Mfeo9
# 3hPE6gh28dBRG+KmDukamTHgxhkZ6w4JvYRAFJs3xwucH0FhGsDlQAji9zs636tp
# N9amsVCZy3FfNajYRrVHvOf+0nzch5dRuHw4hQMr8wo6oQhrUskx9eeqxzvAZUI4
# wPqwfOEa9Fcqrz2LWRZmvLVaw1Ci/YQ4+caJwmktMnR1wntmaPzwAkcq1v+fP9ql
# DJqR3P0CAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBS6ttW6EPvULmOEpRijcxJtJnpZxzANBgkqhkiG9w0BAQsF
# AAOCAQEAicq1fzgkUi8pCtZ3HwRrnajPLjralGKmgN0IOuBB697YfSjKOb8QFRDa
# vCNQRrfzzhYalhy1uU9AQS88wZA7OYFa6bDgFMpBGZ3BZ7MPzUUKLzYVR5S5jF+v
# gIaE6UWdLVpzUZGSkdpYjnEHnGZ5Yp/ZOQhh49C+FX0q/VM8reyf/SThhvTZV6jO
# Nflhk26fANgDSkh8btwnGnpXlV7fafrXlcSkfP/2M3HQER3/ziDdQGzb76b1YS8o
# lL8E0Lk1jMp2qh37ro4LpEpMsFGOtx4cRXwR4N1KG+nqjjk7fEEVGAbaaipypQnP
# 2aAxrMDxbK+nA3RHwMmuoX+ION3gXTGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQOtpMekE2BIRJ/swv2v8NGDAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQU39kdyeO7KkweznND/6RY5sNuN4kwDQYJKoZIhvcNAQEBBQAEggEAnFd6
# LCeDMadZ8gXcneHMv51gKMKDDWrbtES6kJ7xIxt3KRxlTM1PbZgSNH7gqlu+vhLD
# E5ckANjdyD+5kYSzVcPeNUgQEtZ6Y5aiL9nrvtl/1WJk9t5M0/KXJrs9+FMKtM3R
# em9g1fEropwK/UhtweQTc1VCISsiwQ+xu07CUjpKzdzorrgVZEhnNsEmYyprRf+e
# J4FIvdfDi2YOrPX41H+MWDAFDxZXXTSMsDaWUwX2abpORmP5654Q+FDjpxASq11L
# pSGJfNWfV6+4DCtpbNRGZPdcaIM1CaS2atmnoplE2lbz8LC1qXQSVlk/Z8DQNkhz
# i0tPI5lmfIxGwxuF8Q==
# SIG # End signature block
