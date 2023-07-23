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
            Write-Status -Types "?", $TweakType -Status "The $Service service was not found." -WriteWarning
            Continue
        }

        If (($Service -in $SecurityFilterOnEnable) -and (($State -eq 'Automatic') -or ($State -eq 'Manual'))) {
            Write-Status -Types "!", $TweakType -Status "Skipping $Service ($((Get-Service $Service).DisplayName)) to avoid a security vulnerability..." -WriteWarning
            Continue
        }

        If ($Service -in $Filter) {
            Write-Status -Types "!", $TweakType -Status "The $Service ($((Get-Service $Service).DisplayName)) will be skipped as set on Filter..." -WriteWarning
            Continue
        }

    Try {
        Write-Status -Types "@", $TweakType -Status "Setting $Service ($((Get-Service $Service).DisplayName)) as '$State' on Startup..." -NoNewLine
        If ($WhatIf){
            Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType $State -WhatIf
        } Else {
            Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType $State
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
Set-ServiceStartup -State Automatic -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -State Automatic -Services @("Service1", "Service2", "Service3") -Filter @("Service3")

Set-ServiceStartup -State Disabled -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -State Disabled -Services @("Service1", "Service2", "Service3") -Filter @("Service3")

Set-ServiceStartup -State Manual -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -State Manual -Services @("Service1", "Service2", "Service3") -Filter @("Service3")
#>



# SIG # Begin signature block
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUB5CbpV7KRnpne+1YFRJBvLv+
# NJ2gggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFNfTf8qL3ExOjr85UcbG3PIkNRb1MA0GCSqGSIb3DQEB
# AQUABIIBAGhwfSEm7MWFNPkaFPOC2tBtKeREkrmZxyptit6YinkC7mWJtGP1ipyf
# 0n1njFpxv3pWwwiJjnP9xLy+fsb2wHXUqDO2ADb3kRcQmfwja1tUI5yfhbzNSF18
# /+zS3qgbMXHI9KPNYlScJH2ECTN/AnvkR1pQ87ZHCtUSXpj+narAMHpgbQaBsIbv
# 2TyPhJyWjpcho0y1dSye/e0jmXQO2MmrIgdrAoPFsYfXelu/YHtNRswd/pHLJN5p
# CJbApPzBYAbWWlzJxCF6ctaslJwv5hUEyoh3XxMvUMvlDI0xu7N8mbTydZNFBQtW
# VlUxLkZxhhLP8Hv44u25p1KLTJ9SQN4=
# SIG # End signature block
