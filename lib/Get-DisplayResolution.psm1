Function Get-DisplayResolution {
    $screen = Get-WmiObject -Class Win32_VideoController | Select-Object CurrentHorizontalResolution, CurrentVerticalResolution
    $width = $screen.CurrentHorizontalResolution
    $height = $screen.CurrentVerticalResolution
    $ratio = "{0}:{1}" -f $width, $height

    $aspectRatios = @{
        '3840:2560' = '16:9 (UHD)'
        '3840:2160' = '16:9 (UHD)'
        '2560:1600' = '16:10 (WQXGA)'
        '2560:1440' = '16:9 (WQHD)'
        '2048:1152' = '16:9 (QWXGA)'
        '1920:1200' = '16:10 (WUXGA)'
        '1920:1080' = '16:9 (FHD)'
        '1680:1050' = '16:10 (WSXGA+)'
        '1600:900'  = '16:9 (HD+)'
        '1440:900'  = '16:10 (WXGA+)'
        '1366:768'  = '16:9 (WXGA)'
        '1280:800'  = '16:10 (WXGA)'
        '1280:720'  = '16:9 (HD)'
        '1024:768'  = '4:3 (XGA)'
        '2880:1800' = '8:5 (Retina)'
        '2256:1504' = '3:2'
        '2160:1440' = '3:2 (2160p)'
        '1920:1280' = '3:2 (Surface Pro 3)'
        '1440:960'  = '3:2 (Surface Laptop 3)'
        '2736:1824' = '3:2 (Surface Pro 4)'
    }

    if ($aspectRatios.ContainsKey($ratio)) {
        $aspectRatio = $aspectRatios[$ratio]
    }
    else {
        $aspectRatio = $ratio
    }

    return @{
        Resolution = "$width x $height"
        AspectRatio = $aspectRatio
    }
}

# SIG # Begin signature block
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUFawleey27BAHGwlsusJLwy3T
# LrCgggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFKYrVxQFlCBwB4r2bxrG89K9h+9CMA0GCSqGSIb3DQEB
# AQUABIIBABhvmynssS/HeuTl1/uJKg0kfTabXHb/FloaJgHLXPMSaqnhVqssgVky
# a4/TBcptRXh0uMiRvXFergTs+0DlhTQR8b5nXeu+BfUB54eMhx3jezdAZI6Oq+mC
# /PBHlvy/6BbfRiAudZKfdd/TZYmc94hpkhhCJ/6gqJOR2+9wY6HI7htRByoUTlXw
# zDrMrMmiTRsTZmE8R5j+42rABvozLHBENY1ZyPQWcFk1Sgk7PJcB2grzUAdUokjd
# dnZXjYQD2av4gn843F0sEmwzH5+jr0nKcfDygTfJ/xbudDy8emCtTUstj4ZPxQvA
# oK6QDBoaRygHmpxK+4ruay2/XC7UqJ0=
# SIG # End signature block
