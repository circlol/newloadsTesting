Function Set-ItemPropertyVerified {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $Value,
        [Parameter(Mandatory=$true)]
        $Name,
        [Parameter(Mandatory=$true)]
        $Type,
        [Parameter(Mandatory=$true)]
        $Path,
        [Switch]
        $Passthru
    )

    $keyExists = Test-Path -Path $Path

    if (!$keyExists) {
        New-Item -Path $Path -Force | Out-Null
    }

    $currentValue = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue

    if ($currentValue -eq $null -or $currentValue.$Name -ne $Value) {
        Try {
            $warningPreference = Get-Variable -Name WarningPreference -ValueOnly -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru
            Write-Status -Types "+" -Status "$Name set to $Value in $Path"  
        }
        Catch {
            Write-Error "=> Error: $_.Exception.Message" | Out-File -FilePath $ErrorLog -Append
        }
    }
    else {
        Write-Status -Types "@" -Status "Key already set to desired value. Skipping"
    }
}

## Example Command

<## Set-ItemPropertyVerified -Path "HKCU:\SYSTEM\Love" -Name "Kidney" -Value '3' -Type "DWORD"
    "Supported Commands"
        - Name
        - Value
        - Path
        - Type
        - Passthru
        - Verbose
        #- Debug
        - ErrorAction
        - WarningAction
        #- InformationAction
        #- ErrorVariable
        #- WarningVariable
        #- InformationVariable
        #- outVariable
        #- outBuffer
        #- PipelineVariable
##>


# SIG # Begin signature block
# MIIKUQYJKoZIhvcNAQcCoIIKQjCCCj4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUD5kCI62W2vIaMFmaBm3KB1xm
# ChugggZWMIIGUjCCBDqgAwIBAgIQIs9ET5TBkYlFoLQHAUEE/jANBgkqhkiG9w0B
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
# DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQUEYdVEKhuB8mW5s1DUyJaEvtK
# kRQwDQYJKoZIhvcNAQEBBQAEggIASOWjDGMvih0AmuSuTjLxdHOZ5/tybf0miD9d
# gdoWybjaz123rechAIUiZpjboVRdbq8PvRPrklvCiN8i4JWPVUwivSrDThea7rVU
# 5lNsAOqyUOPzDBMDTic6h7BRNflg1qIoZLXaEyb2IA3uqxVmX+GUDL6TxoZUO150
# 3DMFEkaJrC049fTQFFFhFqJSRFBP/ajn1puMIs9xbgg/ma7j9f1xLZ6dZKljIz6v
# GYORUZZPW1/6YxCbrj5YdautTzkqzMKSUogBv1NIrG4I7CuBrZDz06BENIFdBZyN
# xb6iwfn/BFAkyD3QwnsXF3tirlJzV3f/oCVlI88y/6L0xymaln58y5v36sPO4KsY
# udr/P392XPmsJv2hwyHLqbuoxyRDmxhcykgsUWfefot6Hb2vHz0t4zZHd8K8Ppy1
# KrUklGStudscg/zd8dhIZa4LUQeJy8nfDcBupGxdZzu/wblbTtnJxu5XLbWIx2vn
# N/YeDa5HpGNAANHbkUfvawVUbxO3smYOO5LWO6+E8OKxF3NJ7SNgPJA93hP06XPh
# e+0QwwdB2gNVYMWSYIi+7Haf2HF5MVeWRt2Dx+XDXpQnoIR1tRmBTo4MMuSE2ZXe
# i8Z/yDzKIk4cigXEyzQDCVqFwH9Ko6xmV4szhIFaxaq5uTNLrKCRhqnmcENinqt7
# dKlKH2s=
# SIG # End signature block
