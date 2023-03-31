
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
    Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True

    Write-Section "Windows Defender"
    Write-Status -Types "?", $TweakType -Status "If you already use another antivirus, nothing will happen." -Warning
    Write-Status -Types "+", $TweakType -Status "Ensuring your Windows Defender is ENABLED..."
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWORD -Value 0
    Set-MpPreference -DisableRealtimeMonitoring $false -Force

    Write-Status -Types "+", $TweakType -Status "Enabling Microsoft Defender Exploit Guard network protection..."
    Set-MpPreference -EnableNetworkProtection Enabled -Force

    Write-Status -Types "+", $TweakType -Status "Enabling detection for potentially unwanted applications and block them..."
    Set-MpPreference -PUAProtection Enabled -Force

    Write-Section "SmartScreen"
    Write-Status -Types "+", $TweakType -Status "Enabling 'SmartScreen' for Microsoft Edge..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesEdge\PhishingFilter" -Name "EnabledV9" -Type DWord -Value 1

    Write-Status -Types "+", $TweakType -Status "Enabling 'SmartScreen' for Store Apps..."
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Type DWord -Value 1

    Write-Section "Old SMB Protocol"
    # Details: https://techcommunity.microsoft.com/t5/storage-at-microsoft/stop-using-smb1/ba-p/425858
    Write-Status -Types "+", $TweakType -Status "Disabling SMB 1.0 protocol..."
    Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force

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

    Write-Section "Microsoft Store"
    Disable-SearchAppForUnknownExt

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
# MIIKUQYJKoZIhvcNAQcCoIIKQjCCCj4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUoQ54fUBjXedqk+r8ZeY/nl/A
# vPegggZWMIIGUjCCBDqgAwIBAgIQIs9ET5TBkYlFoLQHAUEE/jANBgkqhkiG9w0B
# AQsFADCBrjELMAkGA1UEBhMCQ0ExCzAJBgNVBAgMAkJDMREwDwYDVQQHDAhWaWN0
# b3JpYTEeMBwGCSqGSIb3DQEJARYPY2lyY2xvbEBzaGF3LmNhMScwJQYJKoZIhvcN
# AQkBFhhtaWtlQG1vdGhlcmNvbXB1dGVycy5jb20xIjAgBgNVBAoMGUNvbXB1dGVy
# IE9ubHkgUmV0YWlsIEluYy4xEjAQBgNVBAMMCU5ldyBMb2FkczAeFw0yMzAyMDgw
# MjIwMzVaFw0yNDAyMDgwMjQwMzVaMIGuMQswCQYDVQQGEwJDQTELMAkGA1UECAwC
# QkMxETAPBgNVBAcMCFZpY3RvcmlhMR4wHAYJKoZIhvcNAQkBFg9jaXJjbG9sQHNo
# YXcuY2ExJzAlBgkqhkiG9w0BCQEWGG1pa2VAbW90aGVyY29tcHV0ZXJzLmNvbTEi
# MCAGA1UECgwZQ29tcHV0ZXIgT25seSBSZXRhaWwgSW5jLjESMBAGA1UEAwwJTmV3
# IExvYWRzMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAv5qzNh/aVKRC
# eVOxL0BYxOViVa1zVcjL1/IghB+c+q51dcX2qbGTDiBOMWKGP4pEnN2XrEtAXESo
# vdGlM9If/wQs/ohhDh3sf7YuwH2ay15RIW2DjGKzGVhgvrvbIRnM/p26Cks1JZjV
# FxgSin6vYP77lRGAMWMsNGUplxKJpGdH1YTeIEg3foXVMv78bwBjEoCbC7cwi039
# nz2NS2ZH4evDSjTwh66UkDSNN1H5zsmQPcVPfXN1UabaUmfLhXreww4NmmxFFE/H
# t0t2tZk50BKbkY9Twj8khGjJsVTHBu0RhXwXPC/RN1iOZeNOOurzNk8TXBPPM87r
# fpC8AIwbXtEvmCEEGkivm5VwZ3LR6/fFmKXRp2NsFk5Sh4tvRFQXzbmoPVimoK/7
# d6TlCYyn7Z17zQGQWraO3U55zEjurBABvJ2toeDRzUcF4bekgTlLBw0aoqVhh5DY
# wakTFNzyPLJPfrM8o4OybtUXtswQk4PBSRJp2Jjc4ZUy5qxr+YNqfu2Lm8oxmLc3
# hkSJYx9qlWE9hn2Qkc+S7+Ld0BhDhjWAOFim1qjXDw/5jXvixwJ2zbaacvd/mCg9
# NVQMv5QYXv4EGtoTD5CvNUxIOpRhXX2RoKIyWMLQU/+V9Qk8p3WQzjzZRXqqjNtX
# nfKjmTuye5RU9NxmOG+Evh6i9vbU9l0CAwEAAaNqMGgwDgYDVR0PAQH/BAQDAgeA
# MBMGA1UdJQQMMAoGCCsGAQUFBwMDMCIGA1UdEQQbMBmCF3d3dy5tb3RoZXJjb21w
# dXRlcnMuY29tMB0GA1UdDgQWBBQBOiQX6wdanCPoLrJWg1U8QWjqGTANBgkqhkiG
# 9w0BAQsFAAOCAgEAJilnAd6e5NPMVNH5fC6zAwn+ey8x/IM87z30BjoxGVRWexsC
# PtgGOw770LCKK8ONpTILyIAXapZ8HDDtPMja8QR7bds2qIOqgsiL3hylSe7UcryZ
# KBvpiHJIJOE7vIxZdrmuOIHMai0pK9BTQsGbZGrR0sYeUjLDOwodIuc8ccnuPoNd
# HouHpHl1v3fBXn2/q0Hro+bWp4YHby4s7zPl+OGFLWl1kDkLtVfw81m9g9fqrhN2
# tofGL1vSM2Zg5GhLjFHkGedkGFFes8Oldf0GbfgHEFk7dVgjCxyRo2hZuMwn6DFc
# Oy2G2QjULRv6avqiEyYzdHpBGMvfuP9UWm2rBHoajk4rsb4Sajg1xpppKk9ZJPNR
# 2SenGSEK1qhT4R2F9M68x50pdL2A1ufqU3UOlH8OfwYi1+8sUBS/0wCPgaqLut7P
# k1b6D/brIIqxmlOfK+fmb0rKWlQgakQN5+CmR89bX5owalu5kgH7VcFS9ygjBAlA
# 87U650B0IwnZzeooAEP4TjUnJbVXAykIsjRGl4JzF26tJTQSwF3SLqdLyfi0ZfrO
# FcZoYEkfJLdoxHQ6DLCY9DAz09wNp7W9rERyBO7psdlC9x7VDo/LJFgh3uTtykuy
# ximtLfYl64Yws9XVpRgTSbtFZ6xFPgP5MkDP82UKpZ5UghoRHvDToLmxJCAxggNl
# MIIDYQIBATCBwzCBrjELMAkGA1UEBhMCQ0ExCzAJBgNVBAgMAkJDMREwDwYDVQQH
# DAhWaWN0b3JpYTEeMBwGCSqGSIb3DQEJARYPY2lyY2xvbEBzaGF3LmNhMScwJQYJ
# KoZIhvcNAQkBFhhtaWtlQG1vdGhlcmNvbXB1dGVycy5jb20xIjAgBgNVBAoMGUNv
# bXB1dGVyIE9ubHkgUmV0YWlsIEluYy4xEjAQBgNVBAMMCU5ldyBMb2FkcwIQIs9E
# T5TBkYlFoLQHAUEE/jAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAA
# oQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4w
# DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUTfxSo7Jf6iytOeC3CoVVgKzx
# 8lYwDQYJKoZIhvcNAQEBBQAEggIADdJF+dwAKSdYIkUjTThY9zPNLQhnb5dJV8ol
# vCQSVb6guIfKcd2l/KGCR2mrs3YIR9HH+qfk22Zpc3tKRXEa0Dl5Fo7m+ZQL4QfQ
# Pinv9MYmDUr+1cQwmllAmEHgTB0CdFz6kft7tdfvyj8SxCaX8LTXDbLTD4Z7WvzY
# bTX+Ok6OlgQmiDUq8HQfq/6sgQcjegPw0SXzRqXOYmAJX4N98CzoQx2Zr2mjH6gP
# SCNlz3Y7XUPQc0yXF/4QlebZUEdxLCQQS5eQmA0eByNehTKmtZav9pWcgb2OU7Na
# +Puy/tS3PZPVW9pjZREt4i524Ayg/uoOhhV7p/OOXy/z+J2YRwoHIzCoMU5SPj1b
# vTrxsLapvML1VWJ/9nVN2x8XrTlRECtWW6U6Tn0wev0Y6h/nESE/yAgEkLxnFbbf
# xMC6HSp/LFXd6Wwu1dgig+ZaWcVLWCUVCFqc6YUBCGagHlTb2HgyCdFP/GGgFeIS
# fk6UdJmphclYVldEazLl8Ahg2X6Idj0w1+HdOcY23QsZbnzGYiLYBokMNBFooOA4
# se+ACauglaoISVY9p8764UKMMw42OwUyCBPgKIlUa4nt6JsZ8X5IzMACiw24T5pV
# p7snLrEiLVp//s+qNvWC8f7oz+aX4TAAN8VgeNv9qca3ohMLOrXseeA8D/DaBIkA
# w7+wUAM=
# SIG # End signature block
