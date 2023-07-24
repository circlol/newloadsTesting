
<#
.SYNOPSIS
    Checks if a specified Windows optional feature is available on the host.

.DESCRIPTION
    The Find-OptionalFeature function is used to check if a specified Windows optional feature is available on the host machine. It queries the installed optional features using `Get-WindowsOptionalFeature` cmdlet and returns a boolean value indicating if the feature is found or not.

.PARAMETER OptionalFeature
    Specifies the name of the Windows optional feature to check for. This parameter is mandatory.

.OUTPUTS
    The function outputs a boolean value indicating whether the specified optional feature is found or not. If the feature is found, the function returns $true. If the feature is not found, the function returns $false.

.EXAMPLE
    $featureFound = Find-OptionalFeature -OptionalFeature "Microsoft-Windows-Subsystem-Linux"

    DESCRIPTION
        Checks if the "Microsoft-Windows-Subsystem-Linux" optional feature is available on the host. If found, the $featureFound variable will be set to $true.

.EXAMPLE
    if (Find-OptionalFeature -OptionalFeature "Telnet-Client") {
        Write-Host "The Telnet Client feature is available."
    } else {
        Write-Host "The Telnet Client feature is not available."
    }

    DESCRIPTION
        Checks if the "Telnet-Client" optional feature is available on the host and displays a corresponding message based on the result.

#>
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
        Write-Status -Types "?", $TweakType -Status "The $OptionalFeature optional feature was not found."
        return $false
    }
}



<#
.SYNOPSIS
    Enables or disables Windows optional features on the host.

.DESCRIPTION
    The Set-OptionalFeatureState function is used to enable or disable Windows optional features on the host machine. It allows you to specify the features to be enabled or disabled using an array of feature names. You can also set a filter to skip certain features, provide a custom message for each feature, and use the `-WhatIf` switch to preview changes without applying them.

.PARAMETER Disabled
    Indicates that the specified optional features should be disabled. If this switch is present, the function will attempt to uninstall the specified features.

.PARAMETER Enabled
    Indicates that the specified optional features should be enabled. If this switch is present, the function will attempt to install the specified features.

.PARAMETER OptionalFeatures
    Specifies an array of names of the optional features that need to be enabled or disabled. This parameter is mandatory.

.PARAMETER Filter
    Specifies an array of feature names to skip. If a feature name matches any of the names in the filter, it will be skipped. This parameter is optional.

.PARAMETER CustomMessage
    Allows providing a custom message for each feature. If provided, the custom message will be displayed instead of the default messages.

.PARAMETER WhatIf
    If this switch is provided, the function will only preview the changes without actually enabling or disabling the features.

.EXAMPLE
    Set-OptionalFeatureState -Enabled -OptionalFeatures "Microsoft-Windows-Subsystem-Linux", "Telnet-Client"

    DESCRIPTION
        Enables the "Microsoft-Windows-Subsystem-Linux" and "Telnet-Client" optional features on the host.

.EXAMPLE
    Set-OptionalFeatureState -Disabled -OptionalFeatures "Internet-Explorer-Optional-amd64" -Filter "Telnet-Client"

    DESCRIPTION
        Disables the "Internet-Explorer-Optional-amd64" optional feature on the host. If the feature name matches the filter ("Telnet-Client"), it will be skipped.

.EXAMPLE
    Set-OptionalFeatureState -Enabled -OptionalFeatures "Media-Features", "XPS-Viewer" -CustomMessage { "Enabling feature: $_" }

    DESCRIPTION
        Enables the "Media-Features" and "XPS-Viewer" optional features on the host, displaying the custom message for each feature.

.EXAMPLE
    Set-OptionalFeatureState -Enabled -OptionalFeatures "LegacyComponents" -WhatIf

    DESCRIPTION
        Previews the changes of enabling the "LegacyComponents" optional feature without applying the changes.
#>
function Set-OptionalFeatureState {
    [CmdletBinding()]
    param (
        [Switch] $Disabled,
        [Switch] $Enabled,
        [Parameter(Mandatory = $true)]
        [Array] $OptionalFeatures,
        [Array] $Filter,
        [ScriptBlock] $CustomMessage,
        [Switch] $WhatIf
    )

    $SecurityFilterOnEnable = @("IIS-*")
    $TweakType = "OptionalFeature"

    $OptionalFeatures | ForEach-Object {
        $feature = Get-WindowsOptionalFeature -Online -FeatureName $_ -ErrorAction SilentlyContinue
        if ($feature) {
            if ($_.DisplayName -in $Filter) {
                Write-Status -Types "?", $TweakType -Status "The $_ ($($feature.DisplayName)) will be skipped as set on Filter..."
                return
            }

            if (($_.DisplayName -in $SecurityFilterOnEnable) -and $Enabled) {
                Write-Status -Types "?", $TweakType -Status "Skipping $_ ($($feature.DisplayName)) to avoid a security vulnerability..."
                return
            }

            if (!$CustomMessage) {
                if ($Disabled) {
                    Write-Status -Types "-", $TweakType -Status "Uninstalling the $_ ($($feature.DisplayName)) optional feature..."
                } elseif ($Enabled) {
                    Write-Status -Types "+", $TweakType -Status "Installing the $_ ($($feature.DisplayName)) optional feature..."
                } else {
                    Write-Status -Types "?", $TweakType -Status "No parameter received (valid params: -Disabled or -Enabled)"
                }
            } else {
                Write-Status -Types "@", $TweakType -Status (& $CustomMessage)
            }

            Try {
                If ($WhatIf) {
                    if ($Disabled) {
                        $feature | Where-Object State -Like "Enabled" | Disable-WindowsOptionalFeature -Online -NoRestart -WhatIf
                    } elseif ($Enabled) {
                        $feature | Where-Object State -Like "Disabled*" | Enable-WindowsOptionalFeature -Online -NoRestart -WhatIf
                    }
                } else {
                    if ($Disabled) {
                        $feature | Where-Object State -Like "Enabled" | Disable-WindowsOptionalFeature -Online -NoRestart
                    } elseif ($Enabled) {
                        $feature | Where-Object State -Like "Disabled*" | Enable-WindowsOptionalFeature -Online -NoRestart
                    }
                }
            }catch {
                $errorMessage = $_.Exception.Message
                $lineNumber = $_.InvocationInfo.ScriptLineNumber
                $command = $_.InvocationInfo.Line
                $errorType = $_.CategoryInfo.Reason
                $ErrorLog = ".\ErrorLog.txt"
            
    $errorString = @"
    -
    Time of error: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    Command run was: $command
    Reason for error was: $errorType
    Offending line number: $lineNumber
    Error Message: $errorMessage
    -
"@
            Add-Content $ErrorLog $errorString
            Write-Output $_
            continue
            }
        } else {
            Write-Status -Types "?", $TweakType -Status "The $_ optional feature was not found." -WriteWarning
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
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUFkS9GDwf1tNA3T09A7KdOpL7
# UcugggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFHvcMPLsniNmFnrrtLECuVW4MBkpMA0GCSqGSIb3DQEB
# AQUABIIBAI3PiU2wZRxym+y6RP8+FwB5AwH9+2bgcGd/UiHXn4XWpBVX1k+1X+4B
# vxEySVplYKlDSY7XOPvEmO3Axu8jY2ALvKxbFYM7hOLo5UayCh+Kz3XaVlHGsZr5
# ud1kNE++YDsVjOs2enpZFIiB6WsxYa8ROjfgpLQXnvmvwcxgGIqa14GF/FJhh0Xy
# N5MdIPPnFgGs5Q6rOrv7h3kcCIuqrPTdhsPO+MMFiVUrWQMXBVq3qMEbrXT3Q2sD
# Wh7UJvsSZpvwFUqb9+KaClt842H4u6/SJIq9SKCdsVrH8WTJuifcZ5DE4ltKJUhX
# as3TSQF0JRdjQv16MOpBI2IVDHUe3wA=
# SIG # End signature block
