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
            Write-Status -Types "+" -Status "$Name set to $Value in $Path"
            $warningPreference = Get-Variable -Name WarningPreference -ValueOnly -ErrorAction SilentlyContinue
            If ($WhatIf){
                If (!$Force) {
                    Set-ItemProperty -Path "$Path" -Name "$Name" -Value "$Value" -Type "$Type" -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru -Verbose:$UseVerbose -WhatIf
                }
                else {
                    Set-ItemProperty -Path "$Path" -Name "$Name" -Value "$Value" -Type "$Type" -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru -Force -Verbose:$UseVerbose -WhatIf
                }
            }Else{
                If (!$Force) {
                    Set-ItemProperty -Path "$Path" -Name "$Name" -Value "$Value" -Type "$Type" -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru -Verbose:$UseVerbose
                }
                else {
                    Set-ItemProperty -Path "$Path" -Name "$Name" -Value "$Value" -Type "$Type" -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru -Force -Verbose:$UseVerbose
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
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU+9vTMQG5OOQxtcYFjcH7WoBD
# sjSgggMQMIIDDDCCAfSgAwIBAgIQOtpMekE2BIRJ/swv2v8NGDANBgkqhkiG9w0B
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
# CQQxFgQUiArbtDxKoCSKs2NwIDyLgW9bQs8wDQYJKoZIhvcNAQEBBQAEggEAJCc7
# PsUyFhC1KQGljvMaVC6eZqW/16hMpQizZwij673MKO4PjpVrZiIaHMmreZaJjjoH
# 5dHzM6HbURCU6ndi9zih/VwkC1ki/WptJW9z2Ep2yeiCXkhkDKglbSLPZqKN8gbH
# 0gr04QO98qrjlFn+BJuIIFKLaDncG60NyvFRSskk2Hw2HH1HcsFWS+yvJ5kD8EVq
# 1Dd+lkA59oa+ZFpvl+YH0/k9RbQfNa1PhKbFzSaSrrTRexUi7DmHrQ/8zbWJgz8V
# hooWLGl0YAnay5EtSnQIgy4em8tFymRR/ujeeKYnOU9GBZZfGMd/vCk8CJk+pu4W
# tbaSNXKgQ3lu8MJEWA==
# SIG # End signature block
