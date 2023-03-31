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

            Write-Status -Types "@", $TweakType -Status "Setting $Service ($((Get-Service $Service).DisplayName)) as '$State' on Startup..."
            Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType $State
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
# MIIKUQYJKoZIhvcNAQcCoIIKQjCCCj4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUXQJwBtG5Sn+cnsG3+nuwIFgg
# tCKgggZWMIIGUjCCBDqgAwIBAgIQIs9ET5TBkYlFoLQHAUEE/jANBgkqhkiG9w0B
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
# DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU2qEx4atJr0a9lBTQ60PirQSp
# 80IwDQYJKoZIhvcNAQEBBQAEggIAKzbtkYzocco+bRhj2OzXV/HzA9oOc7MI7xep
# WuVI4agA64sdek5/QCveD6ojaNAHlrorj6tIGaYfN48hkirycwjxu7X/PSr1DMha
# p6iAu+SJdSrFuEXepHuQewS4LwVkwMkfj7Me9cYw7q3HnChbBu1pezkGCybt4heM
# rC8Z2y3MrncAUsKukoOR59v3eQhsFQMx6Y5e8/VeAcLWiXKjaY9eWTWxJJ3csFwL
# g0O3qZ9pki/CzIG40NiMhNYhgr6nmDQWtImEAZ+qAOuPqpb8rp0oLt4o9vpW0RRB
# Dddl+phPAE3w7Yo7jW9sGMCSFgaL6SQXDQDxkshmQPQ/SW2JU2hf/vhWajjeubcf
# dMe4qelqBeOVuFvT8p/Bbd4o9SyCXEM4OlV+Oyf20l8EkvNwKX98eEo5H+FcKJ+Q
# U8OVgeVO2XZu5uRfEJ/VSmpjnW0zlZwqLg8BSXqpHxOuriz6Y42wMAagfLdZnYhW
# yi86nyv2ZIA5+SlgtQPFFlmnWjUbQpxOpLwd1J4wpSnEA+0JlMihBPgTAyg+ULh9
# Ex3n6fnWhk13hgjUzrMwkt/L8buplfZugRdeK+hYuBPWIMJPEMAU4kxlDDsRm0DR
# x0AB71eMwgJo/moFKMb6xLu9X22dkRQDACTq0W2ReiqFTM0SoUh3IaleShD2tX0R
# iqW+OgM=
# SIG # End signature block
