Function Set-ItemPropertyVerified {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $Value,
        [Parameter(Mandatory = $true)]
        $Name,
        [Parameter(Mandatory = $true)]
        $Type,
        [Parameter(Mandatory = $true)]
        $Path,
        [Parameter(Mandatory = $False)]
        [Switch]$Force,        
        [Parameter(Mandatory = $False)]
        [Switch]$WhatIf,
        [Parameter(Mandatory = $False)]
        [Switch]$UseVerbose,
        [Parameter(Mandatory = $False)]
        [Switch]$Passthru
    )

    $keyExists = Test-Path -Path $Path
    If ($WhatIf){
        if (!$keyExists) {
            Write-Status -Types "+", "Path Not Found" -Status "Creating key at $Path"
            New-Item -Path $Path -Force -WhatIf | Out-Null
        }    
    }else{
        if (!$keyExists) {
            Write-Status -Types "+", "Path Not Found" -Status "Creating key at $Path"
            New-Item -Path $Path -Force | Out-Null
        }
    }

    $currentValue = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
    if ($null -eq $currentValue -or $currentValue.$Name -ne $Value) {
        Try {
            Write-Status -Types "+" -Status "$Name set to $Value in $Path" -NoNewLine
            $warningPreference = Get-Variable -Name WarningPreference -ValueOnly -ErrorAction SilentlyContinue
            If ($WhatIf){
                If (!$Force) {
                    Set-ItemProperty -Path "$Path" -Name "$Name" -Value "$Value" -Type "$Type" -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru -Verbose:$UseVerbose -WhatIf
                    If ($? -eq $True){ Check ; $ModifiedRegistryKeys ++} else {Check}
                    
                }
                else {
                    Set-ItemProperty -Path "$Path" -Name "$Name" -Value "$Value" -Type "$Type" -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru -Force -Verbose:$UseVerbose -WhatIf
                    If ($? -eq $True){ Check ; $ModifiedRegistryKeys ++} else {Check}
                }
            }Else{
                If (!$Force) {
                    Set-ItemProperty -Path "$Path" -Name "$Name" -Value "$Value" -Type "$Type" -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru -Verbose:$UseVerbose
                    If ($? -eq $True){ Check ; $ModifiedRegistryKeys ++} else {Check}
                }
                else {
                    Set-ItemProperty -Path "$Path" -Name "$Name" -Value "$Value" -Type "$Type" -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru -Force -Verbose:$UseVerbose
                    If ($? -eq $True){ Check ; $ModifiedRegistryKeys ++} else {Check}
                }
            }
        }
        catch {
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
    }
    else {
        Write-Status -Types "@" -Status "Key already set to desired value. Skipping"
    }
}
# SIG # Begin signature block
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUJkLbsTSAX+1OWQo7Y0/+oosj
# AYCgggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFJNAwsE5hH/L1sugGNZZxz1jG6zmMA0GCSqGSIb3DQEB
# AQUABIIBAF0D2au5K3F+cNwKLAaytR0ZxekXDlkaF/1f1WLXTu/Sx2axxXC6rg16
# VdEXtDoS0DUMIHZ7q+OkBUtFEcJq/G/+YxMAQY/ljzqUdE0dHLwDXnNMjqR1ZLFX
# iU4Nlo3rnAk59Oj4rovdXbnscFAf8W1cLUMB+SEWBdHpAGW1PYpHui2m3nEeN6K9
# Jlw9o0EOFmppqo/cJjf+NS4DQniwSlCznMqUVWjaEa7pFQ8Pf5Nu4mKIu5lEfqHh
# WthBNQA41gWHhuc4YX5AhzqUCKjnnOFCQqiBKL03bCr2dLnpYzlTSm1B+eJSMlUK
# ixcCKoQfk5Afw922qZVofDY/zJH2SEw=
# SIG # End signature block
