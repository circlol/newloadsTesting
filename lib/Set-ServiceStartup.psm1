function Set-ServiceStartup() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet('Automatic', 'Boot', 'Disabled', 'Manual', 'System')]
        [String]      $State,
        [Parameter(Mandatory = $true)]
        [String[]]    $Services,
        [String[]]    $Filter
    )

    Begin {
        $Script:SecurityFilterOnEnable = @("RemoteAccess", "RemoteRegistry")
        $Script:TweakType = "Service"
    }

    Process {
    ForEach ($Service in $Services) {
        If (!(Get-Service $Service -ErrorAction SilentlyContinue)) {
            Write-Status -Types "?", $TweakType -Status "The $Service service was not found." -Warning
            Continue
        }

        If (($Service -in $SecurityFilterOnEnable) -and (($State -eq 'Automatic') -or ($State -eq 'Manual'))) {
            Write-Status -Types "?", $TweakType -Status "Skipping $Service ($((Get-Service $Service).DisplayName)) to avoid a security vulnerability..." -Warning
            Continue
        }

        If ($Service -in $Filter) {
            Write-Status -Types "?", $TweakType -Status "The $Service ($((Get-Service $Service).DisplayName)) will be skipped as set on Filter..." -Warning
            Continue
        }

    Try {
        Write-Status -Types "@", $TweakType -Status "Setting $Service ($((Get-Service $Service).DisplayName)) as '$State' on Startup..."
        If ($WhatIf){
            Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType $State -WhatIf
        } Else {
            Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType $State
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
        }
    }
}

<#
Set-ServiceStartup -State Automatic -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -State Automatic -Services @("Service1", "Service2", "Service3") -Filter @("Service3")

Set-ServiceStartup -State Disabled -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -State Disabled -Services @("Service1", "Service2", "Service3") -Filter @("Service3")

Set-ServiceStartup -State Manual -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -State Manual -Services @("Service1", "Service2", "Service3") -Filter @("Service3")
#>



# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUB5CbpV7KRnpne+1YFRJBvLv+
# NJ2gggMQMIIDDDCCAfSgAwIBAgIQOtpMekE2BIRJ/swv2v8NGDANBgkqhkiG9w0B
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
# CQQxFgQU19N/yovcTE6OvzlRxsbc8iQ1FvUwDQYJKoZIhvcNAQEBBQAEggEATVts
# RCyceVNqT7ohIqU5nY/zuwUtruxdx3awgePEF/FJlE/6GQ05Y53LC6cpnnswNByt
# h6/2Ol6Pmo44DoCDE5DTA5mQynxCvY5nnIaP00dZC38ijFtHOiuuS/x/YkORWDA3
# 3udFZc+PgZ7ed/etSry/d54I4WASdT8Od/oK3tf2d9C5Zv12DYpN8XgLQ1RsKOfH
# R+gUF/8txBBrpQXWdWdAte6vfroNPKU+0YEaUZplL6b4/wendZiu3p9TmK9xkjFW
# XXtgcoCX6kFPYQlxhovc0mfDglz5gFUJQ70u38J5LR3f6a3f8ETOWyw8ynjLOs/q
# GpviuWVORFR7IFglxA==
# SIG # End signature block
