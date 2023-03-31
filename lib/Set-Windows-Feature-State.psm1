function Find-OptionalFeature {
    [CmdletBinding()]
    [OutputType([Bool])]
    param (
        [Parameter(Mandatory = $true)]
        [String] $OptionalFeature
    )

    $feature = Get-WindowsOptionalFeature -Online -FeatureName $OptionalFeature -ErrorAction SilentlyContinue
    if ($feature) {
        return $true
    } else {
        Write-Status -Types "?", $TweakType -Status "The $OptionalFeature optional feature was not found." -Warning
        return $false
    }
}

function Set-OptionalFeatureState {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch] $Disabled,
        [Parameter(Mandatory = $false)]
        [Switch] $Enabled,
        [Parameter(Mandatory = $true)]
        [Array] $OptionalFeatures,
        [Parameter(Mandatory = $false)]
        [Array] $Filter,
        [Parameter(Mandatory = $false)]
        [ScriptBlock] $CustomMessage
    )

    $SecurityFilterOnEnable = @("IIS-*")
    $TweakType = "OptionalFeature"

    $OptionalFeatures | ForEach-Object {
        $feature = Get-WindowsOptionalFeature -Online -FeatureName $_ -ErrorAction SilentlyContinue
        if ($feature) {
            if ($_.DisplayName -in $Filter) {
                Write-Status -Types "?", $TweakType -Status "The $_ ($($feature.DisplayName)) will be skipped as set on Filter..." -Warning
                return
            }

            if (($_.DisplayName -in $SecurityFilterOnEnable) -and $Enabled) {
                Write-Status -Types "?", $TweakType -Status "Skipping $_ ($($feature.DisplayName)) to avoid a security vulnerability..." -Warning
                return
            }

            if (!$CustomMessage) {
                if ($Disabled) {
                    Write-Status -Types "-", $TweakType -Status "Uninstalling the $_ ($($feature.DisplayName)) optional feature..."
                } elseif ($Enabled) {
                    Write-Status -Types "+", $TweakType -Status "Installing the $_ ($($feature.DisplayName)) optional feature..."
                } else {
                    Write-Status -Types "?", $TweakType -Status "No parameter received (valid params: -Disabled or -Enabled)" -Warning
                }
            } else {
                Write-Status -Types "@", $TweakType -Status (& $CustomMessage)
            }

            if ($Disabled) {
                $feature | Where-Object State -Like "Enabled" | Disable-WindowsOptionalFeature -Online -NoRestart
            } elseif ($Enabled) {
                $feature | Where-Object State -Like "Disabled*" | Enable-WindowsOptionalFeature -Online -NoRestart
            }
        } else {
            Write-Status -Types "?", $TweakType -Status "The $_ optional feature was not found." -Warning
        }
    }
}


<#
Set-OptionalFeatureState -Disabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3")
Set-OptionalFeatureState -Disabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3") -Filter @("OptionalFeature3")
Set-OptionalFeatureState -Disabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3") -Filter @("OptionalFeature3") -CustomMessage { "Uninstalling $OptionalFeature feature!"}

Set-OptionalFeatureState -Enabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3")
Set-OptionalFeatureState -Enabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3") -Filter @("OptionalFeature3")
Set-OptionalFeatureState -Enabled -OptionalFeatures @("OptionalFeature1", "OptionalFeature2", "OptionalFeature3") -Filter @("OptionalFeature3") -CustomMessage { "Installing $OptionalFeature feature!"}
#>

# SIG # Begin signature block
# MIIKUQYJKoZIhvcNAQcCoIIKQjCCCj4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUTdjhvSuQhq5ClQaGFbjlXtCc
# IiagggZWMIIGUjCCBDqgAwIBAgIQIs9ET5TBkYlFoLQHAUEE/jANBgkqhkiG9w0B
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
# DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU/7KT5edaqxKYI/cs+7Dqsqj0
# KiowDQYJKoZIhvcNAQEBBQAEggIAOixvhBkq5uoR1DCqZPHm2CDBdSz9QcrbL0uY
# JCq9wnFCgdImttwV8jxGQvLMqcYrG1qDY/slIPX3c7QaffmSzoqhsquQ5JKqKKvK
# 1qTINQ9c+fnBLqzpQyDeN4z+/vDi3uFsKu1HJAq19uBWlAfuGkoFA+8BPng9qX/P
# MIP3PdlcHRNR5B8rkiJtTx/XQOhnBkSYOJ8P9T7b2vSCTgYDLHRUfp6nBfz99j0n
# Q/jI4WXDDEjQooOOWLafx7YGjWh8GuYe4NhMMbUErlZqYepdBMNBXm0ZsvreN8ai
# lx4Tjy+OAvW3zy6AJW/MgKLIwqWI+KTIq4ecTQ0sbDZj2r2VKk+vp71qvM3vanHm
# ffeazWIrURhZJLKBjQszSWtbz2vctHBHT3JNAqY3Uxq0k0utxiHKvVu7YUw7jMSw
# rgsQQtzifhXEWrVPB1m4QRXGlnn9lJH8V8uVXwGWTisQQ+E1DhUNG2R0iI4W09iW
# 4trfb05Nkfarsju3XSGv6UICwH51xinK1asv++uFIR8L33aMpDv4drPdDb6ze27z
# td6q4GYLdF8947SRJ/dIBR+ad0zGciA9G/wBLVZl8gIa9dJxyhVIt/7LLMU67VOa
# hw8Soxys/dN3kN+ezUOdGmznZTn25VNexKJ2eH5bhVIBotENczgnUnLConXjZAHx
# QhRHmek=
# SIG # End signature block
