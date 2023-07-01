
Function Send-BackupHome {
    [String]$currentTimeFTP = Get-Date -Format HH`;mm`;ss
    [String]$currentDateFTP = Get-Date -Format yy.MM.dd
    $localFilePath = ".\$CurrentDateFTP-$CurrentTimeFTP.zip"
    $remoteFilePath = "/$CurrentDateFTP-$CurrentTimeFTP.zip"
    reg export HKCU "HKCU.reg"
    reg export HKLM "HKLM.reg"
    "Registry backup of Computer for user $env:ComputerName\$env:Username" | Out-File ".\$env:computername.txt" ascii
    $array12 = @(
        "HKCU.reg"
        "HKLM.reg"
        "$env:computername.txt"
    )
    Compress-Archive $array12 $localFilePath
    $ftpRequest = [System.Net.FtpWebRequest]::Create("$ftpServer/$remoteFilePath")
    $ftpRequest.Credentials = New-Object System.Net.NetworkCredential($ftpUser, $ftpPassword)
    $ftpRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
    $ftpRequest.UseBinary = $true
    
    # Get the length of the local file for progress tracking
    $fileSize = (Get-Item $localFilePath).Length
    
    # Open local file for reading
    $localFileStream = [System.IO.File]::OpenRead($localFilePath)
    
    try {
        # Open FTP request stream for writing
        $ftpStream = $ftpRequest.GetRequestStream()
        $bufferSize = 8192  # Set the buffer size for transferring data
        $bytesRead = 0  # Initialize the number of bytes read
        # Create a byte array to store the file data
        $buffer = New-Object byte[] $bufferSize
        # Loop through the local file, read data, and write it to the FTP request stream
        while (($bytesRead = $localFileStream.Read($buffer, 0, $bufferSize)) -gt 0) {
            $ftpStream.Write($buffer, 0, $bytesRead)
            # Calculate progress and update the progress bar
            $progress = ($localFileStream.Position / $fileSize) * 100
            Write-Progress -Activity "Uploading file" -Status "Progress" -PercentComplete $progress
            # Display verbose information
            Write-Verbose "Uploaded $bytesRead bytes"
        }
    }
    finally {
        # Close the local file stream and FTP request stream
        if ($localFileStream) {
            $localFileStream.Dispose()
        }
        if ($ftpStream) {
            $ftpStream.Dispose()
        }
    }
    $ftpResponse = $ftpRequest.GetResponse()
    $ftpResponse.Close()
    # Clear the progress bar
    Write-Progress -Activity "Uploading file" -Completed
    # Removes exported files from host
    Use-Command "Remove-Item -Path `"$localFilePath`" -Force"
    Foreach ($item in $array12){
        Remove-Item ".\$item" -Force
    }
}

# SIG # Begin signature block
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUgDz8lH9OdPDQkws6mLeSa6d5
# v7+gggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFKa1TznfOciYKoU4Mhh7rcp63KL9MA0GCSqGSIb3DQEB
# AQUABIIBAAIkHKqG7uWcN3ZHySneqfCDZ/0A0q0sZjgziOGoP++AeQBBfRnUkQ3k
# nGCRzgWaXblXbTp+I0SnPBdIPapO9ixWrLWm6fP9lYCMrEZlkSwZRA6X9RzpaUgT
# CFrbIijY9YFi3yb313Jqt+XYDqTyPKTOshAiH2gYef9rC407KTcEUtPoI9PRUyr/
# IPATLbPtztCa/+i72KclEbtnqw60rsDWDFd20BqgxplAgfOuoEphLOiG0awEFfJG
# RVbPwPDrVn3BI9FCFdnLVpRUf4xFScpYuYrVsBfcGKbxRUMgvx5Fn6g2MFuUOu3A
# 4HQT1Dcz+HW2SD80CQmnBdd8HRjeqTE=
# SIG # End signature block
