<#
.SYNOPSIS
Downloads and validates necessary files and folders for the application to run.

.DESCRIPTION
The Get-Assets function is used to download and validate the required files and folders for the application to run. It checks if specific folders exist and creates them if they don't. It then scans for existing files and downloads any missing files from GitHub. The function also removes temporary files used during the process.

.PARAMETER None
This function does not accept any parameters.

.NOTES
Ensure that the user running this function has an active network connection and access to the required URLs for downloading missing files from GitHub.
#>
Function Get-Assets {
    Try {
        # Checks if the script folders exist, if they don't they're created
        $folders = @("bin", "assets", "lib", "lib\scripts")
        $folders | ForEach-Object {
            if (!(Test-Path ".\$_" -PathType Container -ErrorAction SilentlyContinue)) {
                Write-Status -Types "+" -Status "Creating $_ Folder."
                New-Item -ItemType Directory -Path ".\$_" -Force | Out-Null
            }
        }
        # removes the temp file used to modify url's into paths
        If (Test-Path ".\tmp.txt") {
            Write-Status -Types "-" -Status "Removing a previously runs tmp.txt."
            Remove-Item ".\tmp.txt" -Force -ErrorAction SilentlyContinue
        }
        # removes any existing error log in script folder
        If (Test-Path .\ErrorLog.txt) {
            Write-Status -Types "-" -Status "Removing a previous runs ErrorLog.txt."
            Remove-Item -Path ".\ErrorLog.txt" -Force -ErrorAction SilentlyContinue
        }
    } Catch 
    {
        Write-Error "An error occurred while creating folders or removing files: $_"
    }
    Write-Section -Text "Scanning Exisitng Files"

    # Creates an array for missing files
    $Items = [System.Collections.ArrayList]::new()

    # Checks if each file exists on the computer #
    ForEach ($file in $files) 
    {
        If (Test-Path ".\$file" -PathType Leaf -ErrorAction SilentlyContinue) 
        {
            Write-CaptionSucceed -Text "$file found"
        } else 
        {
            Write-CaptionFailed -Text "$file not found."
            $Items += $file
        }
    }

    # Validates files - Downloads missing files from github #
    If (!($Items)) 
    {
        Write-Section -Text "All packages successfully validated."
    } else 
    {
        $ItemsFile = ".\tmp.txt"
        $Items | Out-File $ItemsFile -Encoding ASCII 
        # Replaces URL to a Path
        (Get-Content $ItemsFile).replace('\', '/') | Set-Content $ItemsFile
        $Global:urls = Get-Content $ItemsFile

        Write-Section -Text "Downloading Missing Files"
        ForEach ($url in $urls) 
        {
            $link = $NewLoadsURLMain + $url
            Write-Status -Types "+","Modules" -Status "Downloading $url" -NoNewLine
            # Checks for active network connection
            Get-NetworkStatus
            # Downloads each missing file from https://github.com/circlol/newloadsTesting
            Start-BitsTransfer -Dynamic -Source "$link" -Destination ".\$url" -TransferType Download -Confirm:$False -OutVariable bitsTransfers
            Check
        } 
        While ((Get-BitsTransfer | Where-Object {$_.JobState -eq "Transferring"})) 
        {
            ""
            Write-Verbose "Waiting for downloads to complete..."
            Start-Sleep -Seconds 1
        }
        
        $status = Get-BitsTransfer | Where-Object {$_.JobState -eq "Error"}
        If ($status) 
        {
            Write-Error "An error occurred while downloading files : $status"
        }
        ""
        # Removes the temporary file used for formatting
        Write-Status -Types "-" -Status "Removing $ItemsFile"
        Remove-Item $ItemsFile -Force -ErrorAction SilentlyContinue
        }
}