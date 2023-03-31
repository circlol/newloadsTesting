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

    $Script:TweakType = "TaskScheduler"

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

            If ($Disabled) {
                Get-ScheduledTask -TaskName (Split-Path -Path $ScheduledTask -Leaf) | Where-Object State -Like "R*" | Disable-ScheduledTask # R* = Ready/Running
            } ElseIf ($Ready) {
                Get-ScheduledTask -TaskName (Split-Path -Path $ScheduledTask -Leaf) | Where-Object State -Like "Disabled" | Enable-ScheduledTask
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
# MIIKUQYJKoZIhvcNAQcCoIIKQjCCCj4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUqJZkxBTK5RfLRSvvlHXhAoC4
# wF2gggZWMIIGUjCCBDqgAwIBAgIQIs9ET5TBkYlFoLQHAUEE/jANBgkqhkiG9w0B
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
# DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUhqFhrsY4+B2r/JuOsH0PbihO
# g68wDQYJKoZIhvcNAQEBBQAEggIAuYc+1JQ4Drj36G6rzDDykXMUp7avzMTXvDWY
# 0JySOl6Z2d6AysL1lSBCpzB5xNpd1cdMacZs5uhWBPhn1v/a/yLOq3C9KqSsQl/0
# aXff88XfQEjcRiv3+tslAun1Zw93dc7FxItKN9kKVKvCHrGQqBEFeq20slAOlzJV
# EFBDOLi4M8Gar7+XpOk9KtTGCA+GMHZnn6JE6D8IGJxFXn2gZmPcT2G4ZEKuNUf6
# QU5JHqe4AxOwgxX2F/p0G+H4puXCW2nWlTToAlpSzp0J+WOBHbUYDBwupXhSt2h6
# gIATXYSO+w2W096BuDH4IsWQjqg2AVjosWL8UivJw96IhovmKdi/uUlSgE3axdOP
# 56FwlLGGWPX7BH9G6LYpqv0YY9GSugFtKd6ATCa6hWV/eygyw6AdYNrRIily2q+T
# KDVkAkuPcAbXqEJeEiXblqDvL+PVtb8kBeaJ72jWHMj24YPdrjXBtLRLj6CiBpIS
# 3dklBpx8AQXiiwXx2u5goJ9ryysaHFNrD6n/u8lKBPKlzd7+AsIkPfjxMX5GroF/
# 5YQwRJlvQDRzfahUGGe7bfFvPaBVAsl9aDPCNB/gYGaTR1DgEyVjNEnXF1BZ1c1N
# bgOcEyEedzeGr1tSZWQ/Mf+L+5mIJUnMj/YFVGx3EumNpZYhQkTUHcC2QKPMJ9b2
# ygwLbqE=
# SIG # End signature block
