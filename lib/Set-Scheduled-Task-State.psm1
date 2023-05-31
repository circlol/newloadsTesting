function Find-ScheduledTask() {
    [CmdletBinding()]
    [OutputType([Bool])]
    param (
        [Parameter(Mandatory = $true)]
        [String] $ScheduledTask
    )

    If (Get-ScheduledTaskInfo -TaskName $ScheduledTask -ErrorAction SilentlyContinue) {
        return $true
    } Else {
        Write-Status -Types "?", $TweakType -Status "The $ScheduledTask task was not found." -Warning
        return $false
    }
}

function Set-ScheduledTaskState() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch] $Disabled,
        [Parameter(Mandatory = $false)]
        [Switch] $Ready,
        [Parameter(Mandatory = $true)]
        [Array] $ScheduledTasks,
        [Parameter(Mandatory = $false)]
        [Array] $Filter
    )

    ForEach ($ScheduledTask in $ScheduledTasks) {
    If (Find-ScheduledTask $ScheduledTask) {
        If ($ScheduledTask -in $Filter) {
            Write-Status -Types "?", $TweakType -Status "The $ScheduledTask ($((Get-ScheduledTask $ScheduledTask).TaskName)) will be skipped as set on Filter..." -Warning
            Continue
        }

        If ($Disabled) {
            Write-Status -Types "-", $TweakType -Status "Disabling the $ScheduledTask task..."
        } ElseIf ($Ready) {
            Write-Status -Types "+", $TweakType -Status "Enabling the $ScheduledTask task..."
        } Else {
            Write-Status -Types "?", $TweakType -Status "No parameter received (valid params: -Disabled or -Ready)" -Warning
        }
        Try{
        If ($Disabled) {
            Get-ScheduledTask -TaskName (Split-Path -Path $ScheduledTask -Leaf) | Where-Object State -Like "R*" | Disable-ScheduledTask | Out-Null # R* = Ready/Running
            Check
        } ElseIf ($Ready) {
            Get-ScheduledTask -TaskName (Split-Path -Path $ScheduledTask -Leaf) | Where-Object State -Like "Disabled" | Enable-ScheduledTask | Out-Null
            Check
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
Set-ScheduledTaskState -Disabled -ScheduledTasks @("ScheduledTask1", "ScheduledTask2", "ScheduledTask3")
Set-ScheduledTaskState -Disabled -ScheduledTasks @("ScheduledTask1", "ScheduledTask2", "ScheduledTask3") -Filter @("ScheduledTask3")
Set-ScheduledTaskState -Disabled -ScheduledTasks @("ScheduledTask1", "ScheduledTask2", "ScheduledTask3") -Filter @("ScheduledTask3") -CustomMessage { "Setting $ScheduledTask as Disabled!"}

Set-ScheduledTaskState -Ready -ScheduledTasks @("ScheduledTask1", "ScheduledTask2", "ScheduledTask3")
Set-ScheduledTaskState -Ready -ScheduledTasks @("ScheduledTask1", "ScheduledTask2", "ScheduledTask3") -Filter @("ScheduledTask3")
Set-ScheduledTaskState -Ready -ScheduledTasks @("ScheduledTask1", "ScheduledTask2", "ScheduledTask3") -Filter @("ScheduledTask3") -CustomMessage { "Setting $ScheduledTask as Ready!"}
#>


# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU0/pm9akN3NAheX5M62gaIAo4
# y0mgggMQMIIDDDCCAfSgAwIBAgIQOtpMekE2BIRJ/swv2v8NGDANBgkqhkiG9w0B
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
# CQQxFgQUQIo9GSTy++6K6/Zd/0p0McWQ8lMwDQYJKoZIhvcNAQEBBQAEggEAW7k8
# 7URQlPL6emL/PfkYj/ZHVzD9umirykYHyoPpdPUMunYHE0t8nvJr/KShARUR2EvO
# zc3tqPqxDIYOlQrwAmggUfqpp4cbfl9hq+8Qw4N0xa6hD012IFWvCAcpQhp7C1/J
# Wn+oKuDSIcj00ShbIWU57SHbmsikdVrcI+yoMWdJwqHo+nPRZC0skEDLCReRCtZc
# pSYlwNBeRA6tLCcFTd0dPsIjhVVQOX+VY7Blqs0M7p28s6pDQQ+XJkI2tyQD3l57
# Env1xKjSYbmXdeqqQ8VCMGR3K8m9PFAAWXHNJPLLnzj7Nd61JJKq9uAX2XSXaEBe
# u8vojbX9Vj3sIVvw3w==
# SIG # End signature block
