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
# MIIKUQYJKoZIhvcNAQcCoIIKQjCCCj4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUGE8we+X7aiiObQB7iik+MO6h
# ht+gggZWMIIGUjCCBDqgAwIBAgIQIs9ET5TBkYlFoLQHAUEE/jANBgkqhkiG9w0B
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
# DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUsk3jpbVmduf9OwABt4iOdHij
# 0i4wDQYJKoZIhvcNAQEBBQAEggIAMhgrD3y84ivNBHCnpcltLmYxRgBP0hzGulFX
# +0YtA3yEgLskOk4xBd9fRH7qWFhoZNqV2Upk4WX5LYT2tupENM5GyVDO5Nlx1r3h
# 9U26mBPFbVSMgzzzwE/dqrM+mVVcKcTOMllI37LTGQYo9UIuJlIANDogWUTehBKP
# CXUh7bs+NmU1HzSzm/YmcKq/Ntt8TpubpoPykR+l7JvntYWRaGVuXiQ5iqUt/N6N
# GAqKUIppWLtFIv06B8D8VQBC4fBNLrhZmuTMfwiOY8VfWf+dEzGPwEYLGKgjbhay
# S0JPVEhuo9+xo16yzRiC+yQtW6WruUM1SyGPLvyx8ouyftXuTHKGFQInAEe/Ubuh
# vKr0FX4PlLy43TktqAEjwrJ/My838B4r5Ht9owI+JBLEWCMIRBC7bgKcPf40A01J
# tI1YpbiPiD3h4xrIx7bsRfj9AvEETb5lK3vuzid42QyNjecmoCPGQs1JUUVSQO4O
# 2kvgHaLXhtmzbApScsDFaQ5ng0Serh4hfmLVq5MeuiCDpHl5lzjXPkzxV+W1SFxS
# EF9/IP2YSJUK9qWCLoP5dSthbpl42dOoYyCKa9WiEZRlhyNr+htOl+6M6IYEvj46
# ST0UbmRga275WVZ+EZM9JKBHkeUiVdpZWbfzy9OItOgh0Of3zMy2q5I+19h8h5wV
# A0Ncs0Y=
# SIG # End signature block
