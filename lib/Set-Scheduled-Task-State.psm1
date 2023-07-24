<#
.SYNOPSIS
    Checks if a specified scheduled task exists on the host.

.DESCRIPTION
    The Find-ScheduledTask function is used to check if a specified scheduled task exists on the host machine. It queries the scheduled tasks using the `Get-ScheduledTaskInfo` cmdlet and returns a boolean value indicating if the task is found or not.

.PARAMETER ScheduledTask
    Specifies the name of the scheduled task to check for. This parameter is mandatory.

.OUTPUTS
    The function outputs a boolean value indicating whether the specified scheduled task is found or not. If the task is found, the function returns $true. If the task is not found, the function returns $false.

.EXAMPLE
    $taskFound = Find-ScheduledTask -ScheduledTask "Task1"

    DESCRIPTION
        Checks if the "Task1" scheduled task exists on the host. If found, the $taskFound variable will be set to $true.

.EXAMPLE
    if (Find-ScheduledTask -ScheduledTask "Task2") {
        Write-Host "The Task2 task is present on the host."
    } else {
        Write-Host "The Task2 task was not found on the host."
    }

    DESCRIPTION
        Checks if the "Task2" scheduled task exists on the host and displays a corresponding message based on the result.

#>
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
        Write-Status -Types "?", $TweakType -Status "The $ScheduledTask task was not found." -WriteWarning
        return $false
    }
}



<#
.SYNOPSIS
    Enables or disables scheduled tasks on the host.

.DESCRIPTION
    The Set-ScheduledTaskState function is used to enable or disable scheduled tasks on the host machine. It allows you to specify the tasks to be enabled or disabled using an array of task names. You can also set a filter to skip certain tasks, and use the `-Disabled` or `-Ready` switches to disable or enable the tasks, respectively.

.PARAMETER Disabled
    Indicates that the scheduled tasks should be disabled. If this switch is used, the tasks specified in the `ScheduledTasks` parameter will be disabled.

.PARAMETER Ready
    Indicates that the scheduled tasks should be enabled and set to the "Ready" state. If this switch is used, the tasks specified in the `ScheduledTasks` parameter will be enabled.

.PARAMETER ScheduledTasks
    Specifies an array of scheduled task names for which the state should be modified. This parameter is mandatory.

.PARAMETER Filter
    Specifies an array of scheduled task names to skip. If a task name matches any of the names in the filter, it will be skipped. This parameter is optional.

.EXAMPLE
    Set-ScheduledTaskState -Disabled -ScheduledTasks "Task1", "Task2"

    DESCRIPTION
        Disables the "Task1" and "Task2" scheduled tasks.

.EXAMPLE
    Set-ScheduledTaskState -Ready -ScheduledTasks "Task3", "Task4" -Filter "Task5"

    DESCRIPTION
        Enables the "Task3" and "Task4" scheduled tasks and skips the "Task5" task due to the filter.

#>
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
            Write-Status -Types "?", $TweakType -Status "The $ScheduledTask ($((Get-ScheduledTask $ScheduledTask).TaskName)) will be skipped as set on Filter..." -WriteWarning
            Continue
        }

        If ($Disabled) {
            Write-Status -Types "-", $TweakType -Status "Disabling the $ScheduledTask task..." -NoNewLine
        } ElseIf ($Ready) {
            Write-Status -Types "+", $TweakType -Status "Enabling the $ScheduledTask task..." -NoNewLine
        } Else {
            Write-Status -Types "?", $TweakType -Status "No parameter received (valid params: -Disabled or -Ready)" -WriteWarning
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
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU0/pm9akN3NAheX5M62gaIAo4
# y0mgggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFECKPRkk8vvuiuv2Xf9KdDHFkPJTMA0GCSqGSIb3DQEB
# AQUABIIBAADcGjRpld94kiMZ1VQrDfAB7ps143DXC93RamYXguEdaSZmLEsS9V+h
# jhwP943aFSGVzDGJwjJqP3R9vAYp1enFrus4emgKGImAd8Oh/XZxX3bORE+pka/+
# 4ENhcvbwpTChQbgazvqAIWJdNN/cRVAwSs5EwqBBbKHxoWNA7pmKdSur20IeRoAp
# DWouGzgevhPD8xn0bPkPcu0I9gIj2W/OVA45f+wq7ncvuZUmCMW0NUoSYb6pQRMS
# MsNwmddH6MblU2BS7AJzvucBxtwBIL0NBEoEHJixLvj9VdcFtVcUtWzMIy1eb53N
# CSa4hCXJcAiw/S4NbZAvn/BVdU6BtDU=
# SIG # End signature block
