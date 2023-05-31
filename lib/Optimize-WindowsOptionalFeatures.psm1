Function Optimize-WindowsOptionalFeatures{
# Code from: https://github.com/LeDragoX/Win-Debloat-Tools/blob/main/src/scripts/optimize-windows-features.ps1
$DisableFeatures = @(
    "FaxServicesClientPackage"             # Windows Fax and Scan
    "IIS-*"                                # Internet Information Services
    "Internet-Explorer-Optional-*"         # Internet Explorer
    "LegacyComponents"                     # Legacy Components
    "MediaPlayback"                        # Media Features (Windows Media Player)
    "MicrosoftWindowsPowerShellV2"         # PowerShell 2.0
    "MicrosoftWindowsPowershellV2Root"     # PowerShell 2.0
    #"Printing-PrintToPDFServices-Features" # Microsoft Print to PDF
    "Printing-XPSServices-Features"        # Microsoft XPS Document Writer
    "WorkFolders-Client"                   # Work Folders Client
    )

$EnableFeatures = @(
    "NetFx3"                            # NET Framework 3.5
    "NetFx4-AdvSrvs"                    # NET Framework 4
    "NetFx4Extended-ASPNET45"           # NET Framework 4.x + ASPNET 4.x
    )

    Write-Title -Text "Optional Features Tweaks"
    Write-Section -Text "Uninstall Optional Features from Windows"

    If ($Revert) {
        Write-Status -Types "*", "OptionalFeature" -Status "Reverting the tweaks is set to '$Revert'." -Warning
        $CustomMessage = { "Re-Installing the $OptionalFeature optional feature..." }
        Set-OptionalFeatureState -Enabled -OptionalFeatures $DisableFeatures -CustomMessage $CustomMessage
    } Else {
        Set-OptionalFeatureState -Disabled -OptionalFeatures $DisableFeatures
    }

    Write-Section -Text "Install Optional Features from Windows"
    Set-OptionalFeatureState -Enabled -OptionalFeatures $EnableFeatures


    Write-Section -Text "Removing Unnecessary Printers"
    $printers = "Microsoft XPS Document Writer", "Fax", "OneNote"
    foreach ($printer in $printers) {
        try {
            Remove-Printer -Name $printer -ErrorAction Stop
            Write-Status -Types "-", "Printer" -Status "Removed $printer..."
        } catch {
            Write-Status -Types "?", "Printer" -Status "Failed to remove $printer : $_" -Warning
        }
    }


}
# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUGE8we+X7aiiObQB7iik+MO6h
# ht+gggMQMIIDDDCCAfSgAwIBAgIQOtpMekE2BIRJ/swv2v8NGDANBgkqhkiG9w0B
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
# CQQxFgQUsk3jpbVmduf9OwABt4iOdHij0i4wDQYJKoZIhvcNAQEBBQAEggEAbgI7
# hf7WBF1ROZdfYpwmAtYAcW5l7NqQNiTLhBjot+4iJxBgE99hjdV4dqDrnKM1b3aj
# plojXsW4fvuQnm/7HHdFBMPVLr/Vc1YVirDLFpvSdTcfnUvJCaU98/E3cTeXw0t4
# GISEQA3oqm3EZqqbGcbj9rvBvTygQVs5NiIwhL0qoHTQqgpTncCrxrtfquqlkorK
# 8KYTWm0luVhym/Pv3LhZwEgnqt90kiMsM2z8192mo8p8IHPQ2oH23mdqHUg3bXkl
# tBr3BLAS1t2DvoOdmT3VDGtaq0QFkse/9GIv8Ax1GzGS6VI69Wac7zPVH3HKZ3eA
# xA7OTWlw0Cpl5/F3ng==
# SIG # End signature block
