param(
    [switch]$GUI,
    [switch]$NoBranding,
    [switch]$revert,
    [switch]$SkipADW,
    [switch]$SkipBitlocker,
    [switch]$SkipPrograms,
    [Switch]$WhatIf
)
if ($GUI -and ($NoBranding -or $SkipADW -or $SkipBitlocker -or $SkipPrograms)) {
    Throw "New Loads Error: The GUI switch can only be used on its own"
}

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
$LogoColor = "DarkMagenta"
$WindowTitle = "New Loads"
[Int]$Global:Counter = 0
$Global:ForegroundColor = "DarkMagenta"
$Global:BackgroundColor = "Black"
$host.UI.RawUI.ForegroundColor = 'White'
$host.UI.RawUI.BackgroundColor = 'Black'
$host.UI.RawUI.WindowTitle = $WindowTitle
New-Variable -Name "ProgramVersion" -Value "v2023.1.06" -Scope Global -Force
New-Variable -Name "ReleaseDate" -Value "July 31st, 2023" -Scope Global -Force
New-Variable -Name "NewLoadsURLMain" -Value "https://raw.githubusercontent.com/circlol/newloadsTesting/main/" -Scope Global -Force -Option ReadOnly
New-Variable -Name "LicenseURI" -Value "https://raw.githubusercontent.com/circlol/newloadsTesting/main/assets/license.txt" -Force -Option ReadOnly
New-Variable -Name "Files" -Value @(        
    "assets\mother.deskthemepack"
    "assets\Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx",
    "assets\start.bin",
    "assets\start2.bin"
    #"lib\InstalledProgram.psm1"
    #"lib\Get-DisplayResolution.psm1"
    #"lib\Get-HardwareInfo.psm1"
    #"lib\Get-MsStoreUpdates.psm1"
    #"lib\GUI.psm1"
    #"lib\New-SystemRestorePoint.psm1"
    #"lib\Remove-UWPAppx.psm1"
    #"lib\Request-PCRestart.psm1"
    #"lib\Restart-Explorer.psm1"
    #"lib\Set-ItemPropertyVerified.psm1"
    #"lib\Set-Scheduled-Task-State.psm1"
    #"lib\Set-ServiceStartup.psm1"
    #"lib\Set-Windows-Feature-State.psm1"
    #"lib\Start-BitLockerDecryption.psm1"
    #"lib\Use-Command.psm1"
    #"lib\scripts\ADWCleaner.psm1"
    #"lib\scripts\Branding.psm1"
    #"lib\scripts\Cleanup.psm1"
    #"lib\scripts\Debloat.psm1"
    #"lib\scripts\GeneralTweaks.psm1"
    #"lib\scripts\Logs.psm1"
    #"lib\scripts\Office.psm1"
    #"lib\scripts\OptionalFeatures.psm1"
    #"lib\scripts\Performance.psm1"
    #"lib\scripts\Privacy.psm1"
    #"lib\scripts\Programs.psm1"
    #"lib\scripts\Remove-StartMenuPins.psm1"
    #"lib\scripts\Security.psm1"
    #"lib\scripts\Services.psm1"
    #"lib\scripts\StartMenu.psm1"
    #"lib\scripts\TaskScheduler.psm1"
    #"lib\scripts\Visuals.psm1"
) -Force -Scope Global 
#Clear-Host


Function Check {
<#
.SYNOPSIS
Displays the status of the command execution (successful or unsuccessful) and additional error information if the command fails.

.DESCRIPTION
The Check function is used to display the status of the most recently executed command. If the command is successful, it will show "Successful" with a success caption. If the command is unsuccessful, it will show "Unsuccessful" with a failed caption and also display additional error information, including the error message, error type, and line number where the error occurred.

.PARAMETER None
This function does not accept any parameters.

.NOTES
The Check function is typically used after running a command to quickly check whether it executed successfully or encountered an error.
#>
    if ($?) {
        Write-CaptionSucceed -Text "Successful"
    } else {
        $errorMessage = $Error[0].Exception.Message
        $lineNumber = $Error[0].InvocationInfo.ScriptLineNumber
        $command = $Error[0].InvocationInfo.Line
        $errorType = $Error[0].CategoryInfo.Reason
        Write-CaptionFailed -Text "Unsuccessful"
        Write-Host "Command Run: $command `nError Type: $Errortype `nError Message: $errormessage `nLine Number: $linenumber " -ForegroundColor Red
    }
}

function Find-OptionalFeature {
<#
.SYNOPSIS
    Checks if a specified Windows optional feature is available on the host.

.DESCRIPTION
    The Find-OptionalFeature function is used to check if a specified Windows optional feature is available on the host machine. It queries the installed optional features using `Get-WindowsOptionalFeature` cmdlet and returns a boolean value indicating if the feature is found or not.

.PARAMETER OptionalFeature
    Specifies the name of the Windows optional feature to check for. This parameter is mandatory.

.OUTPUTS
    The function outputs a boolean value indicating whether the specified optional feature is found or not. If the feature is found, the function returns $true. If the feature is not found, the function returns $false.

.EXAMPLE
    $featureFound = Find-OptionalFeature -OptionalFeature "Microsoft-Windows-Subsystem-Linux"

    DESCRIPTION
        Checks if the "Microsoft-Windows-Subsystem-Linux" optional feature is available on the host. If found, the $featureFound variable will be set to $true.

.EXAMPLE
    if (Find-OptionalFeature -OptionalFeature "Telnet-Client") {
        Write-Host "The Telnet Client feature is available."
    } else {
        Write-Host "The Telnet Client feature is not available."
    }

    DESCRIPTION
        Checks if the "Telnet-Client" optional feature is available on the host and displays a corresponding message based on the result.

#>
    [CmdletBinding()]
    [OutputType([Bool])]
    param (
        [Parameter(Mandatory = $true)]
        [String] $OptionalFeature
    )

    $feature = Get-WindowsOptionalFeature -Online -FeatureName $OptionalFeature -ErrorAction SilentlyContinue
    if ($feature) {
        return $true
    } else {
        Write-Status -Types "?", $TweakType -Status "The $OptionalFeature optional feature was not found."
        return $false
    }
}
function Find-ScheduledTask() {
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

Function Get-Assets {
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
    If (!($Items)) {

        Write-Section -Text "All packages successfully validated."
        } 
        else 
        {

        $ItemsFile = ".\tmp.txt"
        $Items | Out-File $ItemsFile -Encoding ASCII 
        # Replaces URL to a Path
        (Get-Content $ItemsFile).replace('\', '/') | Set-Content $ItemsFile
        $Global:urls = Get-Content $ItemsFile

        Write-Section -Text "Downloading Missing Files"
        ForEach ($url in $urls) {
            # Combines url to create a download link - 
            $link = $NewLoadsURLMain + $url
            Write-Status -Types "+","Modules" -Status "Downloading $url" -NoNewLine
            # Checks for active network connection
            Get-NetworkStatus
            # Downloads each missing file from https://github.com/circlol/newload
            Start-BitsTransfer -Dynamic -Source "$link" -Destination ".\$url" -TransferType Download -Confirm:$False -OutVariable bitsTransfers
            # Checks Last command
            Check
        } 
        # Removes the temporary file used for formatting
        Write-Status -Types "-" -Status "Removing $ItemsFile"
        Remove-Item $ItemsFile -Force -ErrorAction SilentlyContinue
        }
}
Function Get-ADWCleaner() {
    # - Checks if executable exists
    If (!(Test-Path ".\bin\adwcleaner.exe")){
        Write-Status -Types "+","ADWCleaner" -Status "Downloading ADWCleaner"
        # - Downloads ADW
        Use-Command "Start-BitsTransfer -Source `"$adwLink`" -Destination `"$adwDestination`""
    }
    Write-Status -Types "+","ADWCleaner" -Status "Starting ADWCleaner with ArgumentList /Scan & /Clean"
    # - Runs ADW
    Use-Command "Start-Process -FilePath `"$adwDestination`" -ArgumentList `"/EULA`",`"/PreInstalled`",`"/Clean`",`"/NoReboot`" -Wait -NoNewWindow"
    Write-Status -Types "-","ADWCleaner" -Status "Removing traces of ADWCleaner"
    # - Removes traces of adw from system
    Use-Command "Start-Process -FilePath `"$adwDestination`" -ArgumentList `"/Uninstall`",`"/NoReboot`" -WindowStyle Minimized"
}
function Get-CPU {
<#
.SYNOPSIS
    Retrieves information about the CPU of the current system.

.DESCRIPTION
    The Get-CPU function gathers information about the CPU (Central Processing Unit) of the current system using the Win32_Processor class. It provides options to display only the CPU name or detailed information, including the architecture, name, number of cores, and number of threads.

.PARAMETER NameOnly
    If specified, only the name of the CPU is returned, excluding other details like architecture, cores, and threads.

.PARAMETER Separator
    Specifies the separator character to use between different pieces of CPU information when returning the detailed information. The default separator is '|'.

.OUTPUTS
    System.String
        Returns a string containing CPU information. The format depends on the parameters provided:
        - If -NameOnly is specified, only the CPU name is returned.
        - If -NameOnly is not specified, the function returns the CPU architecture, name, number of cores, and number of threads.

.EXAMPLE
    Get-CPU

    DESCRIPTION
        Retrieves detailed information about the CPU of the current system and returns it in the following format:
        "Architecture | CPU Name (Cores/Threads)"

.EXAMPLE
    Get-CPU -NameOnly

    DESCRIPTION
        Retrieves only the name of the CPU of the current system and returns it as a string.

#>
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Switch] $NameOnly,
        [String] $Separator = '|'
    )
    try {
        $cpuName = (Get-CimInstance -Class Win32_Processor).Name
    }
    catch {
        Write-Error "Error retrieving CPU information: $_"
        return
    }
    if ($NameOnly) {
        return $cpuName
    }
    $cores = (Get-CimInstance -class Win32_Processor).NumberOfCores
    $threads = (Get-CimInstance -class Win32_Processor).NumberOfLogicalProcessors
    $cpuCoresAndThreads = "($cores`C/$threads`T)"
    return "$Env:PROCESSOR_ARCHITECTURE $Separator $cpuName $cpuCoresAndThreads"
}
function Get-DriveInfo {
<#
.SYNOPSIS
Retrieves information about physical disks on the host machine.

.DESCRIPTION
The Get-DriveInfo function retrieves information about physical disks on the host machine using the Get-PhysicalDisk cmdlet. It gathers details such as the Model (friendly name), Type (drive media type), Size (in GB), and Health Status for each physical disk with valid drive type information.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Get-DriveInfo
This example retrieves information about all physical disks on the host machine and displays the Model, Type, Size (GB), and Health Status for each disk.

.NOTES
The Get-DriveInfo function uses the Get-PhysicalDisk cmdlet to gather details about physical disks. The resulting information is formatted into a custom object with the desired properties.
#>
    [CmdletBinding()]
    param ()
    
    $driveInfo = @()

    $physicalDisks = Get-PhysicalDisk | Where-Object { $null -ne $_.MediaType }

    foreach ($disk in $physicalDisks) {
        $model = $disk.FriendlyName
        $driveType = $disk.MediaType
        $sizeGB = [math]::Round($disk.Size / 1GB)
        $healthStatus = $disk.HealthStatus

        $driveInfo += [PSCustomObject]@{
            "Status" = $healthStatus
            Model = $model
            Type = $driveType
            "Capacity" = "${sizeGB} GB"
        }
    }

    return $driveInfo
}
function Get-DriveSpace {
<#
.SYNOPSIS
    Retrieves available space and usage information for one or all fully mounted drives.

.DESCRIPTION
    The Get-DriveSpace function is used to retrieve the available space and usage information for one or all fully mounted drives on the host machine. By default, it displays information for the system drive (usually "C:" drive), but you can specify a different drive using the -DriveLetter parameter.

.PARAMETER DriveLetter
    Specifies the drive letter for which you want to retrieve the available space and usage information. The default value is the system drive letter (usually "C:"). You can specify a different drive letter in the format "X:" where X is the drive letter.

.EXAMPLE
    Get-DriveSpace
    OUTPUT: "C: 100.2GB/237.5GB (42.2% Available)"

    This example retrieves the available space and usage information for the system drive (C: drive) and displays it in the format "DriveLetter: AvailableSpace/TotalSpace (Percentage Available)".

.EXAMPLE
    Get-DriveSpace -DriveLetter D:
    OUTPUT: "D: 435.6GB/931.5GB (46.7% Available)"

    This example retrieves the available space and usage information for drive D: and displays it in the format "DriveLetter: AvailableSpace/TotalSpace (Percentage Available)".

.NOTES
    The Get-DriveSpace function uses the Get-PSDrive cmdlet with the FileSystem provider to retrieve information about the available space and usage for the specified drive or all fully mounted drives.

#>
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [String] $DriveLetter = $env:SystemDrive[0]
    )

    process {
        $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Free -ge 0 -and $_.Used -ge 0 }

        foreach ($drive in $drives) {
            $driveLetter = $drive.Name
            $availableStorage = $drive.Free / 1GB
            $totalStorage = ($drive.Free + $drive.Used) / 1GB
            $percentageAvailable = [math]::Round(($availableStorage / $totalStorage) * 100, 1)

            $driveInfo = "$driveLetter`: $([math]::Round($availableStorage, 1))/$([math]::Round($totalStorage, 1)) GB ($percentageAvailable% Available)"
            Write-Output $driveInfo
        }
    }
}
function Get-GPU {
<#
.SYNOPSIS
    Retrieves the name of the GPU (Graphics Processing Unit) of the current system.

.DESCRIPTION
    The Get-GPU function gathers information about the GPU (Graphics Processing Unit) of the current system using the Win32_VideoController class. It retrieves and returns the name of the GPU.

.OUTPUTS
    System.String
        Returns a string containing the name of the GPU.

.EXAMPLE
    Get-GPU

    DESCRIPTION
        Retrieves the name of the GPU of the current system and returns it as a string.

#>
    [CmdletBinding()]
    [OutputType([String])]
    param ()
    $gpu = Get-CimInstance -Class Win32_VideoController | Select-Object -ExpandProperty Name
    return $gpu.Trim()
}
Function Get-InstalledProgram {
    [CmdletBinding()]
    [OutputType([Bool])]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Keyword
    )
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $installedPrograms = Get-ChildItem -Path $registryPath
    $matchingPrograms = $installedPrograms | Where-Object { 
        ($_.GetValue("DisplayName") -like "*$Keyword*") -or 
        ($_.GetValue("DisplayVersion") -like "*$Keyword*") -or 
        ($_.GetValue("Publisher") -like "*$Keyword*") -or 
        ($_.GetValue("Comments") -like "*$Keyword*") 
    }
    # - Output the matching programs as a list of objects with Name, Version, Publisher, and UninstallString properties
    $matchingPrograms | ForEach-Object {
        [PSCustomObject]@{
            Name = $_.GetValue("DisplayName")
            Version = $_.GetValue("DisplayVersion")
            Publisher = $_.GetValue("Publisher")
            UninstallString = $_.GetValue("UninstallString")
        }
    }
}
Function Get-MainScriptLogo {
<#
.SYNOPSIS
Displays a custom logo and information about the application during its initialization.

.DESCRIPTION
The Get-MainScriptLogo function is used to display a custom logo and relevant information about the application during its initialization. The function prints the logo, the creator's name, the last update version, release date, and important notices about updating the system to the latest version of Windows for correct application functionality.

.PARAMETER None
This function does not accept any parameters.

.NOTES
The Get-MainScriptLogo function is typically used during the application's bootup process to provide essential information to users.
#>
    $WindowTitle = "New Loads - Initialization" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "`n`n`n▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀`n`n" -NoNewLine -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    $Logo = "
                        ███╗   ██╗███████╗██╗    ██╗    ██╗      ██████╗  █████╗ ██████╗ ███████╗
                        ████╗  ██║██╔════╝██║    ██║    ██║     ██╔═══██╗██╔══██╗██╔══██╗██╔════╝
                        ██╔██╗ ██║█████╗  ██║ █╗ ██║    ██║     ██║   ██║███████║██║  ██║███████╗
                        ██║╚██╗██║██╔══╝  ██║███╗██║    ██║     ██║   ██║██╔══██║██║  ██║╚════██║
                        ██║ ╚████║███████╗╚███╔███╔╝    ███████╗╚██████╔╝██║  ██║██████╔╝███████║
                        ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝
                        "
    Write-Host "$Logo`n`n" -ForegroundColor $LogoColor -BackgroundColor Black -NoNewline
    Write-Host "                             Created by " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "Papi" -ForegroundColor Red -BackgroundColor Black -NoNewLine
    Write-Host "      Last Update: " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "$ProgramVersion - $ReleaseDate" -ForegroundColor Green -BackgroundColor Black
    Write-Host "`n`n  Notice: " -NoNewLine -ForegroundColor RED -BackgroundColor Black
    Write-Host "For New Loads to function correctly, it is important to update your system to the latest version of Windows." -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "`n`n`n▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀`n`n" -ForegroundColor $LogoColor -BackgroundColor Black
    $WindowTitle = "New Loads" ; $host.UI.RawUI.WindowTitle = $WindowTitle
}
Function Get-NetworkStatus {
<#
.SYNOPSIS
Checks the network connectivity status and waits for an active internet connection.

.DESCRIPTION
The Get-NetworkStatus function checks the network connectivity status and waits for an active internet connection to proceed with the application. It checks the IPv4 connectivity status (by default) of the current network connection profile. If there is no internet connectivity, the function displays a warning message and waits until the internet connection is established.

.PARAMETER NetworkStatusType
Specifies the network status type to check. The default value is "IPv4Connectivity." Other possible values include "IPv4Connectivity" and "IPv6Connectivity."

.EXAMPLE
Get-NetworkStatus
This example checks the IPv4 connectivity status of the current network connection profile and waits until an internet connection is established.

.NOTES
The Get-NetworkStatus function is typically used to ensure that the application has an active internet connection before performing specific tasks that require internet access.
#>
    [CmdletBinding()]
    param(
        [string]$NetworkStatusType = "IPv4Connectivity"
    )
    $NetStatus = (Get-NetConnectionProfile).$NetworkStatusType
    if ($NetStatus -ne 'Internet') {
        Write-Status -Types "WAITING" -Status "Seems like there's no network connection. Please reconnect." -WriteWarning
        while ($NetStatus -ne 'Internet') {
            Write-Status -Types ":(" -Status "Waiting for internet..."
            Start-Sleep -Seconds 2
            $NetStatus = (Get-NetConnectionProfile).$NetworkStatusType
        }
        Start-Sleep -Seconds 3
        Write-Status -Types ":)" -Status "Connected. Moving on."
    }
}
Function Get-Office {
    Write-Status -Types "?" -Status "Checking for Office"
    If (Test-Path "$PathToOffice64") { $office64 = $true }Else { $office64 = $false }
    If (Test-Path "$PathToOffice86") { $Office32 = $true }Else { $office32 = $false }
    If ($office32 -eq $true) { $officecheck = $true }
    If ($office64 -eq $true) { $officecheck = $true }
    If ($officecheck -eq $true) { Write-Status -Types "WAITING" -Status "Office Exists" -WriteWarning }Else { Write-Status -Types "?" -Status "Office Doesn't Exist on This Machine" -WriteWarning }
    If ($officecheck -eq $true) { Remove-Office }
}
function Get-OSArchitecture {
<#
.SYNOPSIS
    Retrieves the architecture of the operating system.

.DESCRIPTION
    The Get-OSArchitecture function gathers information about the operating system architecture using the Win32_OperatingSystem class and returns the value as a string.

.OUTPUTS
    System.String
        Returns a string representing the architecture of the operating system.

.EXAMPLE
    Get-OSArchitecture

    DESCRIPTION
        Retrieves the architecture of the operating system and returns it as a string.

#>
    [CmdletBinding()]
    [OutputType([String])]
    param ()
    $osarch = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
    return $osarch
}
Function Get-Programs() {
    $chrome = @{
        Name = "Google Chrome"
        Location = "$Env:PROGRAMFILES\Google\Chrome\Application\chrome.exe"
        DownloadURL = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
        Installer = ".\bin\googlechromestandaloneenterprise64.msi"
        ArgumentList = "/passive"}
    $vlc = @{
        Name = "VLC Media Player"
        Location = "$Env:PROGRAMFILES\VideoLAN\VLC\vlc.exe"
        #DownloadURL = "https://get.videolan.org/vlc/3.0.18/win64/vlc-3.0.18-win64.exe"
        DownloadURL = "https://ftp.osuosl.org/pub/videolan/vlc/3.0.18/win64/vlc-3.0.18-win64.exe"
        Installer = ".\bin\vlc-3.0.18-win64.exe"
        ArgumentList = "/S /L=1033"}
    $zoom = @{
        Name = "Zoom"
        Location = "$Env:PROGRAMFILES\Zoom\bin\Zoom.exe"
        #DownloadURL = "https://zoom.us/client/5.13.5.12053/ZoomInstallerFull.msi?archType=x64"
        #DownloadURL = "https://zoom.us/client/5.15.1.17948/ZoomInstallerFull.msi?archType=x64"
        DownloadURL = "https://zoom.us/client/5.15.2.18096/ZoomInstallerFull.msi?archType=x64"
        Installer = ".\bin\ZoomInstallerFull.msi"
        ArgumentList = "/quiet"}
    $acrobat = @{
        Name = "Adobe Acrobat Reader"
        Location = "${Env:Programfiles(x86)}\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"
        DownloadURL = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2200120169/AcroRdrDC2200120169_en_US.exe"
        Installer = ".\bin\AcroRdrDCx642200120085_MUI.exe"
        ArgumentList = "/sPB"}

    foreach ($program in $chrome, $vlc, $zoom, $acrobat) {
        Write-Section -Text $program.Name
        # - Downloads each program if not found
        If (!(Test-Path -Path:$program.Location)) {
            If (!(Test-Path -Path:$program.Installer)) {
                Get-NetworkStatus
                Write-Status -Types "+", $TweakType -Status "Downloading $($program.Name)" -NoNewLine
                Start-BitsTransfer -Source $program.DownloadURL -Destination $program.Installer -TransferType Download -Dynamic
                Check
            }

            # - Installs UBlock Origin
            Write-Status -Types "+", $TweakType -Status "Installing $($program.Name)"
            If ($($program.Name) -eq "Google Chrome"){
                Start-Process -FilePath $program.Installer -ArgumentList $program.ArgumentList -Wait
                Write-Status "+", $TweakType -Status "Adding UBlock Origin to Google Chrome" -NoNewLine
                Set-ItemPropertyVerified -Path $PathToUblockChrome -Name "update_url" -value $PathToChromeLink -Type STRING
            }Else {
                # - Runs Installer setup
                Start-Process -FilePath $program.Installer -ArgumentList $program.ArgumentList
            }
        # - Installs hevc/h.265 codec
        If ($($Program.Name) -eq "$VLC.Name"){
            Write-Status -Types "+", $TweakType -Status "Adding support to HEVC/H.265 video codec (MUST HAVE)..." -NoNewLine
            Add-AppPackage -Path $HVECCodec -ErrorAction SilentlyContinue
            Check
        }
        } else {
            Write-Status -Types "@", $TweakType -Status "$($program.Name) already seems to be installed on this system.. Skipping Installation"
        }
    }
}
function Get-RAM {
<#
.SYNOPSIS
    Retrieves the amount of RAM (Random Access Memory) installed on the current system.

.DESCRIPTION
    The Get-RAM function gathers information about the RAM (Random Access Memory) installed on the current system using the Win32_ComputerSystem class. It calculates the total physical memory and returns the value in GB.

.OUTPUTS
    System.String
        Returns a formatted string representing the amount of RAM in GB.

.EXAMPLE
    Get-RAM

    DESCRIPTION
        Retrieves the amount of RAM installed on the current system and returns it as a formatted string in GB.

#>
    [CmdletBinding()]
    [OutputType([String])]
    param ()
    $ram = Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
    $ram = $ram / 1GB
    return "{0:N2} GB" -f $ram
}
function Get-SystemSpec {
<#
.SYNOPSIS
Retrieves system specifications including operating system information, display version, RAM, CPU, GPU, and drive type.

.DESCRIPTION
The Get-SystemSpec function gathers various system specifications, including the operating system information (Windows version), display version, RAM size, CPU details, GPU details, and operating system drive type. The function utilizes several helper functions (e.g., Get-OSDriveType, Get-RAM, Get-CPU, Get-GPU) to retrieve this information.

.PARAMETER Separator
The separator used to separate different parts of the system specifications. The default value is '|'.

.EXAMPLE
Get-SystemSpec
This example retrieves and displays various system specifications, including the operating system version, display version, RAM size, CPU details, GPU details, and operating system drive type.

.NOTES
The Get-SystemSpec function uses several helper functions to gather system specifications. Ensure that the helper functions (Get-OSDriveType, Get-RAM, Get-CPU, Get-GPU) are available and properly defined in the PowerShell environment.
#>
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $false)]
        [String] $Separator = '|'
    )

    # Adapted From: https://www.delftstack.com/howto/powershell/find-windows-version-in-powershell/#using-the-wmi-class-with-get-wmiobject-cmdlet-in-powershell-to-get-the-windows-version
    $WinVer = (Get-CimInstance -class Win32_OperatingSystem).Caption -replace 'Microsoft ', ''
    $DisplayVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").DisplayVersion
    $OldBuildNumber = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
    $DisplayedVersionResult = '(' + @{ $true = $DisplayVersion; $false = $OldBuildNumber }[$null -ne $DisplayVersion] + ')'

    return <#$(Get-OSDriveType), $Separator,#> $WinVer, $DisplayedVersionResult, $Separator, $(Get-RAM), $Separator, $(Get-CPU -Separator $Separator), $Separator, $(Get-GPU)
}

Function Import-NewLoadsModules {
<#
.SYNOPSIS
Imports custom PowerShell modules (psm1 files) located in the current directory and its subdirectories.

.DESCRIPTION
The Import-NewLoadsModules function is used to import custom PowerShell modules (psm1 files) located in the current directory and its subdirectories. The function searches for all psm1 files, excluding the file named 'assets.psm1', and imports them using the Import-Module cmdlet. The -Force parameter is used to ensure that the modules are imported even if they were previously imported, and the -Global parameter makes the modules available in the global scope.

.PARAMETER None
This function does not accept any parameters.

.NOTES
Ensure that the custom modules (psm1 files) are placed in the same directory or its subdirectories before running this function. This function is typically used to load custom modules required for the New Loads application.
#>
    $Modules = Get-ChildItem -Path ".\" -Include "*.psm1" -Recurse -Exclude 'assets.psm1'
    ForEach ($Module in $Modules) {
        Write-Status -Types "+","Modules" -Status "Importing $Module" -NoNewLine
        Import-Module ($Module).FullName -Force -Global
        Check
    }
}
Function Import-Variables {
<#
.SYNOPSIS
Creates and initializes various global variables used throughout the script.

.DESCRIPTION
The Import-Variables function creates and initializes various global variables that are used throughout the script. It sets default values for these variables to facilitate their usage in different parts of the script. These variables store information such as file paths, version numbers, temporary directories, etc.

.PARAMETER None
This function does not accept any parameters.

.NOTES
The Import-Variables function is used at the beginning of the script to set up important global variables required for the New Loads application.
#>
    # -> Main Script Variables
    New-Variable -Name "NewLoads" -Value "." -Scope Global -Force
    New-Variable -Name "MaxLength" -Value '11' -Scope Global -Force
    New-Variable -Name "ErrorLog" -Value "$NewLoads\ErrorLog.txt" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Log" -Value "$NewLoads\Log.txt" -Scope Global -Force
    New-Variable -Name "temp" -Value "$env:temp" -Scope Global -Force
    New-Variable -Name "Win11" -Value "22000" -Scope Global -Force
    New-Variable -Name "22H2" -Value "22621" -Scope Global -Force
    New-Variable -Name "BuildNumber" -Value [System.Environment]::OSVersion.Version.Build -Scope Global -Force
    New-Variable -Name "NetStatus" -Value (Get-NetConnectionProfile).IPv4Connectivity -Scope Global -Force
    New-Variable -Name "Connected" -Value "Internet" -Scope Global -Force
    #New-Variable -Name "HVECCodec" -Value ".\assets\Microsoft.HEVCVideoExtension_2.0.51121.0_x64__8wekyb3d8bbwe.appx" -Scope Global    
    New-Variable -Name "HVECCodec" -Value  "Assets\Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx" -Scope Global -Force
    New-Variable -Name "DriverSelectorPath" -Value "$NewLoads\~ extra\Driver Grabber.exe" -Scope Global -Force
    New-Variable -Name "WindowsUpdatesPath" -Value "$NewLoads\~ extra\Windows Updates.exe" -Scope Global -Force
    New-Variable -Name "StartBinDefault" -Value "$Env:SystemDrive\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\" -Force -Option ReadOnly -Scope Global
    New-Variable -Name "StartBinCurrent" -Value "$Env:userprofile\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState" -Force -Option ReadOnly -Scope Global
    New-Variable -Name "LayoutFile" -Value "$Env:LOCALAPPDATA\Microsoft\Windows\Shell\LayoutModification.xml" -Scope Global -Force -Option ReadOnly
    New-Variable -Name "Shortcuts" -Value @(
        "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
        "$Env:PUBLIC\Desktop\Microsoft Edge.lnk"
        "$Env:PUBLIC\Desktop\Adobe Reader.lnk"
        "$Env:PUBLIC\Desktop\Adobe Reader DC.lnk"
        "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk"
        "$Env:PUBLIC\Desktop\Acrobat Reader DC.lnk"
        "$Env:PUBLIC\Desktop\VLC Media Player.lnk"
        "$Env:PUBLIC\Desktop\Zoom.lnk"
    ) -Scope Global -Force -Option ReadOnly

    New-Variable -Name "adwLink" -Value "https://github.com/circlol/newload/raw/main/adwcleaner.exe" -Force -Scope Global
    New-Variable -Name "adwDestination" -Value "$NewLoads\bin\adwcleaner.exe" -Force -Scope Global
    New-Variable -Name "livesafe" -Value "$Env:PROGRAMFILES\McAfee\MSC\mcuihost.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "WebAdvisor" -Value "$Env:PROGRAMFILES\McAfee\WebAdvisor\Uninstaller.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "WildGames" -Value "${Env:PROGRAMFILES(x86)}\WildGames\Uninstall.exe" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "EdgeShortcut" -Value "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk" -Option ReadOnly -Scope Global -Force
    #New-Variable -Name "AcroSC" -Value "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "AcroSC" -Value "$Env:PUBLIC\Desktop\Acrobat Reader DC.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "EdgeSCPub" -Value "$Env:PUBLIC\Desktop\Microsoft Edge.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "VLCSC" -Value "$Env:PUBLIC\Desktop\VLC Media Player.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "ZoomSC" -Value "$Env:PUBLIC\Desktop\Zoom.lnk" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "CommonApps" -Value "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs" -Option ReadOnly -Scope Global -Force

    #Wallpaper

    #New-Variable -Name "Wallpaper" -Value "$env:appdata\Microsoft\Windows\Themes\MotherComputersWallpaper.jpg" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "ThemeLocation" -Value "$NewLoads\assets\mother.deskthemepack" -Option ReadOnly -Force -Scope Global
    New-Variable -Name "WallpaperDestination" -Value "C:\Windows\Resources\Themes\mother.jpg" -Scope Global -Force
    New-Variable -Name "CurrentWallpaper" -Value (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper).Wallpaper -Option ReadOnly -Scope Global -Force
    New-Variable -Name "sysmode" -Value (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme).SystemUsesLightTheme -Option ReadOnly -Scope Global -Force
    New-Variable -Name "appmode" -Value (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme).AppsUseLightTheme -Option ReadOnly -Scope Global -Force
    #Office Removal
    New-Variable -Name "PathToOffice86" -Value "C:\Program Files (x86)\Microsoft Office" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToOffice64" -Value "C:\Program Files\Microsoft Office 15" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "OfficeCheck" -Value "$false" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Office32" -Value "$false" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Office64" -Value "$false" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "SaRA" -Value "$newloads\SaRA.zip" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Sexp" -Value "$newloads\SaRA" -Option ReadOnly -Scope Global -Force
    #Reg

    New-Variable -Name "UsersFolder" -Value "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Force -Scope Global
    New-Variable -Name "ThisPC" -Value "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Force -Scope Global
    New-Variable -Name "PathToUblockChrome" -Value "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToChromeLink" -Value "https://clients2.google.com/service/update2/crx" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "siufrules" -Value "HKCU:\Software\Microsoft\Siuf\Rules" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLFSVC" -Value "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToWifiSense" -Value "HKLM:\Software\Microsoft\PolicyManager\default\WiFi" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "RegCAM" -Value "HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Website" -Value "https://www.mothercomputers.com" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Hours" -Value "Monday - Saturday 9AM-5PM | Sunday - Closed"  -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Phone" -Value "(250) 479-8561" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Store" -Value "Mother Computers" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Model" -Value "Mother Computers - (250) 479-8561" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Page" -Value "Model" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "TimeoutScreenBattery" -Value 5 -Force -Scope Global
    New-Variable -Name "TimeoutScreenPluggedIn" -Value 10 -Force -Scope Global
    New-Variable -Name "TimeoutStandByBattery" -Value 15 -Force -Scope Global
    New-Variable -Name "TimeoutStandByPluggedIn" -Value 30 -Force -Scope Global
    New-Variable -Name "TimeoutDiskBattery" -Value 15 -Force -Scope Global
    New-Variable -Name "TimeoutDiskPluggedIn" -Value 30 -Force -Scope Global
    New-Variable -Name "TimeoutHibernateBattery" -Value 15 -Force -Scope Global
    New-Variable -Name "TimeoutHibernatePluggedIn" -Value 30 -Force -Scope Global

    New-Variable -Name "PathToUsersControlPanelDesktop" -Value "Registry::HKEY_USERS\.DEFAULT\Control Panel\Desktop" -Force -Scope Global
    New-Variable -Name "PathToCUControlPanelDesktop" -Value "HKCU:\Control Panel\Desktop" -Force -Scope Global
    New-Variable -Name "PathToCUGameBar" -Value "HKCU:\SOFTWARE\Microsoft\GameBar" -Force -Scope Global
    New-Variable -Name "PathToOEMInfo" -Value "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegExplorerLocalMachine" -Value "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegSystem" -Value "HKLM:\Software\Policies\Microsoft\Windows\System" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegInputPersonalization" -Value "HKCU:\Software\Microsoft\InputPersonalization" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegCurrentVersion" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegContentDelivery" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegExplorer" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegExplorerAdv" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegAdvertising" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegPersonalize" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToPrivacy" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToRegSearch" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Option ReadOnly -Scope Global -Force
    # Initialize all Path variables used to Registry Tweaks
    New-Variable -Name "PathToLMActivityHistory" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMAutoLogger" -Value "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger" -Option ReadOnly -Scope Global -Force
    #$PathToLMDeliveryOptimizationCfg = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"
    New-Variable -Name "PathToLMPoliciesAdvertisingInfo" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesCloudContent" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesEdge" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Force -Scope Global
    New-Variable -Name "PathToLMPoliciesPsched" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Psched" -Force -Scope Global
    New-Variable -Name "PathToLMPoliciesSQMClient" -Value "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesTelemetry" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesTelemetry2" -Value "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesToWifi" -Value "HKLM:\Software\Microsoft\PolicyManager\default\WiFi" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMPoliciesWindowsStore" -Value "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore" -Force -Scope Global
    #$PathToLMPoliciesWindowsUpdate = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    New-Variable -Name "PathToLMWindowsTroubleshoot" -Value "HKLM:\SOFTWARE\Microsoft\WindowsMitigation" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUAccessibility" -Value "HKCU:\Control Pane\Accessibility" -Scope Global -Force
    New-Variable -Name "PathToCUContentDeliveryManager" -Value "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUDeviceAccessGlobal" -Value "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUInputPersonalization" -Value "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUInputTIPC" -Value "HKCU:\SOFTWARE\Microsoft\Input\TIPC" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUOnlineSpeech" -Value "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUPoliciesCloudContent" -Value "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUSearch" -Value "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUSiufRules" -Value "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToCUUserProfileEngagemment" -Value "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Scope Global -Force
    New-Variable -Name "PathToVoiceActivation" -Value "HKCU:\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToBackgroundAppAccess" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "PathToLMMultimediaSystemProfile" -Value "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Force -Scope Global
    New-Variable -Name "PathToLMMultimediaSystemProfileOnGameTasks" -Value "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Force -Scope Global
    New-Variable -Name "Programs" -Value @(
# Microsoft Applications
"Microsoft.549981C3F5F10"                   			# Cortana
"Microsoft.3DBuilder"                       			# 3D Builder
"Microsoft.Appconnector"                    			# App Connector
"Microsoft.BingFinance"                     			# Finance
"Microsoft.BingFoodAndDrink"                			# Food And Drink
"Microsoft.BingHealthAndFitness"            			# Health And Fitness
"Microsoft.BingNews"                        			# News
"Microsoft.BingSports"                      			# Sports
"Microsoft.BingTranslator"                  			# Translator
"Microsoft.BingTravel"                      			# Travel
"Microsoft.BingWeather"                     			# Weather
"Microsoft.CommsPhone"                      			# Your Phone
"Microsoft.ConnectivityStore"               			# Connectivity Store
"Microsoft.Messaging"                       			# Messaging
"Microsoft.Microsoft3DViewer"               			# 3D Viewer
"Microsoft.MicrosoftOfficeHub"              			# Office
"Microsoft.MicrosoftPowerBIForWindows"      			# Power Automate
"Microsoft.MicrosoftSolitaireCollection"    			# MS Solitaire
"Microsoft.MinecraftEducationEdition"       			# Minecraft Education Edition for Windows 10
"Microsoft.MinecraftUWP"                    			# Minecraft
"Microsoft.MixedReality.Portal"             			# Mixed Reality Portal
"Microsoft.Office.Hub"                     	 			# Office Hub
"Microsoft.Office.Lens"                     			# Office Lens
"Microsoft.Office.OneNote"                  			# Office One Note
"Microsoft.Office.Sway"                     			# Office Sway
"Microsoft.OneConnect"                     				# OneConnect
"Microsoft.People"                          			# People
"Microsoft.SkypeApp"                        			# Skype (Who still uses Skype? Use Discord)
"MicrosoftTeams"                            			# Teams / Preview
"Microsoft.Todos"                           			# To Do
"Microsoft.Wallet"                          			# Wallet
"Microsoft.Whiteboard"                      			# Microsoft Whiteboard
"Microsoft.WindowsPhone"                    			# Your Phone Alternate
"Microsoft.WindowsReadingList"              			# Reading List
#"Microsoft.WindowsSoundRecorder"            			# Sound Recorder
"Microsoft.ZuneMusic"                       			# Groove Music / (New) Windows Media Player
"Microsoft.ZuneVideo"                       			# Movies & TV
# 3rd party Apps
"*AdobePhotoshopExpress*"                   			# Adobe Photoshop Express
"AdobeSystemsIncorporated.AdobeLightroom"   			# Adobe Lightroom
"AdobeSystemsIncorporated.AdobeCreativeCloudExpress"    # Adobe Creative Cloud Express
"AdobeSystemsIncorporated.AdobeExpress"    				# Adobe Creative Cloud Express
"*Amazon.com.Amazon*"                       			# Amazon
"AmazonVideo.PrimeVideo"                    			# Amazon Prime Video
"57540AMZNMobileLLC.AmazonAlexa"            			# Amazon Alexa
"*BubbleWitch3Saga*"                        			# Bubble Witch 3 Saga
"*CandyCrush*"                              			# Candy Crush
"Clipchamp.Clipchamp"                       			# Clip Champ
"*DisneyMagicKingdoms*"                     			# Disney Magic Kingdom
"Disney.37853FC22B2CE"                      			# Disney Plus
"*Disney*"                                  			# Disney Plus
"*Dolby*"                                   			# Dolby Products (Like Atmos)
"*DropboxOEM*"                              			# Dropbox
"Evernote.Evernote"                         			# Evernote
"*ExpressVPN*"                              			# ExpressVPN
"*Facebook*"                                			# Facebook
"*Flipboard*"                               			# Flipboard
"*Hulu*"                                    			# Hulu
"*Instagram*"                               			# Instagram
"*McAfee*"                                  			# McAfee
"5A894077.McAfeeSecurity"                   			# McAfee Security
"4DF9E0F8.Netflix"                          			# Netflix
"*PicsArt-PhotoStudio*"                     			# PhotoStudio
"*Pinterest*"                               			# Pinterest
"142F4566A.147190D3DE79"                    			# Pinterest
"1424566A.147190DF3DE79"                    			# Pinterest
"SpotifyAB.SpotifyMusic"                    			# Spotify
"*Twitter*"                                 			# Twitter
"*TikTok*"                                  			# TikTok
"5319275A.WhatsAppDesktop"                  			# WhatsApp
# Acer OEM Bloat
"AcerIncorporated.AcerRegistration"         			# Acer Registration
"AcerIncorporated.QuickAccess"              			# Acer Quick Access
"AcerIncorporated.UserExperienceImprovementProgram"     # Acer User Experience Improvement Program
#"AcerIncorporated.AcerCareCenterS"         			# Acer Care Center
"AcerIncorporated.AcerCollectionS"          			# Acer Collections 
# HP Bloat
"AD2F1837.HPPrivacySettings"                			# HP Privacy Settings
"AD2F1837.HPInc.EnergyStar"                 			# Energy Star
"AD2F1837.HPAudioCenter"                    			# HP Audio Center
# Common HP & Acer Bloat
"CyberLinkCorp.ac.PowerDirectorforacerDesktop"          # CyberLink Power Director for Acer
"CorelCorporation.PaintShopPro"                         # Coral Paint Shop Pro
"26720RandomSaladGamesLLC.HeartsDeluxe"                 # Hearts Deluxe
"26720RandomSaladGamesLLC.SimpleSolitaire"              # Simple Solitaire
"26720RandomSaladGamesLLC.SimpleMahjong"                # Simple Mahjong
"26720RandomSaladGamesLLC.Spades"                       # Spades    
) -Scope Global -Force -Option ReadOnly
}

Function New-SystemRestorePoint() {
<#
.SYNOPSIS
Enables System Restore on the system drive and creates a new System Restore point.

.DESCRIPTION
The New-SystemRestorePoint function enables System Restore on the system drive and then creates a new System Restore point with a specified description and type. The function uses the "Enable-ComputerRestore" cmdlet to enable System Restore and the "Checkpoint-Computer" cmdlet to create the restore point.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
New-SystemRestorePoint
This example enables System Restore on the system drive (typically "C:" drive) and creates a new System Restore point with the description "Mother Computers Courtesy Restore Point" and restore point type "MODIFY_SETTINGS".

.NOTES
Ensure that you have administrative privileges to enable System Restore and create restore points on the system drive. The "Enable-ComputerRestore" and "Checkpoint-Computer" cmdlets require administrative rights to execute successfully.
#>
    Write-Status -Types "+", $TweakType -Status "Enabling system drive Restore Point..."
    # - Assures System Restore is enabled
    Use-Command "Enable-ComputerRestore -Drive `"$env:SystemDrive\`""
    # - Creates a System Restore point
    Use-Command 'Checkpoint-Computer -Description "Mother Computers Courtesy Restore Point" -RestorePointType "MODIFY_SETTINGS"'
}

Function Optimize-Performance{
    param(
    [Switch] $Revert,
    [Int]    $Zero = 0,
    [Int]    $One = 1,
    [Int]    $OneTwo = 1
)

$EnableStatus = @(
    @{ Symbol = "-"; Status = "Disabling"; }
    @{ Symbol = "+"; Status = "Enabling"; }
)

If (($Revert)) {
    Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'."
    $Zero = 1
    $One = 0
    $OneTwo = 2
    $EnableStatus = @(
        @{ Symbol = "<"; Status = "Re-Enabling"; }
        @{ Symbol = "<"; Status = "Re-Disabling"; }
    )
}

    $ExistingPowerPlans = $((powercfg -L)[3..(powercfg -L).Count])
    # Found on the registry: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\User\Default\PowerSchemes
    $BuiltInPowerPlans = @{
    "Power Saver"            = "a1841308-3541-4fab-bc81-f71556f20b4a"
    "Balanced (recommended)" = "381b4222-f694-41f0-9685-ff5bb260df2e"
    "High Performance"       = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
    "Ultimate Performance"   = "e9a42b02-d5df-448d-aa00-03f14749eb61"
    }
    $UniquePowerPlans = $BuiltInPowerPlans.Clone()

    Write-Title "Performance Tweaks"
    Write-Section "System"
    Write-Caption "Display"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Enable Hardware Accelerated GPU Scheduling... (Windows 10 20H1+ - Needs Restart)"
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Type DWord -Value 2
    #Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Remote Assistance..."
    #Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value $Zero

    # [@] (2 = Enable Ndu, 4 = Disable Ndu)
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Ndu High RAM Usage..."
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\ControlSet001\Services\Ndu" -Name "Start" -Type DWord -Value 4
    # Details: https://www.tenforums.com/tutorials/94628-change-split-threshold-svchost-exe-windows-10-a.html
    # Will reduce Processes number considerably on > 4GB of RAM systems

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting SVCHost to match installed RAM size..."
    $RamInKB = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1KB
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $RamInKB

    #Write-Status -Types "*", $TweakType -Status "Enabling Windows Store apps Automatic Updates..."
    #If ((Get-Item "$PathToLMPoliciesWindowsStore" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue).GetValueNames() -like "AutoDownload") {
        #Remove-ItemProperty -Path "$PathToLMPoliciesWindowsStore" -Name "AutoDownload" # [@] (2 = Disable, 4 = Enable)
    #}


    Write-Section "Microsoft Edge Tweaks"
    Write-Caption "System and Performance"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Edge Startup boost..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesEdge" -Name "StartupBoostEnabled" -Type DWord -Value $Zero
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) run extensions and apps when Edge is closed..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesEdge" -Name "BackgroundModeEnabled" -Type DWord -Value $Zero

    Write-Section -Text "Power Plan Tweaks"
    Write-Status -Types "@", $TweakType -Status "Cleaning up duplicated Power plans..."
    ForEach ($PowerCfgString in $ExistingPowerPlans) {
        $PowerPlanGUID = $PowerCfgString.Split(':')[1].Split('(')[0].Trim()
        $PowerPlanName = $PowerCfgString.Split('(')[-1].Replace(')', '').Trim()
        If (($PowerPlanGUID -in $BuiltInPowerPlans.Values)) {
            Write-Status -Types "@", $TweakType -Status "The '$PowerPlanName' power plan` is built-in, skipping $PowerPlanGUID ..."
            Continue
        }
        Try {
            If (($PowerPlanName -notin $UniquePowerPlans.Keys) -and ($PowerPlanGUID -notin $UniquePowerPlans.Values)) {
                $UniquePowerPlans.Add($PowerPlanName, $PowerPlanGUID)
            }
            Else {
                Write-Status -Types "-", $TweakType -Status "Duplicated '$PowerPlanName' power plan found, deleting $PowerPlanGUID ..."
                powercfg -Delete $PowerPlanGUID
            }
        }
        Catch {
            Write-Status -Types "-", $TweakType -Status "Duplicated '$PowerPlanName' power plan found, deleting $PowerPlanGUID ..."
            powercfg -Delete $PowerPlanGUID
        }
    }

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Monitor Timeout to AC: $TimeoutScreenPluggedIn and DC: $TimeoutScreenBattery..."
    powercfg -Change Monitor-Timeout-AC $TimeoutScreenPluggedIn
    powercfg -Change Monitor-Timeout-DC $TimeoutScreenBattery

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Standby Timeout to AC: $TimeoutStandByPluggedIn and DC: $TimeoutStandByBattery..."
    powercfg -Change Standby-Timeout-AC $TimeoutStandByPluggedIn
    powercfg -Change Standby-Timeout-DC $TimeoutStandByBattery

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Disk Timeout to AC: $TimeoutDiskPluggedIn and DC: $TimeoutDiskBattery..."
    powercfg -Change Disk-Timeout-AC $TimeoutDiskPluggedIn
    powercfg -Change Disk-Timeout-DC $TimeoutDiskBattery

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Hibernate Timeout to AC: $TimeoutHibernatePluggedIn and DC: $TimeoutHibernateBattery..."
    powercfg -Change Hibernate-Timeout-AC $TimeoutHibernatePluggedIn
    Powercfg -Change Hibernate-Timeout-DC $TimeoutHibernateBattery    

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting Power Plan to High Performance..."
    powercfg -SetActive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c


    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Creating the Ultimate Performance hidden Power Plan..."
    powercfg -DuplicateScheme e9a42b02-d5df-448d-aa00-03f14749eb61


    Write-Section "Network & Internet"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Unlimiting your network bandwidth for all your system..." # Based on this Chris Titus video: https://youtu.be/7u1miYJmJ_4
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesPsched" -Name "NonBestEffortLimit" -Type DWord -Value 0
    Set-ItemPropertyVerified -Path "$PathToLMMultimediaSystemProfile" -Name "NetworkThrottlingIndex" -Type DWord -Value 0xffffffff


    Write-Section "System & Apps Timeout behaviors"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reducing Time to services app timeout to 2s to ALL users..."
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000 # Default: 20000 / 5000
    Write-Status -Types "*", $TweakType -Status "Don't clear page file at shutdown (takes more time) to ALL users..."
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 0 # Default: 0
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reducing mouse hover time events to 10ms..."
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Mouse" -Name "MouseHoverTime" -Type String -Value "1000" # Default: 400


    # Details: https://windowsreport.com/how-to-speed-up-windows-11-animations/ and https://www.tenforums.com/tutorials/97842-change-hungapptimeout-value-windows-10-a.html
    ForEach ($DesktopRegistryPath in @($PathToUsersControlPanelDesktop, $PathToCUControlPanelDesktop)) {
        <# $DesktopRegistryPath is the path related to all users and current user configuration #>
        If ($DesktopRegistryPath -eq $PathToUsersControlPanelDesktop) {
            Write-Caption "TO ALL USERS"
        } ElseIf ($DesktopRegistryPath -eq $PathToCUControlPanelDesktop) {
            Write-Caption "TO CURRENT USER"
        }
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Don't prompt user to end tasks on shutdown..."
        Set-ItemPropertyVerified -Path "$DesktopRegistryPath" -Name "AutoEndTasks" -Type DWord -Value 1 # Default: Removed or 0

        Write-Status -Types "*", $TweakType -Status "Returning 'Hung App Timeout' to default..."
        If ((Get-Item "$DesktopRegistryPath").Property -contains "HungAppTimeout") {
            Remove-Path "$DesktopRegistryPath" -Name "HungAppTimeout"
        }

        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reducing mouse and keyboard hooks timeout to 1s..."
        Set-ItemPropertyVerified -Path "$DesktopRegistryPath" -Name "LowLevelHooksTimeout" -Type DWord -Value 1000 # Default: Removed or 5000

        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reducing animation speed delay to 1ms on Windows 11..."
        Set-ItemPropertyVerified -Path "$DesktopRegistryPath" -Name "MenuShowDelay" -Type DWord -Value 1 # Default: 400

        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reducing Time to kill apps timeout to 5s..."
        Set-ItemPropertyVerified -Path "$DesktopRegistryPath" -Name "WaitToKillAppTimeout" -Type DWord -Value 5000 # Default: 20000
    }

    Write-Section "Gaming Responsiveness Tweaks"
    Write-Status -Types "*", $TweakType -Status "Enabling game mode..."
    Set-ItemPropertyVerified -Path "$PathToCUGameBar" -Name "AllowAutoGameMode" -Type DWord -Value 1
    Set-ItemPropertyVerified -Path "$PathToCUGameBar" -Name "AutoGameModeEnabled" -Type DWord -Value 1

    # Details: https://www.reddit.com/r/killerinstinct/comments/4fcdhy/an_excellent_guide_to_optimizing_your_windows_10/
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reserving 100% of CPU to Multimedia/Gaming tasks..."
    Set-ItemPropertyVerified -Path "$PathToLMMultimediaSystemProfile" -Name "SystemResponsiveness" -Type DWord -Value 0 # Default: 20

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Dedicate more CPU/GPU usage to Gaming tasks..."
    Set-ItemPropertyVerified -Path "$PathToLMMultimediaSystemProfileOnGameTasks" -Name "GPU Priority" -Type DWord -Value 8 # Default: 8
    Set-ItemPropertyVerified -Path "$PathToLMMultimediaSystemProfileOnGameTasks" -Name "Priority" -Type DWord -Value 6 # Default: 2
    Set-ItemPropertyVerified -Path "$PathToLMMultimediaSystemProfileOnGameTasks" -Name "Scheduling Category" -Type String -Value "High" # Default: "Medium"

}
Function Optimize-Privacy {
    param(
    [Switch] $Revert,
    [Int]    $Zero = 0,
    [Int]    $One = 1,
    [Int]    $OneTwo = 1
)

$EnableStatus = @(
    @{ Symbol = "-"; Status = "Disabling"; }
    @{ Symbol = "+"; Status = "Enabling"; }
)

If (($Revert)) {
    Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'."
    $Zero = 1
    $One = 0
    $OneTwo = 2
    $EnableStatus = @(
        @{ Symbol = "<"; Status = "Re-Enabling"; }
        @{ Symbol = "<"; Status = "Re-Disabling"; }
    )
}
    $TweakType = "Privacy"
    Write-Title -Text "Privacy Tweaks"
    Write-Section -Text "Personalization"
    Write-Caption -Text "Start & Lockscreen"
    #Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show me the windows welcome experience after updates..."
    #Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Get fun facts and tips, etc. on lock screen'..."

    $ContentDeliveryManagerDisableOnZero = @(
        "SubscribedContent-310093Enabled"           # "Show me the Windows Welcome Experience after updates and when I sign in highlight whats new and suggested"
        "SubscribedContent-314559Enabled"           # 
        "SubscribedContent-314563Enabled"           # My People Suggested Apps
        "SubscribedContent-338387Enabled"           # Facts, Tips and Tricks on Lock Screen
        "SubscribedContent-338388Enabled"           # App Suggestions on Start
        "SubscribedContent-338389Enabled"           # Tips, Tricks, and Suggestions Notifications
        "SubscribedContent-338393Enabled"           # Suggested content in Settings
        'SubscribedContent-353694Enabled'           # Suggested content in Settings
        'SubscribedContent-353696Enabled'           # Suggested content in Settings
        "SubscribedContent-353698Enabled"           # Timeline Suggestions
        "RotatingLockScreenOverlayEnabled"          # Rotation Lock
        "RotatingLockScreenEnabled"                 # Rotation Lock
        # Prevents Apps from re-installing
        "ContentDeliveryAllowed"                    # Disables Content Delivery
        "FeatureManagementEnabled"                  # 
        "OemPreInstalledAppsEnabled"                # OEM Advertising
        "PreInstalledAppsEnabled"                   # Preinstalled apps like Disney+, Adobe Express, ect.
        "PreInstalledAppsEverEnabled"               # Preinstalled apps like Disney+, Adobe Express, ect.
        "RemediationRequired"                       # 
        "SilentInstalledAppsEnabled"                # 
        "SoftLandingEnabled"                        # 
        "SubscribedContentEnabled"                  # Disables Subscribed content
        "SystemPaneSuggestionsEnabled"              # 
    )

    # Executes the array above
    Write-Status -Types "?", $TweakType -Status "From Path: [$PathToCUContentDeliveryManager]." -WriteWarning
    ForEach ($Name in $ContentDeliveryManagerDisableOnZero) {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $Zero"
        Set-ItemPropertyVerified -Path "$PathToCUContentDeliveryManager" -Name "$Name" -Type DWord -Value $Zero
    }

    # Disables content suggestions in settings
    Write-Status -Types "-", $TweakType -Status "$($EnableStatus[0].Status) 'Suggested Content in the Settings App'..."
    If (Test-Path "$PathToCUContentDeliveryManager\Subscriptions") {
        Remove-Item -Path "$PathToCUContentDeliveryManager\Subscriptions" -Recurse
    }

    # Disables content suggestion in start
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Show Suggestions' in Start..."
    If (Test-Path "$PathToCUContentDeliveryManager\SuggestedApps") {
        Remove-Item -Path "$PathToCUContentDeliveryManager\SuggestedApps" -Recurse
    }

    Write-Section -Text "Privacy -> Windows Permissions"
    Write-Caption -Text "General"

    # Disables Advertiser ID through permissions and group policy.
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Let apps use my advertising ID..."
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Type DWord -Value $Zero -ErrorAction SilentlyContinue
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesAdvertisingInfo" -Name "DisabledByGroupPolicy" -Type DWord -Value $One

    # Disables locally relevant content
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Let websites provide locally relevant content by accessing my language list'..."
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut" -Type DWord -Value $One

    Write-Caption -Text "Speech"
    # Removes consent for online speech recognition services.
    # [@] (0 = Decline, 1 = Accept)
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Online Speech Recognition..."
    Set-ItemPropertyVerified -Path "$PathToCUOnlineSpeech" -Name "HasAccepted" -Type DWord -Value $Zero

    Write-Caption -Text "Inking & Typing Personalization"
    # Disables personalization of inking and typing data (Keystrokes)
    Set-ItemPropertyVerified -Path "$PathToCUInputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value $Zero -ErrorAction SilentlyContinue
    Set-ItemPropertyVerified -Path "$PathToCUInputPersonalization" -Name "RestrictImplicitInkCollection" -Type DWord -Value $One -ErrorAction SilentlyContinue
    Set-ItemPropertyVerified -Path "$PathToCUInputPersonalization" -Name "RestrictImplicitTextCollection" -Type DWord -Value $One -ErrorAction SilentlyContinue
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type DWord -Value $Zero -ErrorAction SilentlyContinue

    Write-Caption -Text "Diagnostics & Feedback"
    #Disables Telemetry
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) telemetry..."
    # [@] (0 = Security (Enterprise only), 1 = Basic Telemetry, 2 = Enhanced Telemetry, 3 = Full Telemetry)
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesTelemetry" -Name "AllowTelemetry" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesTelemetry2" -Name "AllowTelemetry" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesTelemetry" -Name "AllowDeviceNameInTelemetry" -Type DWord -Value $Zero


    # Disables Microsofts collection of inking and typing data
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) send inking and typing data to Microsoft..."
    Set-ItemPropertyVerified -Path "$PathToCUInputTIPC" -Name "Enabled" -Type DWord -Value $Zero

    # Disables Microsoft's tailored experiences.
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Tailored Experiences..."
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Type DWord -Value $Zero

    # Disables transcript of diagnostic data for collection
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) View diagnostic data..."
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey" -Name "EnableEventTranscript" -Type DWord -Value $Zero

    # Sets feedback frequency to 0
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) feedback frequency..."
    If ((Test-Path "$PathToCUSiufRules\PeriodInNanoSeconds")) {
        Remove-ItemProperty -Path "$PathToCUSiufRules" -Name "PeriodInNanoSeconds"
    }
    Set-ItemPropertyVerified -Path "$PathToCUSiufRules" -Name "NumberOfSIUFInPeriod" -Type DWord -Value $Zero

    Write-Caption -Text "Activity History"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Activity History..."
    $ActivityHistoryDisableOnZero = @(
        "EnableActivityFeed"
        "PublishUserActivities"
        "UploadUserActivities"
    )
    Write-Status -Types "?", $TweakType -Status "From Path: [$PathToLMActivityHistory]" -WriteWarning
    ForEach ($Name in $ActivityHistoryDisableOnZero) {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $Zero"
        Set-ItemPropertyVerified -Path "$PathToLMActivityHistory" -Name "$ActivityHistoryDisableOnZero" -Type DWord -Value $Zero
    }

    # Disables Suggested ways of getting the most out of windows (Microsoft account spam)
    Write-Status -Types "-" , $TweakType -Status "$($EnableStatus[1].Status) 'Suggest ways i can finish setting up my device to get the most out of windows.')"
    Set-ItemPropertyVerified -Path $PathToCUUserProfileEngagemment -Name "ScoobeSystemSettingEnabled" -Value "0" -Type DWord
    
    ### Privacy
    Write-Section -Text "Privacy"
    If (Test-Path -Path $PathToRegContentDelivery\Subscriptionn) {
        Remove-Item -Path $PathToRegContentDelivery\Subscriptionn -Recurse -Force
    }
    If (Test-Path -Path $PathToRegContentDelivery\SuggestedApps) {
        Remove-Item -Path $PathToRegContentDelivery\SuggestedApps -Recurse -Force
    }
    
    # Disables app launch tracking
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) App Launch Tracking..."
    Set-ItemPropertyVerified -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Name "DisableMFUTracking" -Value $One -Type DWORD
    
    If ($vari -eq '2') {
        Remove-Item -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Force -ErrorAction SilentlyContinue
    }

    # Sets windows feeback notifciations to never show
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Windows Feedback Notifications..."
    Set-ItemPropertyVerified -Path:HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name "DoNotShowFeedbackNotifications" -Type DWORD -Value $One

    # Disables location tracking
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Location Tracking..."
    Set-ItemPropertyVerified -Path "$regcam" -Name "Value" -Type String -Value "Deny"
    Set-ItemPropertyVerified -Path "$PathToLFSVC" -Name "Status" -Type DWORD -Value $Zero

    # Disables map updates (Windows Maps is removed)
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Automatic Map Updates..."
    Set-ItemPropertyVerified -Path:HKLM:\SYSTEM\Maps -Name "AutoUpdateEnabled" -Type DWORD -Value $Zero

    # AutoConnect to Hotspots disabled
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) AutoConnect to Sense Hotspots..."
    Set-ItemPropertyVerified -Path $PathToWifiSense\AllowAutoConnectToWiFiSenseHotspots -Name "Value" -Type DWORD -Value $Zero

    # Disables reporting hotspots to microsoft
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Hotspot Reporting to Microsoft..."
    Set-ItemPropertyVerified -Path $PathToWifiSense\AllowWiFiHotSpotReporting -Name "Value" -Type DWORD -Value $Zero

    # Disables cloud content from search (OneDrive, Office, Dropbox, ect.)
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Cloud Content from Windows Search..."
    Set-ItemPropertyVerified -Path $PathToLMPoliciesCloudContent -Name "DisableWindowsConsumerFeatures" -Type DWORD -Value $One

    # Disables tailored experience w users diagnostic data.
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Tailored Experience w/ Diagnostic Data..."
    Set-ItemPropertyVerified -Path $PathToPrivacy -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value $Zero -Type DWORD

    # Disables HomeGroup
    Write-Status -Types $EnableStatus[1].Symbol,"$TweakType" -Status "Stopping and disabling Home Groups services.. LOL"
    If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)) { } else {
        Use-Command 'Stop-Service "HomeGroupListener" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue'
        Use-Command 'Set-Service "HomeGroupListener" -StartupType Disabled -ErrorAction SilentlyContinue'
    }
    If (!(Get-Service -Name HomeGroupListener -ErrorAction SilentlyContinue)) { } else {
        Use-Command 'Stop-Service "HomeGroupProvider" -WarningAction SilentlyContinue -ErrorAction SilentlyContinue'
        Use-Command 'Set-Service "HomeGroupProvider" -StartupType Disabled -ErrorAction SilentlyContinue'
    }

    # Disables SysMain
    If ((Get-Service -Name SysMain -ErrorAction SilentlyContinue).Status -eq 'Stopped') { } else {
        Write-Host ' Stopping and disabling Superfetch service'
        Use-Command 'Stop-Service "SysMain" -WarningAction SilentlyContinue'
        Use-Command 'Set-Service "SysMain" -StartupType Disabled'
    }
    
    # Disables volume lowering during calls
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Volume Adjustment During Calls..."
    Set-ItemPropertyVerified -Path:HKCU:\Software\Microsoft\MultiMedia\Audio -Name "UserDuckingPreference" -Value 3 -Type DWORD

    # Groups SVChost processes
    $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
    Write-Status -Types $EnableStatus[1].Symbol,"$TweakType" -Status "Grouping svchost.exe Processes"
    Set-ItemPropertyVerified -Path:HKLM:\SYSTEM\CurrentControlSet\Control -Name "SvcHostSplitThresholdInKB" -Type DWORD -Value $ram

    # Stack size increased for greater performance
    Write-Status -Types $EnableStatus[1].Symbol,"$TweakType" -Status "Increasing Stack Size to 30"
    Set-ItemPropertyVerified -Path:HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Name "IRPStackSize" -Type DWORD -Value 30

    # Sets DNS settings to Google with CloudFlare as backup
    If (Get-Command Set-DnsClientDohServerAddress -ErrorAction SilentlyContinue){
        ## Imported text from  win10-debloat-tools on github
        # Adapted from: https://techcommunity.microsoft.com/t5/networking-blog/windows-insiders-gain-new-dns-over-https-controls/ba-p/2494644
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting up the DNS over HTTPS for Google and Cloudflare (ipv4 and ipv6)..."
        Use-Command 'Set-DnsClientDohServerAddress -ServerAddress ("8.8.8.8", "8.8.4.4", "2001:4860:4860::8888", "2001:4860:4860::8844") -AutoUpgrade $true -AllowFallbackToUdp $true'
        Use-Command 'Set-DnsClientDohServerAddress -ServerAddress ("1.1.1.1", "1.0.0.1", "2606:4700:4700::1111", "2606:4700:4700::1001") -AutoUpgrade $true -AllowFallbackToUdp $true'
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting up the DNS from Cloudflare and Google (ipv4 and ipv6)..."
        #Get-DnsClientServerAddress # To look up the current config.           # Cloudflare, Google,         Cloudflare,              Google
        Use-Command 'Set-DNSClientServerAddress -InterfaceAlias "Ethernet*" -ServerAddresses ("1.1.1.1", "8.8.8.8", "2606:4700:4700::1111", "2001:4860:4860::8888")'
        Use-Command 'Set-DNSClientServerAddress -InterfaceAlias    "Wi-Fi*" -ServerAddresses ("1.1.1.1", "8.8.8.8", "2606:4700:4700::1111", "2001:4860:4860::8888")'
    } else {
        Write-Status -Types "?", $TweakType -Status "Failed to set up DNS - DNSClient is not Installed..." -WriteWarning
    }

    # Enables Legacy Windows F8 Boot select menu
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Bringing back F8 alternative Boot Modes..."
    bcdedit /set `{current`} bootmenupolicy Legacy

    Write-Section -Text "Ease of Access"
    Write-Caption -Text "Keyboard"
    # Disables Sticky Keys
    Write-Status -Types "-", $TweakType -Status "$($EnableStatus[0].Status) Sticky Keys..."
    Set-ItemPropertyVerified -Path "$PathToCUAccessibility\StickyKeys" -Name "Flags" -Value "506" -Type STRING
    Set-ItemPropertyVerified -Path "$PathToCUAccessibility\Keyboard Response" -Name "Flags" -Value "122" -Type STRING
    Set-ItemPropertyVerified -Path "$PathToCUAccessibility\ToggleKeys" -Name "Flags" -Value "58" -Type STRING

    If ($Revert) {
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name AllowTelemetry -Force -EA SilentlyContinue
        Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name AllowTelemetry -Force -EA SilentlyContinue
        Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Force -EA SilentlyContinue
        Remove-ItemProperty -Path $PathToRegInputPersonalization -Name "RestrictImplicitTextCollection" -Force -EA SilentlyContinue
        Remove-ItemProperty -Path $PathToRegInputPersonalization -Name "RestrictImplicitInkCollection" -Force -EA SilentlyContinue
        Set-Service "DiagTrack" -StartupType Automatic -EA SilentlyContinue
        Set-Service "dmwappushservice" -StartupType Automatic -EA SilentlyContinue
        Set-Service "SysMain" -StartupType Automatic -EA SilentlyContinue
    }

    Write-Section -Text "Privacy -> Apps Permissions"
    #Write-Caption -Text "Location"
    #Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"
    #Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"
    #Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Type DWord -Value $Zero
    #Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "EnableStatus" -Type DWord -Value $Zero

    Write-Caption -Text "Notifications"
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener" -Name "Value" -Value "Deny" -Type String

    Write-Caption -Text "App Diagnostics"
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" -Name "Value" -Value "Deny" -Type String
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" -Name "Value" -Value "Deny" -Type String

    Write-Caption -Text "Account Info Access"
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" -Name "Value" -Value "Deny" -Type String
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" -Name "Value" -Value "Deny" -Type String

    Write-Caption -Text "Voice Activation"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Voice Activation"
    Set-ItemPropertyVerified -Path $PathToVoiceActivation -Name "AgentActivationEnabled" -Value $Zero -Type DWord

    Write-Caption -Text "Background Apps"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Background Apps"
    Set-ItemPropertyVerified -Path $PathToBackgroundAppAccess -Name "GlobalUserDisabled" -Value $One -Type DWord
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Background Apps Global"
    Set-ItemPropertyVerified -Path $PathToCUSearch -Name "BackgroundAppGlobalToggle" -Value $Zero -Type DWord

    Write-Caption -Text "Other Devices"
    Write-Status -Types "-", $TweakType -Status "Denying device access..."
    # Disable sharing information with unpaired devices
    Set-ItemPropertyVerified -Path "$PathToCUDeviceAccessGlobal\LooselyCoupled" -Name "Value" -Value "Deny" -Type String
    ForEach ($key in (Get-ChildItem "$PathToCUDeviceAccessGlobal")) {
        If ($key.PSChildName -EQ "LooselyCoupled") { continue }
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Setting $($key.PSChildName) value to 'Deny' ..."
        Set-ItemPropertyVerified -Path ("$PathToCUDeviceAccessGlobal\" + $key.PSChildName) -Name "Value" -Value "Deny"
    }

    Write-Caption -Text "Background Apps"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Background Apps..."
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Type DWord -Value 0
    Set-ItemPropertyVerified -Path "$PathToCUSearch" -Name "BackgroundAppGlobalToggle" -Type DWord -Value 1

    Write-Caption -Text "Troubleshooting"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Automatic Recommended Troubleshooting, then notify me..."
    Set-ItemPropertyVerified -Path "$PathToLMWindowsTroubleshoot" -Name "UserPreference" -Type DWord -Value 3

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Windows Spotlight Features..."
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Third Party Suggestions..."
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) More Telemetry Features..."

    $CloudContentDisableOnOne = @(
        "DisableWindowsSpotlightFeatures"
        "DisableWindowsSpotlightOnActionCenter"
        "DisableWindowsSpotlightOnSettings"
        "DisableWindowsSpotlightWindowsWelcomeExperience"
        "DisableTailoredExperiencesWithDiagnosticData"      # Tailored Experiences
        "DisableThirdPartySuggestions"
    )

    Write-Status -Types "?", $TweakType -Status "From Path: [$PathToCUPoliciesCloudContent]." -WriteWarning
    ForEach ($Name in $CloudContentDisableOnOne) {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $One"
        Set-ItemPropertyVerified -Path "$PathToCUPoliciesCloudContent" -Name "$Name" -Type DWord -Value $One -ErrorAction SilentlyContinue
    }
    Set-ItemPropertyVerified -Path "$PathToCUPoliciesCloudContent" -Name "ConfigureWindowsSpotlight" -Type DWord -Value 2
    Set-ItemPropertyVerified -Path "$PathToCUPoliciesCloudContent" -Name "IncludeEnterpriseSpotlight" -Type DWord -Value $Zero

    # Disabling app suggestions
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Apps Suggestions..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesCloudContent" -Name "DisableThirdPartySuggestions" -Type DWord -Value $One
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesCloudContent" -Name "DisableWindowsConsumerFeatures" -Type DWord -Value $One


    # Reference: https://forums.guru3d.com/threads/windows-10-registry-tweak-for-disabling-drivers-auto-update-controversy.418033/
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) automatic driver updates..."
    # [@] (0 = Yes, do this automatically, 1 = No, let me choose what to do, Always install the best, 2 = [...] Install driver software from Windows Update, 3 = [...] Never install driver software from Windows Update
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -Type DWord -Value $One
    # [@] (0 = Enhanced icons enabled, 1 = Enhanced icons disabled)
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -Name "SearchOrderConfig" -Type DWord -Value $Zero

    ## Performance Tweaks and More Telemetry
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Type DWord -Value 1
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -Type DWord -Value 5000
    Remove-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -ErrorAction SilentlyContinue
    # Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -Type DWord -Value 4000 # Note: This caused flickering
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name "AutoEndTasks" -Type DWord -Value 1
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name "LowLevelHooksTimeout" -Type DWord -Value 1000
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Mouse" -Name "MouseHoverTime" -Type DWord -Value 10

    # Network Tweaks
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "IRPStackSize" -Type DWord -Value 20

    # Gaming Tweaks
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Type DWord -Value 8
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Type DWord -Value 6
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -Type String -Value "High"

    Set-ItemPropertyVerified -Path "$PathToLMPoliciesSQMClient" -Name "CEIPEnable" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "AITEnable" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "DisableUAR" -Type DWord -Value $One

    # Details: https://docs.microsoft.com/pt-br/windows-server/remote/remote-desktop-services/rds-vdi-recommendations-2004#windows-system-startup-event-traces-autologgers
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) some startup event traces (AutoLoggers)..."
    Set-ItemPropertyVerified -Path "$PathToLMAutoLogger\AutoLogger-Diagtrack-Listener" -Name "Start" -Type DWord -Value $Zero
    Set-ItemPropertyVerified -Path "$PathToLMAutoLogger\SQMLogger" -Name "Start" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'WiFi Sense: HotSpot Sharing'..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesToWifi\AllowWiFiHotSpotReporting" -Name "value" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'WiFi Sense: Shared HotSpot Auto-Connect'..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesToWifi\AllowAutoConnectToWiFiSenseHotspots" -Name "value" -Type DWord -Value $Zero

    Write-Caption "Deleting useless registry keys..."
    $KeysToDelete = @(
        # Remove Background Tasks
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
        # Windows File
        "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        # Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
        # Scheduled Tasks to delete
        "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        # Windows Protocol Keys
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
        # Windows Share Target
        "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    )

    ForEach ($Key in $KeysToDelete) {
        If ((Test-Path $Key)) {
            Write-Status -Types "-", $TweakType -Status "Removing Key: [$Key]"
            Remove-Item $Key -Recurse
        }
    }
}
Function Optimize-Services{
    #$IsSystemDriveSSD = $(Get-OSDriveType) -eq "SSD"
    #$EnableServicesOnSSD = @("SysMain", "WSearch",  "fhsvc")
    # Services which will be totally disabled
    $ServicesToDisabled = @(
        "DiagTrack"                                 # DEFAULT: Automatic | Connected User Experiences and Telemetry
        "diagnosticshub.standardcollector.service"  # DEFAULT: Manual    | Microsoft (R) Diagnostics Hub Standard Collector Service
        "dmwappushservice"                          # DEFAULT: Manual    | Device Management Wireless Application Protocol (WAP)
        #"BthAvctpSvc"                               # DEFAULT: Manual    | AVCTP Service - This is Audio Video Control Transport Protocol service
        #"Fax"                                       # DEFAULT: Manual    | Fax Service
        #"fhsvc"                                     # DEFAULT: Manual    | File History Service
        "GraphicsPerfSvc"                           # DEFAULT: Manual    | Graphics performance monitor service
        "HomeGroupListener"                         # NOT FOUND (Win 10+)| HomeGroup Listener
        "HomeGroupProvider"                         # NOT FOUND (Win 10+)| HomeGroup Provider
        "lfsvc"                                     # DEFAULT: Manual    | Geolocation Service
        "MapsBroker"                                # DEFAULT: Automatic | Downloaded Maps Manager
        "PcaSvc"                                    # DEFAULT: Automatic | Program Compatibility Assistant (PCA)
        "RemoteAccess"                              # DEFAULT: Disabled  | Routing and Remote Access
        "RemoteRegistry"                            # DEFAULT: Disabled  | Remote Registry
        "RetailDemo"                                # DEFAULT: Manual    | The Retail Demo Service controls device activity while the device is in retail demo mode.
        #"SysMain"                                   # DEFAULT: Automatic | SysMain / Superfetch (100% Disk usage on HDDs)
        # read://https_helpdeskgeek.com/?url=https%3A%2F%2Fhelpdeskgeek.com%2Fhelp-desk%2Fdelete-disable-windows-prefetch%2F%23%3A~%3Atext%3DShould%2520You%2520Kill%2520Superfetch%2520(Sysmain)%3F
        "TrkWks"                                    # DEFAULT: Automatic | Distributed Link Tracking Client
        #"WSearch"                                   # DEFAULT: Automatic | Windows Search (100% Disk usage on HDDs)
        # - Services which cannot be disabled (and shouldn't)
        #"wscsvc"                                   # DEFAULT: Automatic | Windows Security Center Service
        #"WdNisSvc"                                 # DEFAULT: Manual    | Windows Defender Network Inspection Service
        "NPSMSvc_df772"
        "LanmanServer"
    )
    # Making the services to run only when needed as 'Manual' | Remove the # to set to Manual
    $ServicesToManual = @(
        "BITS"                           # DEFAULT: Manual    | Background Intelligent Transfer Service
        "BDESVC"                         # DEFAULT: Manual    | BItLocker Drive Encryption Service
        #"cbdhsvc_*"                      # DEFAULT: Manual    | Clipboard User Service
        "edgeupdate"                     # DEFAULT: Automatic | Microsoft Edge Update Service
        "edgeupdatem"                    # DEFAULT: Manual    | Microsoft Edge Update Service²
        "FontCache"                      # DEFAULT: Automatic | Windows Font Cache
        "iphlpsvc"                       # DEFAULT: Automatic | IP Helper Service (IPv6 (6to4, ISATAP, Port Proxy and Teredo) and IP-HTTPS)
        "lmhosts"                        # DEFAULT: Manual    | TCP/IP NetBIOS Helper
        "ndu"                            # DEFAULT: Automatic | Windows Network Data Usage Monitoring Driver (Shows network usage per-process on Task Manager)
        #"NetTcpPortSharing"             # DEFAULT: Disabled  | Net.Tcp Port Sharing Service
        "PhoneSvc"                       # DEFAULT: Manual    | Phone Service (Manages the telephony state on the device)
        "SCardSvr"                       # DEFAULT: Manual    | Smart Card Service
        "SharedAccess"                   # DEFAULT: Manual    | Internet Connection Sharing (ICS)
        "stisvc"                         # DEFAULT: Automatic | Windows Image Acquisition (WIA) Service
        "WbioSrvc"                       # DEFAULT: Manual    | Windows Biometric Service (required for Fingerprint reader / Facial detection)
        "Wecsvc"                         # DEFAULT: Manual    | Windows Event Collector Service
        "WerSvc"                         # DEFAULT: Manual    | Windows Error Reporting Service
        "wisvc"                          # DEFAULT: Manual    | Windows Insider Program Service
        "WMPNetworkSvc"                  # DEFAULT: Manual    | Windows Media Player Network Sharing Service
        "WpnService"                     # DEFAULT: Automatic | Windows Push Notification Services (WNS)
        # - Diagnostic Services
        "DPS"                            # DEFAULT: Automatic | Diagnostic Policy Service
        "WdiServiceHost"                 # DEFAULT: Manual    | Diagnostic Service Host
        "WdiSystemHost"                  # DEFAULT: Manual    | Diagnostic System Host
        # - Bluetooth services
        "BTAGService"                    # DEFAULT: Manual    | Bluetooth Audio Gateway Service
        "BthAvctpSvc"                    # DEFAULT: Manual    | AVCTP Service
        "bthserv"                        # DEFAULT: Manual    | Bluetooth Support Service
        "RtkBtManServ"                   # DEFAULT: Automatic | Realtek Bluetooth Device Manager Service
        # - Xbox services
        "XblAuthManager"                 # DEFAULT: Manual    | Xbox Live Auth Manager
        "XblGameSave"                    # DEFAULT: Manual    | Xbox Live Game Save
        "XboxGipSvc"                     # DEFAULT: Manual    | Xbox Accessory Management Service
        "XboxNetApiSvc"                  # DEFAULT: Manual    | Xbox Live Networking Service
        # - Printer services
        #"PrintNotify"                   # DEFAULT: Manual    | WARNING! REMOVING WILL TURN PRINTING LESS MANAGEABLE | Printer Extensions and Notifications
        #"Spooler"                       # DEFAULT: Automatic | WARNING! REMOVING WILL DISABLE PRINTING              | Print Spooler
        # - Wi-Fi services
        #"WlanSvc"                       # DEFAULT: Manual (No Wi-Fi devices) / Automatic (Wi-Fi devices) | WARNING! REMOVING WILL DISABLE WI-FI | WLAN AutoConfig
        # - 3rd Party Services
        "gupdate"                        # DEFAULT: Automatic | Google Update Service
        "gupdatem"                       # DEFAULT: Manual    | Google Update Service²
        "DisplayEnhancementService"      # DEFAULT: Manual    | A service for managing display enhancement such as brightness control.
        "DispBrokerDesktopSvc"           # DEFAULT: Automatic | Manages the connection and configuration of local and remote displays
    )
    Write-Title "Services tweaks"
    Write-Section "Disabling services from Windows"
    If ($Revert) {
        Write-Status -Types "*", "Services" -Status "Reverting the tweaks is set to '$Revert'."
        Set-ServiceStartup -State 'Manual' -Services $ServicesToDisabled -Filter $EnableServicesOnSSD
    } Else {
        Set-ServiceStartup -State 'Disabled' -Services $ServicesToDisabled -Filter $EnableServicesOnSSD
    }
    #Write-Section "Enabling services from Windows"
    #If ($IsSystemDriveSSD -or $Revert) {
        #Set-ServiceStartup -State 'Automatic' -Services $EnableServicesOnSSD
    #}
    Set-ServiceStartup -State 'Manual' -Services $ServicesToManual
}
Function Optimize-Security {

    $TweakType = "Security"
    # Initialize all Path variables used to Registry Tweaks
    $PathToLMPoliciesEdge = "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge"
    $PathToLMPoliciesMRT = "HKLM:\SOFTWARE\Policies\Microsoft\MRT"
    $PathToCUExplorer = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
    $PathToCUExplorerAdvanced = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

    Write-Title "Security Tweaks"

    Write-Section "Security Patch"
    Write-Status -Types "+", $TweakType -Status "Applying Security Vulnerability Patch CVE-2023-36884 - Office and Windows HTML Remote Code Execution Vulnerability"
    $SecurityPath = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BLOCK_CROSS_PROTOCOL_FILE_NAVIGATION"
    Set-ItemPropertyVerified -Path $SecurityPath -Name "Excel.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "Graph.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "MSAccess.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "MSPub.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "Powerpnt.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "Visio.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "WinProj.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "WinWord.exe" -Type DWORD -Value 1
    Set-ItemPropertyVerified -Path $SecurityPath -Name "Wordpad.exe" -Type DWORD -Value 1

    Write-Section "Windows Firewall"
    Write-Status -Types "+", $TweakType -Status "Enabling default firewall profiles..."
    Use-Command 'Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True'

    Write-Section "Windows Defender"
    Write-Status -Types "?", $TweakType -Status "If you already use another antivirus, nothing will happen." -WriteWarning
    Write-Status -Types "+", $TweakType -Status "Ensuring your Windows Defender is ENABLED..."
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type DWORD -Value 0
    Use-Command 'Set-MpPreference -DisableRealtimeMonitoring $false -Force'

    Write-Status -Types "+", $TweakType -Status "Enabling Microsoft Defender Exploit Guard network protection..."
    Use-Command 'Set-MpPreference -EnableNetworkProtection Enabled -Force'

    Write-Status -Types "+", $TweakType -Status "Enabling detection for potentially unwanted applications and block them..."
    Use-Command 'Set-MpPreference -PUAProtection Enabled -Force'

    Write-Section "SmartScreen"
    Write-Status -Types "+", $TweakType -Status "Enabling 'SmartScreen' for Microsoft Edge..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesEdge\PhishingFilter" -Name "EnabledV9" -Type DWord -Value 1

    Write-Status -Types "+", $TweakType -Status "Enabling 'SmartScreen' for Store Apps..."
    Set-ItemPropertyVerified -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Type DWord -Value 1

    Write-Section "Old SMB Protocol"
    Write-Status -Types "+", $TweakType -Status "Disabling SMB 1.0 protocol..."
    Use-Command 'Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force'

    Write-Section "Old .NET cryptography"
    Write-Status -Types "+", $TweakType -Status "Enabling .NET strong cryptography..."
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319" -Name "SchUseStrongCrypto" -Type DWord -Value 1

    Write-Section "Autoplay and Autorun (Removable Devices)"
    Write-Status -Types "-", $TweakType -Status "Disabling Autoplay..."
    Set-ItemPropertyVerified -Path "$PathToCUExplorer\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value 1

    Write-Status -Types "-", $TweakType -Status "Disabling Autorun for all Drives..."
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoDriveTypeAutoRun" -Type DWord -Value 255

    Write-Section "Windows Explorer"
    Write-Status -Types "+", $TweakType -Status "Enabling Show file extensions in Explorer..."
    Set-ItemPropertyVerified -Path "$PathToCUExplorerAdvanced" -Name "HideFileExt" -Type DWord -Value 0

    Write-Section "User Account Control (UAC)"
    Write-Status -Types "+", $TweakType -Status "Raising UAC level..."
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 5
    Set-ItemPropertyVerified -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "PromptOnSecureDesktop" -Type DWord -Value 1

    Write-Section "Windows Update"
    Write-Status -Types "+", $TweakType -Status "Enabling offer Malicious Software Removal Tool via Windows Update..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesMRT" -Name "DontOfferThroughWUAU" -Type DWord -Value 0
}
Function Optimize-TaskScheduler {
[CmdletBinding()]
param (
[Switch] $Revert
)
    # Adapted from: https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/rds-vdi-recommendations#task-scheduler
    $DisableScheduledTasks = @(
        "\Microsoft\Office\OfficeTelemetryAgentLogOn"
        "\Microsoft\Office\OfficeTelemetryAgentFallBack"
        "\Microsoft\Office\Office 15 Subscription Heartbeat"
        "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
        "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
        "\Microsoft\Windows\Application Experience\StartupAppTask"
        "\Microsoft\Windows\Autochk\Proxy"
        "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"         # Recommended state for VDI use
        "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"       # Recommended state for VDI use
        "\Microsoft\Windows\Customer Experience Improvement Program\Uploader"
        "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"              # Recommended state for VDI use
        "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
        "\Microsoft\Windows\Location\Notifications"                                       # Recommended state for VDI use
        "\Microsoft\Windows\Location\WindowsActionDialog"                                 # Recommended state for VDI use
        "\Microsoft\Windows\Maps\MapsToastTask"                                           # Recommended state for VDI use
        "\Microsoft\Windows\Maps\MapsUpdateTask"                                          # Recommended state for VDI use
        "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"                # Recommended state for VDI use
        "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"                   # Recommended state for VDI use
        "\Microsoft\Windows\Retail Demo\CleanupOfflineContent"                            # Recommended state for VDI use
        "\Microsoft\Windows\Shell\FamilySafetyMonitor"                                    # Recommended state for VDI use
        "\Microsoft\Windows\Shell\FamilySafetyRefreshTask"                                # Recommended state for VDI use
        "\Microsoft\Windows\Shell\FamilySafetyUpload"
        "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary"                          # Recommended state for VDI use
    )


$EnableScheduledTasks = @(
    "\Microsoft\Windows\Defrag\ScheduledDefrag"                 # Defragments all internal storages connected to your computer
    "\Microsoft\Windows\Maintenance\WinSAT"                     # WinSAT detects incorrect system configurations, that causes performance loss, then sends it via telemetry | Reference (PT-BR): https://youtu.be/wN1I0IPgp6U?t=16
    "\Microsoft\Windows\RecoveryEnvironment\VerifyWinRE"        # Verify the Recovery Environment integrity, it's the Diagnostic tools and Troubleshooting when your PC isn't healthy on BOOT, need this ON.
    "\Microsoft\Windows\Windows Error Reporting\QueueReporting" # Windows Error Reporting event, needed to improve compatibility with your hardware
)

$TweakType = "TaskScheduler"
Write-Title -Text "Task Scheduler tweaks"
Write-Section -Text "Disabling Scheduled Tasks from Windows"

If ($Revert) {
    Write-Status -Types "*", $TweakType -Status "Reverting the tweaks is set to '$Revert'."
    $CustomMessage = { "Resetting the $ScheduledTask task as 'Ready' ..." }
    Set-ScheduledTaskState -Ready -ScheduledTask $DisableScheduledTasks -CustomMessage $CustomMessage
}
Else {
    Set-ScheduledTaskState -Disabled -ScheduledTask $DisableScheduledTasks
}

Write-Section -Text "Enabling Scheduled Tasks from Windows"
Set-ScheduledTaskState -Ready -ScheduledTask $EnableScheduledTasks
}
Function Optimize-WindowsOptionalFeatures{
# Code from: https://github.com/LeDragoX/Win-Debloat-Tools/blob/main/src/scripts/optimize-windows-features.ps1
$DisableFeatures = @(
    #"FaxServicesClientPackage"             # Windows Fax and Scan
    "IIS-*"                                # Internet Information Services
    "Internet-Explorer-Optional-*"         # Internet Explorer
    "LegacyComponents"                     # Legacy Components
    "MediaPlayback"                        # Media Features (Windows Media Player)
    "MicrosoftWindowsPowerShellV2"         # PowerShell 2.0
    "MicrosoftWindowsPowershellV2Root"     # PowerShell 2.0
    #"Printing-PrintToPDFServices-Features" # Microsoft Print to PDF
    "Printing-XPSServices-Features"        # Microsoft XPS Document Writer
    "WorkFolders-Client"                   # Work Folders Client
    )

$EnableFeatures = @(
    "NetFx3"                            # NET Framework 3.5
    "NetFx4-AdvSrvs"                    # NET Framework 4
    "NetFx4Extended-ASPNET45"           # NET Framework 4.x + ASPNET 4.x
    )

    Write-Title -Text "Optional Features Tweaks"
    Write-Section -Text "Uninstall Optional Features from Windows"

    If ($Revert) {
        Write-Status -Types "*", "OptionalFeature" -Status "Reverting the tweaks is set to '$Revert'."
        $CustomMessage = { "Re-Installing the $OptionalFeature optional feature..." }
        Set-OptionalFeatureState -Enabled -OptionalFeatures $DisableFeatures -CustomMessage $CustomMessage
    } Else {
        Set-OptionalFeatureState -Disabled -OptionalFeatures $DisableFeatures
    }

    Write-Section -Text "Install Optional Features from Windows"
    Set-OptionalFeatureState -Enabled -OptionalFeatures $EnableFeatures


    Write-Section -Text "Removing Unnecessary Printers"
    $printers = "Microsoft XPS Document Writer", "Fax", "OneNote"
    foreach ($printer in $printers) {
        try {
            Remove-Printer -Name $printer -ErrorAction Stop
            Write-Status -Types "-", "Printer" -Status "Removed $printer..."
        } catch {
            Write-Status -Types "?", "Printer" -Status "Failed to remove $printer : $_" -WriteWarning
        }
    }
}
Function Optimize-GeneralTweaks{    
param(
    [Switch] $Revert,
    [Int]    $Zero = 0,
    [Int]    $One = 1,
    [Int]    $OneTwo = 1
)

$EnableStatus = @(
    @{ Symbol = "-"; Status = "Disabling"; }
    @{ Symbol = "+"; Status = "Enabling"; }
)

If (($Revert)) {
    Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'."
    $Zero = 1
    $One = 0
    $OneTwo = 2
    $EnableStatus = @(
        @{ Symbol = "<"; Status = "Re-Enabling"; }
        @{ Symbol = "<"; Status = "Re-Disabling"; }
    )
}

#$TweakType = "Registry"
#Write-Host "`n" ; Write-TitleCounter -Counter '8' -MaxLength $MaxLength -Text "Optimization"

$os = Get-CimInstance -ClassName Win32_OperatingSystem
$osVersion = $os.Caption


If ($osVersion -like "*10*") {
    # code for Windows 10
    Write-Section -Text "Applying Windows 10 Specific Reg Keys"

    ## Changes search box to an icon
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "Switching Search Box to an Icon."
    Set-ItemPropertyVerified -Path $PathToRegSearch -Name "SearchboxTaskbarMode" -Value $OneTwo -Type DWord

    ## Removes Cortana from the taskbar
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Cortana Button from Taskbar..."
    Set-ItemPropertyVerified -Path $PathToRegExplorerAdv -Name "ShowCortanaButton" -Value $Zero -Type DWord

    ## Unpins taskview from Windows 10 Taskbar
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Task View from Taskbar..."
    Set-ItemPropertyVerified -Path $PathToRegExplorerAdv -Name "ShowTaskViewButton" -Value $Zero -Type DWord

    ##  Hides 3D Objects from "This PC"
    $PathToHide3DObjects = "$PathToRegExplorerLocalMachine\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
    If (Test-Path -Path $PathToHide3DObjects) {
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status)  3D Objects from This PC.."
        Remove-Item -Path $PathToHide3DObjects -Recurse
    }

    # Expands ribbon in 10 explorer
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Expanded Ribbon in Explorer.."
    Set-ItemPropertyVerified -Path $PathToRegExplorer\Ribbon -Name "MinimizedStateTabletModeOff" -Type DWORD -Value $Zero

    ## Disabling Feeds Open on Hover
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Feeds Open on Hover..."
    Set-ItemPropertyVerified -Path $PathToRegCurrentVersion\Feeds -Name "ShellFeedsTaskbarOpenOnHover" -Value $Zero -Type DWord

    #Disables live feeds in search
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Dynamic Content in Windows Search..."
    Set-ItemPropertyVerified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB" -Name "ShowDynamicContent" -Value $Zero -type DWORD
    Set-ItemPropertyVerified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsDynamicSearchBoxEnabled" -Value $Zero -Type DWORD
}elseif ($osVersion -like "*11*") {
    ## Code for Windows 11
    Write-Section -Text "Applying Windows 11 Specific Reg Keys"
    If ($BuildNumber -GE $22H2) {
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) More Icons in the Start Menu.."
        Set-ItemProperty -Path $PathToRegExplorerAdv -Name Start_Layout -Value $One -Type DWORD -Force
    }

    # Sets explorer to compact mode in 11
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Compact Mode View in Explorer "
    Set-ItemPropertyVerified -Path $PathToRegExplorerAdv -Name UseCompactMode -Value $One -Type DWORD

    # Removes Chats from the taskbar in 11
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Chats from the Taskbar..."
    Set-ItemPropertyVerified -Path $PathToRegExplorerAdv -Name "TaskBarMn" -Value $Zero -Type DWORD

    # Removes Meet Now from the taskbar in 11
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Meet Now from the Taskbar..."
    Set-ItemPropertyVerified -Path $PathToRegCurrentVersion\Policies\Explorer -Name "HideSCAMeetNow" -Type DWORD -Value $One

    <# Adds Most Used Apps to Start Menu in 11
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Most Used Apps to Start Menu"
    Set-ItemPropertyVerified #>
}else {
    # code for other operating systems
    # Check Windows version
    Throw{"Don't know what happened. Closing"}
}

    Write-Section -Text "Explorer Related"

    # Pinning This PC to Quick Access Page in Home (11) & Quick Access (10)
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) This PC to Quick Access..."
    $Folder = (New-Object -ComObject Shell.Application).Namespace(0).ParseName("::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
    $verbs = $Folder.Verbs()
    foreach ($verb in $verbs) {
        if ($verb.Name -eq "Pin to Quick access") {
            $verb.DoIt()
            break
        }
    }

    ### Explorer related
    # Removes recent files in explorer quick menu
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Recents in Explorer..."
    Set-ItemPropertyVerified -Path $PathToRegExplorer -Name "ShowRecent" -Value $Zero -Type DWORD

    # Removes frequent files in explorer quick menu
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Frequent in Explorer..."
    Set-ItemPropertyVerified -Path $PathToRegExplorer -Name "ShowFrequent" -Value $Zero -Type DWORD

    # Removes drives without any media (usb hubs, wifi adapters, sd card readers, ect.)
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Show Drives without Media..."
    Set-ItemPropertyVerified -Path "$PathToRegExplorerAdv" -Name "HideDrivesWithNoMedia" -Type DWord -Value $Zero

    # Launches Explorer to This PC
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting Explorer Launch to This PC.."
    Set-ItemPropertyVerified -Path $PathToRegExplorerAdv -Name "LaunchTo" -Value $One -Type Dword

    # Adds User shortcut to desktop
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) User Files to Desktop..."
    Set-ItemPropertyVerified -Path $PathToRegExplorer\HideDesktopIcons\NewStartPanel -Name $UsersFolder -Value $Zero -Type DWORD

    # Adds This PC shortcut to desktop
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) This PC to Desktop..."
    Set-ItemPropertyVerified -Path $PathToRegExplorer\HideDesktopIcons\NewStartPanel -Name $ThisPC -Value $Zero -Type DWORD

    # Expands details of file operations window
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Expanding File Operation Details by Default.."
    Set-ItemPropertyVerified -Path "$PathToRegExplorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWORD -Value $One


}

Function Remove-InstalledProgram {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [string]$UninstallString,
        [Parameter(ValueFromPipeline=$true)]
        [string]$Name
    )
    process {
        try {
            Write-Host "Uninstalling $Name..."
            if ($UninstallString -match 'msiexec.exe /i') {
                # Uninstall using MSIExec
                $arguments = $UninstallString.Split(" ", 2)[1]
                Start-Process -FilePath 'msiexec.exe' -ArgumentList "$arguments" -Wait -NoNewWindow
            } elseif ($UninstallString -match 'msiexec.exe /x') {
                } else{
                    # Uninstall using regular command
                    Start-Process -FilePath $UninstallString -ArgumentList "/quiet", "/norestart" -Wait -NoNewWindow
                }
            
            Write-Host "$Name uninstalled successfully."
        } catch {
            Write-Host "An error occurred during program uninstallation: $_"
        }
    }
}
Function Remove-Office {
    #$SaRAURL = "https://github.com/circlol/newload/raw/main/SaRACmd_17_0_9246_0.zip" 
    #$SaRAURL = "https://github.com/circlol/newload/raw/main/SaRACmd_17_0_9941_9.zip"
    #$SaRAURL = "https://github.com/circlol/newload/raw/main/SaRACmd_17_01_0040_005.zip"
    $SaRAURL = "https://github.com/circlol/newload/raw/main/SaRACmd_17_1_0268_3.zip"
    $msgBoxInput = Show-YesNoCancelDialog -YesNo -Message "  Microsoft Office was found on this system. Would you like to REMOVE IT?"
    switch ($msgBoxInput) {
        'Yes' {
            Write-Status "+", $TweakType -Status "Downloading Microsoft Support and Recovery Assistant (SaRA)..."
            Get-NetworkStatus
            Start-BitsTransfer -Source:$SaRAURL -Destination:$SaRA -TransferType Download -Dynamic | Out-Host
            Expand-Archive -Path $SaRA -DestinationPath $Sexp -Force
            Check
            $SaRAcmdexe = (Get-ChildItem ".\SaRA\" -Include SaRAcmd.exe -Recurse).FullName
            Write-Status "+", $TweakType -Status "Starting OfficeScrubScenario via Microsoft Support and Recovery Assistant (SaRA)... "
            Start-Process "$SaRAcmdexe" -ArgumentList "-S OfficeScrubScenario -AcceptEula -OfficeVersion All"
        }
        'No' {
            Write-Status -Types "?" -Status "Skipping Office Removal" -WriteWarning
        }
    }
}
Function Remove-StartMenuPins {
    $ClearedStartLayout = @"
    <LayoutModificationTemplate xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification" 
        xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" 
        xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" 
        xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" 
        Version="1">
        <LayoutOptions StartTileGroupCellWidth="6" />
        <DefaultLayoutOverride>
            <StartLayoutCollection>
                <defaultlayout:StartLayout GroupCellWidth="6" />
            </StartLayoutCollection>
        </DefaultLayoutOverride>
"@
    # Outs file to LayoutModification.xml
    If( Test-Path $layoutFile ) { Use-Command "Remove-Item `"$layoutFile`"" -Suppress }
    $ClearedStartLayout | Out-File $layoutFile -Encoding ASCII

    #Locks Start Menu to apply change
    $regAliases = @("HKLM", "HKCU")
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemPropertyVerified -Path "$keyPath" -Name "LockedStartLayout" -Value "1" -Type DWord
    }

    # Initiates the change
    Restart-Explorer 
    Start-Sleep -Seconds 5
    # Opens the start menu
    $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
    Start-Sleep -Seconds 5

    # Unlocks the start menu
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemPropertyVerified -Path "$keyPath" -Name "LockedStartLayout" -Value "0" -Type DWord
    }

    Restart-Explorer
    Use-Command "Remove-Item `"$layoutFile`"" -Suppress
}
Function Remove-UWPAppx() {
    [CmdletBinding()]
    param (
        [Array] $AppxPackages
    )
    $TweakType = "UWP"
    $Global:PackagesRemoved = [System.Collections.ArrayList]::new()
    ForEach ($AppxPackage in $AppxPackages) {
        $appxPackageToRemove = Get-AppxPackage -AllUsers -Name $AppxPackage -ErrorAction SilentlyContinue
        if ($appxPackageToRemove) {
            $appxPackageToRemove | ForEach-Object {
                Write-Status -Types "-", $TweakType -Status "Trying to remove $AppxPackage" -NoNewLine
                Remove-AppxPackage $_.PackageFullName -EA SilentlyContinue -WA SilentlyContinue >$NULL | Out-Null #4>&1 | Out-Null
                If ($?){ Check ; $Global:Removed++ ; $PackagesRemoved += $appxPackageToRemove.PackageFullName  } elseif (!($?)) { Check ; $Global:Failed++ }
            }
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $AppxPackage | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null
            If ($?){ $Global:Removed++ ; $PackagesRemoved += "Provisioned Appx $($appxPackageToRemove.PackageFullName)" } elseif (!($?)) { $Global:Failed++ }
        } else {
            $Global:NotFound++
        }
    }
}

Function Restart-Explorer() {
<#
.SYNOPSIS
    Restarts the Windows Explorer process.

.DESCRIPTION
    The Restart-Explorer function is used to gracefully restart the Windows Explorer process. It first checks if the Explorer process is running and stops it using the taskkill command. After a brief delay, it starts the Explorer process again using the Start-Process cmdlet.

.PARAMETER None
    This function does not accept any parameters.

.NOTES
    The function supports the ShouldProcess feature for confirmation before stopping and starting the Explorer process.

.EXAMPLE
    Restart-Explorer

    DESCRIPTION
        Restarts the Windows Explorer process. It first stops the Explorer process and then starts it again.

#>
    [CmdletBinding(SupportsShouldProcess)]
    Param()
    # Checks is explorer is running
    $ExplorerActive = Get-Process -Name explorer -ErrorAction SilentlyContinue
    if ($ExplorerActive) {
        try {
            if ($PSCmdlet.ShouldProcess("Stop explorer process")) {
                taskkill /f /im explorer.exe
            }
        }
        catch {
            Write-Warning "Failed to stop Explorer process: $_"
            return
        }
        Start-Sleep -Milliseconds 1500
    }
    try {
        if ($PSCmdlet.ShouldProcess("Start explorer process")) {
            Start-Process explorer -ErrorAction Stop
        }
    }
    catch {
        Write-Error "Failed to start Explorer process: $_"
        return
    }
}

Function Request-PCRestart() {
<#
.SYNOPSIS
    Requests the user to confirm if they want to restart the computer and performs the restart operation if confirmed.

.DESCRIPTION
    The Request-PCRestart function displays a Yes/No/Cancel dialog box to the user, asking if they want to reboot the system. The user can choose to restart immediately, restart later, or cancel the restart operation.

.NOTES
    This function depends on the Show-YesNoCancelDialog function, which should be defined or imported separately.

.EXAMPLE
    Request-PCRestart

    DESCRIPTION
        Requests the user to confirm if they want to restart the computer. If the user selects 'Yes,' the system restarts immediately. If the user selects 'No' or 'Cancel,' the restart operation is canceled.

#>
    # - Sends a YesNoCancel dialog to the user   -  User can press Esc using YesNoCancel
    switch (Show-YesNoCancelDialog -YesNoCancel -Message "Would you like to reboot the system now? ") {
        'Yes' {
            Write-Host "You choose to Restart now"
            # - Restarts Computer
            Restart-Computer
        }
        'No' {
            Write-Host "You choose to Restart later"
        }
        'Cancel' {
            Write-Host "You choose to Restart later"
        }
    }
}

Function Set-Branding {
    param(
        [Switch] $Revert
    )

    If (!$Revert){
        # - Adds Mother Computers support info to About.
        Write-Status -Types "+", $TweakType -Status "Adding Mother Computers to Support Page"
        Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "Manufacturer" -Type String -Value "$store" -Verbose
        Write-Status -Types "+", $TweakType -Status "Adding Mothers Number to Support Page"
        Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "SupportPhone" -Type String -Value "$phone" -Verbose
        Write-Status -Types "+", $TweakType -Status "Adding Store Hours to Support Page"
        Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "SupportHours" -Type String -Value "$hours" -Verbose
        Write-Status -Types "+", $TweakType -Status "Adding Store URL to Support Page"
        Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "SupportURL" -Type String -Value "$website" -Verbose
        Write-Status -Types "+", $TweakType -Status "Adding Store Number to Settings Page"
        Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "$page" -Type String -Value "$Model" -Verbose
    } elseif ($Revert){
        # - Removes Mother Computers support info to About.
        Write-Status -Types "-", $TweakType -Status "Removing Mother Computers from Support Page"
        Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "Manufacturer" -Type String -Value "" -Verbose
        Write-Status -Types "-", $TweakType -Status "Removing Mothers Number from Support Page"
        Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "SupportPhone" -Type String -Value "" -Verbose
        Write-Status -Types "-", $TweakType -Status "Removing Store Hours from Support Page"
        Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "SupportHours" -Type String -Value "" -Verbose
        Write-Status -Types "-", $TweakType -Status "Removing Store URL from Support Page"
        Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "SupportURL" -Type String -Value "" -Verbose
        Write-Status -Types "-", $TweakType -Status "Removing Store Number from Settings Page"
        Set-ItemPropertyVerified -Path "$PathToOEMInfo" -Name "$page" -Type String -Value "" -Verbose
    }
}
Function Set-ItemPropertyVerified {
<#
.SYNOPSIS
    Sets a value for a specified property in a Windows registry key, ensuring its existence.

.DESCRIPTION
    The Set-ItemPropertyVerified function is used to set a value for a specified property in a Windows registry key. If the key does not exist, the function will create it. The function allows you to specify the registry path, property name, value, and type. You can use the -WhatIf switch to preview changes without applying them. The function also provides options for forcing the operation and enabling verbose output.

.PARAMETER Value
    Specifies the value to set for the property. This parameter is mandatory and can accept input from the pipeline.

.PARAMETER Name
    Specifies the name of the property to set. This parameter is mandatory.

.PARAMETER Type
    Specifies the data type of the property value. This parameter is mandatory.

.PARAMETER Path
    Specifies the path of the registry key where the property is to be set. This parameter is mandatory.

.PARAMETER Force
    If specified, forces the operation without prompting for confirmation.

.PARAMETER WhatIf
    If specified, shows what changes would occur without actually applying them.

.PARAMETER UseVerbose
    If specified, enables verbose output for the operation.

.PARAMETER Passthru
    If specified, returns the updated registry key object after setting the property.

.OUTPUTS
    This function does not generate any PowerShell objects as output. It uses the Write-Status function to provide status updates during the operation.

.EXAMPLE
    Set-ItemPropertyVerified -Path "HKCU:\Software\MyApp" -Name "Setting1" -Value "Value1" -Type String

    DESCRIPTION
        Sets the value "Value1" with the name "Setting1" in the registry key "HKCU:\Software\MyApp".

.EXAMPLE
    Get-Content "MySettings.txt" | Set-ItemPropertyVerified -Path "HKLM:\Software\MyApp" -Name "Setting2" -Type DWord

    DESCRIPTION
        Reads values from "MySettings.txt" and sets each value with the name "Setting2" as DWORD type in the registry key "HKLM:\Software\MyApp".

.EXAMPLE
    Set-ItemPropertyVerified -Path "HKCU:\Software\MyApp" -Name "Setting3" -Value "NewValue" -Type String -Force

    DESCRIPTION
        Sets the value "NewValue" with the name "Setting3" in the registry key "HKCU:\Software\MyApp", forcing the operation without confirmation.

.EXAMPLE
    Set-ItemPropertyVerified -Path "HKLM:\Software\MyApp" -Name "Setting4" -Value "Data1" -Type MultiString -WhatIf

    DESCRIPTION
        Shows what changes would occur if the value "Data1" with the name "Setting4" as MultiString type were set in the registry key "HKLM:\Software\MyApp", without actually applying the changes.

#>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $Value,
        [Parameter(Mandatory = $true)]
        $Name,
        [Parameter(Mandatory = $true)]
        $Type,
        [Parameter(Mandatory = $true)]
        $Path,
        [Parameter(Mandatory = $False)]
        [Switch]$Force,        
        [Parameter(Mandatory = $False)]
        [Switch]$WhatIf,
        [Parameter(Mandatory = $False)]
        [Switch]$UseVerbose,
        [Parameter(Mandatory = $False)]
        [Switch]$Passthru
    )

    $keyExists = Test-Path -Path $Path
    If ($WhatIf){
        if (!$keyExists) {
            Write-Status -Types "+", "Path Not Found" -Status "Creating key at $Path"
            New-Item -Path $Path -Force -WhatIf | Out-Null
        }    
    }else{
        if (!$keyExists) {
            Write-Status -Types "+", "Path Not Found" -Status "Creating key at $Path"
            New-Item -Path $Path -Force | Out-Null
        }
    }

    $currentValue = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
    if ($null -eq $currentValue -or $currentValue.$Name -ne $Value) {
        Try {
            Write-Status -Types "+" -Status "$Name set to $Value in $Path" -NoNewLine
            $warningPreference = Get-Variable -Name WarningPreference -ValueOnly -ErrorAction SilentlyContinue
            If ($WhatIf){
                If (!$Force) {
                    Set-ItemProperty -Path "$Path" -Name "$Name" -Value "$Value" -Type "$Type" -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru -Verbose:$UseVerbose -WhatIf
                    If ($? -eq $True){ Check ; $ModifiedRegistryKeys ++} else {Check}
                    
                }
                else {
                    Set-ItemProperty -Path "$Path" -Name "$Name" -Value "$Value" -Type "$Type" -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru -Force -Verbose:$UseVerbose -WhatIf
                    If ($? -eq $True){ Check ; $ModifiedRegistryKeys ++} else {Check}
                }
            }Else{
                If (!$Force) {
                    Set-ItemProperty -Path "$Path" -Name "$Name" -Value "$Value" -Type "$Type" -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru -Verbose:$UseVerbose
                    If ($? -eq $True){ Check ; $ModifiedRegistryKeys ++} else {Check}
                }
                else {
                    Set-ItemProperty -Path "$Path" -Name "$Name" -Value "$Value" -Type "$Type" -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru -Force -Verbose:$UseVerbose
                    If ($? -eq $True){ Check ; $ModifiedRegistryKeys ++} else {Check}
                }
            }
        }
        catch {
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
    else {
        Write-Status -Types "@" -Status "Key already set to desired value. Skipping"
    }
}
function Set-OptionalFeatureState {
<#
.SYNOPSIS
    Enables or disables Windows optional features on the host.

.DESCRIPTION
    The Set-OptionalFeatureState function is used to enable or disable Windows optional features on the host machine. It allows you to specify the features to be enabled or disabled using an array of feature names. You can also set a filter to skip certain features, provide a custom message for each feature, and use the `-WhatIf` switch to preview changes without applying them.

.PARAMETER Disabled
    Indicates that the specified optional features should be disabled. If this switch is present, the function will attempt to uninstall the specified features.

.PARAMETER Enabled
    Indicates that the specified optional features should be enabled. If this switch is present, the function will attempt to install the specified features.

.PARAMETER OptionalFeatures
    Specifies an array of names of the optional features that need to be enabled or disabled. This parameter is mandatory.

.PARAMETER Filter
    Specifies an array of feature names to skip. If a feature name matches any of the names in the filter, it will be skipped. This parameter is optional.

.PARAMETER CustomMessage
    Allows providing a custom message for each feature. If provided, the custom message will be displayed instead of the default messages.

.PARAMETER WhatIf
    If this switch is provided, the function will only preview the changes without actually enabling or disabling the features.

.EXAMPLE
    Set-OptionalFeatureState -Enabled -OptionalFeatures "Microsoft-Windows-Subsystem-Linux", "Telnet-Client"

    DESCRIPTION
        Enables the "Microsoft-Windows-Subsystem-Linux" and "Telnet-Client" optional features on the host.

.EXAMPLE
    Set-OptionalFeatureState -Disabled -OptionalFeatures "Internet-Explorer-Optional-amd64" -Filter "Telnet-Client"

    DESCRIPTION
        Disables the "Internet-Explorer-Optional-amd64" optional feature on the host. If the feature name matches the filter ("Telnet-Client"), it will be skipped.

.EXAMPLE
    Set-OptionalFeatureState -Enabled -OptionalFeatures "Media-Features", "XPS-Viewer" -CustomMessage { "Enabling feature: $_" }

    DESCRIPTION
        Enables the "Media-Features" and "XPS-Viewer" optional features on the host, displaying the custom message for each feature.

.EXAMPLE
    Set-OptionalFeatureState -Enabled -OptionalFeatures "LegacyComponents" -WhatIf

    DESCRIPTION
        Previews the changes of enabling the "LegacyComponents" optional feature without applying the changes.
#>
    [CmdletBinding()]
    param (
        [Switch] $Disabled,
        [Switch] $Enabled,
        [Parameter(Mandatory = $true)]
        [Array] $OptionalFeatures,
        [Array] $Filter,
        [ScriptBlock] $CustomMessage,
        [Switch] $WhatIf
    )

    $SecurityFilterOnEnable = @("IIS-*")
    $TweakType = "OptionalFeature"

    $OptionalFeatures | ForEach-Object {
        $feature = Get-WindowsOptionalFeature -Online -FeatureName $_ -ErrorAction SilentlyContinue
        if ($feature) {
            if ($_.DisplayName -in $Filter) {
                Write-Status -Types "?", $TweakType -Status "The $_ ($($feature.DisplayName)) will be skipped as set on Filter..."
                return
            }

            if (($_.DisplayName -in $SecurityFilterOnEnable) -and $Enabled) {
                Write-Status -Types "?", $TweakType -Status "Skipping $_ ($($feature.DisplayName)) to avoid a security vulnerability..."
                return
            }

            if (!$CustomMessage) {
                if ($Disabled) {
                    Write-Status -Types "-", $TweakType -Status "Uninstalling the $_ ($($feature.DisplayName)) optional feature..."
                } elseif ($Enabled) {
                    Write-Status -Types "+", $TweakType -Status "Installing the $_ ($($feature.DisplayName)) optional feature..."
                } else {
                    Write-Status -Types "?", $TweakType -Status "No parameter received (valid params: -Disabled or -Enabled)"
                }
            } else {
                Write-Status -Types "@", $TweakType -Status (& $CustomMessage)
            }

            Try {
                If ($WhatIf) {
                    if ($Disabled) {
                        $feature | Where-Object State -Like "Enabled" | Disable-WindowsOptionalFeature -Online -NoRestart -WhatIf
                    } elseif ($Enabled) {
                        $feature | Where-Object State -Like "Disabled*" | Enable-WindowsOptionalFeature -Online -NoRestart -WhatIf
                    }
                } else {
                    if ($Disabled) {
                        $feature | Where-Object State -Like "Enabled" | Disable-WindowsOptionalFeature -Online -NoRestart
                    } elseif ($Enabled) {
                        $feature | Where-Object State -Like "Disabled*" | Enable-WindowsOptionalFeature -Online -NoRestart
                    }
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
        } else {
            Write-Status -Types "?", $TweakType -Status "The $_ optional feature was not found." -WriteWarning
        }
    }
}
function Set-ScheduledTaskState() {
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
Function Set-ScriptStatus() {
<#
.SYNOPSIS
Sets the script status and performs various actions based on the provided parameters.

.DESCRIPTION
The Set-ScriptStatus function is used to set the status of a script and perform specific actions based on the provided parameters. It is apart of New Loads by Circlol and uses custom commands such as Write-Section, Write-TitleCounter, sets a tweak type variable, change the window title, and create a checkpoint by saving the state to the registry.

.PARAMETER AddCounter
Specifies whether to increment the script counter. If this switch is provided, the function will increment the $Counter variable by 1.

.PARAMETER Section
Indicates whether to display a section text. If this parameter is set to $true, the function will use the SectionText parameter to display the section information.

.PARAMETER SectionText
The text to be displayed when the -Section switch is used. This parameter is used to indicate the current section or phase of the script.

.PARAMETER Title
Specifies whether to display a title text with the counter. If this parameter is set to $true, the function will use the TitleText parameter to display the title information along with the current counter value.

.PARAMETER TitleText
The text to be displayed as the title when the -Title switch is used. This parameter is used to provide a descriptive title for the current phase or action of the script.

.PARAMETER TweakType
Sets the value of the $TweakType variable to the specified value. This parameter allows customization of the script behavior based on different tweak types.

.PARAMETER WindowTitle
Changes the window title of the current PowerShell host to include the provided text. This parameter can be used to give the script's PowerShell window a more descriptive title.

.PARAMETER SaveState
Creates a checkpoint for the specified state by saving it to the registry under HKCU:\Software\New Loads\SaveState. This parameter is used to store the state of the script for future reference or recovery.

.EXAMPLE
Set-ScriptStatus -AddCounter -Section -SectionText "Processing Phase" -Title -TitleText "Processing Items" -TweakType "Fast" -WindowTitle "Script Execution"

DESCRIPTION
    Sets the script status by incrementing the counter, displaying the section "Processing Phase," showing the title "Processing Items (1/2)", setting the $TweakType to "Fast", and changing the window title to "New Loads - Script Execution".
.LINK
https://github.com/circlol/newloadsTesting/blob/main/lib/Set-ScriptStatus.psm1

.EXAMPLE
Set-ScriptStatus -SaveState "InitialSetup"

DESCRIPTION
    Sets the script status by creating a checkpoint for the state "InitialSetup" and saving it to the registry.
#>
    param(
        [Switch]$AddCounter,
        [Boolean]$Section,
        [String]$SectionText,
        [Boolean]$Title,
        [String]$TitleText,
        [String]$TweakType,
        [String]$WindowTitle,
        [String]$SaveState
    )
    If ($AddCounter){
        $Counter++
    }
    If ($SaveState){
        Write-Status "+","SaveState" -Status "-> Creating checkpoint for $SaveState"
        Set-ItemPropertyVerified -Path "HKCU:\Software\New Loads" -Name "SaveState" -Value "$SaveState" -Type STRING
    }
    If ($Section -eq $True){
        Write-Section -Text $SectionText
    }
    If ($Title -eq $True){  
        Write-TitleCounter -Counter $Counter -MaxLength $MaxLength -Text $TitleText
    }
    If ($TweakType){
        Set-Variable -Name 'TweakType' -Value $TweakType -Scope Global -Force
    }
    If ($WindowTitle){
        $host.UI.RawUI.WindowTitle = "New Loads - $WindowTitle"
    }
}
function Set-ServiceStartup() {
<#
.SYNOPSIS
    Sets the startup type for specified Windows services.

.DESCRIPTION
    The Set-ServiceStartup function is used to set the startup type for specified Windows services on the host machine. The function allows you to specify the desired startup state using the ValidateSet attribute for the $State parameter. You can provide an array of service names to apply the change to multiple services at once. Additionally, you can set a filter to skip certain services from being modified.

.PARAMETER State
    Specifies the desired startup type for the services. Valid values are 'Automatic', 'Boot', 'Disabled', 'Manual', and 'System'. This parameter is mandatory.

.PARAMETER Services
    Specifies an array of service names for which the startup type should be modified. This parameter is mandatory.

.PARAMETER Filter
    Specifies an array of service names to skip. If a service name matches any of the names in the filter, it will be skipped. This parameter is optional.

.EXAMPLE
    Set-ServiceStartup -State "Automatic" -Services "Spooler", "BITS"

    DESCRIPTION
        Sets the startup type for the "Spooler" and "BITS" services to "Automatic".

.EXAMPLE
    Set-ServiceStartup -State "Disabled" -Services "Telnet", "wuauserv" -Filter "BITS"

    DESCRIPTION
        Sets the startup type for the "Telnet" and "wuauserv" services to "Disabled". The "BITS" service will be skipped due to the filter.

.EXAMPLE
    Set-ServiceStartup -State "Manual" -Services "Dnscache" -WhatIf

    DESCRIPTION
        Previews the changes of setting the "Dnscache" service startup type to "Manual" without actually applying the changes.

#>
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
Function Set-StartMenu () {
    # Kills explorer to apply start menu
    Taskkill /f /im explorer.exe
    $Windows11BuildVersion = "22000"
    If ($SYSTEMOSVERSION -ge $Windows11BuildVersion) 
    {
    # - Applies start menu layout for Windows 11 22H2+
        Write-Section -Text "Applying Start Menu Layout"
        Write-Status -Types "+", $TweakType -Status "Generating Layout File"
        $StartBinFiles = Get-ChildItem -Path ".\assets" -Filter "*.bin" -File
        $TotalBinFiles = $StartBinFiles.Count * 2
        for ($i = 0; $i -lt $StartBinFiles.Count; $i++) {
            $StartBinFile = $StartBinFiles[$i]
            $progress = ($i * 2) + 1
            Write-Status -Types "+", $TweakType -Status "Copying $($StartBinFile.Name) for new users ($progress/$TotalBinFiles)" -NoNewLine
            xcopy $StartBinFile.FullName $StartBinDefault /y
            Check
            Write-Status -Types "+", $TweakType -Status "Copying $($StartBinFile.Name) to current user ($($progress+1)/$TotalBinFiles)" -NoNewLine
            xcopy $StartBinFile.FullName $StartBinCurrent /y
            Check
    }
        # Kills StartMenuExperience to apply layout
        Use-Command "taskkill /f /im StartMenuExperienceHost.exe" -Suppress
    }
    elseif ($SYSTEMOSVERSION -Lt $Windows11BuildVersion)
    {
        # - Clears Windows 10 Start Pinned
        Write-Status -Types "-", $TweakType -Status "Clearing Windows 10 Start Menu Pins"
        Remove-StartMenuPins
    }


    Write-Status -Types "+", $TweakType -Status "Applying Taskbar Layout" -NoNewLine
$startlayout = @"
    <LayoutModificationTemplate xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification" 
        xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" 
        xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" 
        xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" 
        Version="1">
        <LayoutOptions StartTileGroupCellWidth="6" />
        <DefaultLayoutOverride>
            <StartLayoutCollection>
                <defaultlayout:StartLayout GroupCellWidth="6" />
            </StartLayoutCollection>
        </DefaultLayoutOverride>
            <CustomTaskbarLayoutCollection PinListPlacement="Replace">
                <defaultlayout:TaskbarLayout>
                    <taskbar:TaskbarPinList>
                        <taskbar:DesktopApp DesktopApplicationID="Chrome" />
                        <taskbar:DesktopApp DesktopApplicationID="Microsoft.Windows.Explorer" />
                        <taskbar:UWA AppUserModelID="windows.immersivecontrolpanel_cw5n1h2txyewy!Microsoft.Windows.ImmersiveControlPanel" />
                        <taskbar:UWA AppUserModelID="Microsoft.SecHealthUI_8wekyb3d8bbwe!SecHealthUI" />
                        <taskbar:UWA AppUserModelID="Microsoft.Windows.SecHealthUI_cw5n1h2txyewy!SecHealthUI" />
                    </taskbar:TaskbarPinList>
                </defaultlayout:TaskbarLayout>
            </CustomTaskbarLayoutCollection>
    </LayoutModificationTemplate>
"@
    # - Removes and replaces start layout
    If (Test-Path $layoutFile) { Use-Command "Remove-Item `"$layoutFile`"" | Out-Null }
    $StartLayout | Out-File $layoutFile -Encoding ASCII ; Check 

    # Locks Start Menu layout before its reloaded
    $regAliases = @("HKLM", "HKCU")
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemPropertyVerified -Path "$keyPath" -Name "LockedStartLayout" -Value "1" -Type DWord
        #Set-ItemPropertyVerified -Path "$keyPath" -Name "StartLayoutFile" -Value "$layoutFile" -Type ExpandString
    }

    # Initiates the change
    Restart-Explorer
    Start-Sleep -Seconds 5
    $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
    Start-Sleep -Seconds 5

    # Unlocks Start Menu layout after the reload
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemPropertyVerified -Path "$keyPath" -Name "LockedStartLayout" -Value "0" -Type DWord
    }
}
Function Set-Visuals() {
    param(
        [switch]$Revert
    )
    If (!$Revert)
    {
        Write-Status -Types "+", $TweakType -Status "Applying Mother Computers Theme"
        & $ThemeLocation
        Start-Sleep -Milliseconds 3500
        Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value "2" -Type String
        $CheckActiveSettingsApp = Get-Process "SystemSettings"
        If ($CheckActiveSettingsApp){
            taskkill /f /im SystemSettings.exe
        }
    }
    elseif ($Revert)
    {
        Write-Status -Types "+", $TweakType -Status "Reverting to default theme"
        If (Test-Path "C:\Windows\Resources\Themes\aero.theme"){
            Start-Process "C:\Windows\Resources\Themes\aero.theme"
        } else{
            $Theme = Get-ChildItem "C:\Windows\Resources\Themes\*.theme"
            Start-Process $Theme[1]
        }
    }
}

Function Send-EmailLog {
    # - Stops Transcript
    Stop-Transcript
    Write-Section -Text "Gathering Logs "
    Write-Caption -Text "System Statistics"
    # - Current Date and Time
    $CurrentDate = Get-Date
    $EndTime = Get-Date -DisplayHint Time
    $ElapsedTime = $EndTime - $StartTime

    # - Gathers some information about host
    $CPU = Get-CPU
    $GPU = Get-GPU
    $RAM = Get-RAM
    $Drives = Get-DriveInfo
    [String]$SystemSpec = Get-SystemSpec
    $SystemSpec | Out-Null
    $Mobo = (Get-CimInstance -ClassName Win32_BaseBoard).Product
    $IP = $(Resolve-DnsName -Name myip.opendns.com -Server 208.67.222.220).IPAddress
    $Displayversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "DisplayVersion").DisplayVersion
    $WindowsVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
    Get-ComputerInfo | Out-File -Append $log -Encoding ascii


    # - Removes unwanted characters and blank space from log file
    Write-Caption -Text "Cleaning $Log"
    $logFile = Get-Content $Log
    $pattern = "[\[\]><\+@),|=]"
    # - Replace the unwanted characters with nothing
    $newLogFile = $logFile -replace $pattern
    # - Remove empty lines
    $newLogFile = ($newLogFile | Where-Object { $_ -match '\S' }) -join "`n"
    Set-Content -Path $Log -Value $newLogFile

    # - Cleans up Motherboards Output
    Write-Caption -Text "Generating New Loads Summary"
    If ($CurrentWallpaper -eq $Wallpaper) { $WallpaperApplied = "YES" }Else { $WallpaperApplied = "NO" }
    $TempFile = "$Env:Temp\tempmobo.txt" ; $Mobo | Out-File $TempFile -Encoding ASCII
    (Get-Content $TempFile).replace('Product', '') | Set-Content $TempFile
    (Get-Content $TempFile).replace("  ", '') | Set-Content $TempFile
    $Mobo = Get-Content $TempFile
    Remove-Item $TempFile

    # - Checks if all the programs got installed
    $CheckChrome = Get-InstalledProgram -Keyword "Google Chrome"
    If (!$CheckChrome){ $ChromeYN = "NO" } Else { $ChromeYN = "YES" }
    $CheckVLC = Get-InstalledProgram -Keyword "VLC"
    If (!$CheckVLC){ $VLCYN = "NO" } Else { $VLCYN = "YES" }
    $CheckZoom = Get-InstalledProgram -Keyword "Zoom"
    If (!$CheckZoom){ $ZoomYN = "NO" } Else { $ZoomYN = "YES" }
    $CheckAcrobat = Get-InstalledProgram -Keyword "Acrobat"
    If (!$CheckAcrobat){ $AdobeYN = "NO"} Else { $AdobeYN = "YES"}

    # - Joins log files to send as attachments
    $LogFiles = @()
    if (Test-Path -Path ".\Log.txt") {
    $LogFiles += ".\Log.txt"
    }
    if (Test-Path -Path ".\ErrorLog.txt") {
    $LogFiles += ".\ErrorLog.txt"
    }

    # - Cleans packages removed text and adds it to email
    ForEach ($Package in $PackagesRemoved) {
        Write-Host "$Package"
        $PackagesRemovedOutput = "$PackagesRemovedOutput" + "`n - $Package"
    }

    # - Email Settings
    $smtp = 'smtp.shaw.ca'
    $To = '<newloads@shaw.ca>'
    $From = 'New Loads Log <newloadslogs@shaw.ca>'
    $Sub = "New Loads Log"
    $EmailBody = "
    ############################
    #   NEW LOADS SCRIPT LOG   #
    ############################

New Loads was run on a computer for $ip\$env:computername\$env:USERNAME

On this computer for $Env:Username, New Loads completed in $elapsedtime. This system is equipped with a $cpu, $ram, $gpu


- Elapsed Time: $ElapsedTime
    - Start Time: $StartTime
    - End Time: $EndTime


- Script Information:

    - Program Version: $ProgramVersion
    - Script Version: $ScriptVersion
    - Date: $CurrentDate

- Computer Information:
    - OS: $WindowsVersion ($DisplayVersion)
    - CPU: $CPU
    - Motherboard: $Mobo
    - RAM: $RAM
    - GPU: $GPU
    - Drives:
$Drives


- Script Run Information:
    - Applications Installed: $appsyns
    - Chrome: $ChromeYN
    - VLC: $VLCYN
    - Adobe: $AdobeYN
    - Zoom: $ZoomYN
    - Wallpaper Applied: $WallpaperApplied
    - Windows 11 Start Layout Applied: $StartMenuLayout
    - Registry Keys Modified: $ModifiedRegistryKeys
    - Packages Removed During Debloat: $Removed
    $PackagesRemovedOutput
"

    Write-Caption -Text "Sending log + hardware info home"
    # - Sends the mail
    Send-MailMessage -From $From -To $To -Subject $Sub -Body $EmailBody -Attachments $LogFiles -DN OnSuccess, OnFailure -SmtpServer $smtp -EA SilentlyContinue 
    # - Registry Backup - Compressed, usually ~30mb. Sends directly home
    #Send-BackupHome
}

Function Show-YesNoCancelDialog() {
<#
.SYNOPSIS
Displays a custom message box dialog with Yes, No, and Cancel buttons.

.DESCRIPTION
The Show-YesNoCancelDialog function displays a custom message box dialog with Yes, No, and Cancel buttons. You can customize the title and message to show in the dialog. Additionally, you can specify the icon to display with the message box using the Icon parameter, which can take one of the following values: "None" (default), "Information", "Question", "Warning", or "Error."

.PARAMETER Title
Specifies the title of the message box. The default value is "New Loads."

.PARAMETER Message
Specifies the message to display in the message box.

.PARAMETER YesNo
Indicates whether the message box should show Yes and No buttons only. If this switch is present, the YesNoCancel switch will be ignored.

.PARAMETER YesNoCancel
Indicates whether the message box should show Yes, No, and Cancel buttons.

.PARAMETER Icon
Specifies the icon to display with the message box. Possible values are "None" (default), "Information", "Question", "Warning", and "Error."

.EXAMPLE
Show-YesNoCancelDialog -Title "Confirmation" -Message "Do you want to proceed?" -YesNo
This example shows a custom message box dialog with the title "Confirmation" and the message "Do you want to proceed?" The message box will have Yes and No buttons.

.EXAMPLE
$result = Show-YesNoCancelDialog -Title "Important" -Message "This action is irreversible. Are you sure you want to continue?" -Icon "Warning" -YesNoCancel
This example displays a custom message box dialog with the title "Important," the message "This action is irreversible. Are you sure you want to continue?" and a warning icon. The message box will have Yes, No, and Cancel buttons, and the result (Yes, No, or Cancel) will be stored in the $result variable.

.NOTES
The Show-YesNoCancelDialog function uses the Windows Forms MessageBox class to create the message box dialog. It requires a Windows-based PowerShell environment to display the message box properly.
#>
    [CmdletBinding()]
    param (
        [String] $Title = "New Loads",
        [String] $Message = "Set Execution Policy to RemoteSigned?",
        [Switch] $YesNo,
        [Switch] $YesNoCancel,
        [ValidateSet("None", "Information", "Question", "Warning", "Error")]
        [String] $Icon = "None"
    )

    $BackupWindowTitle = $host.UI.RawUI.WindowTitle
    $WindowTitle = "New Loads - WAITING FOR USER INPUT" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    
    $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Question
    
    switch ($Icon) {
        "None" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::None }
        "Information" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Information }
        "Question" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Question }
        "Warning" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Warning }
        "Error" { $iconFlag = [System.Windows.Forms.MessageBoxIcon]::Error }
    }

    if ($YesNoCancel) {
        Start-Chime
        $result = [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::YesNoCancel, $iconFlag)
    }elseif ($YesNo){
        Start-Chime
        $result = [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::YesNo, $iconFlag)
    }
    
    $host.UI.RawUI.WindowTitle = $BackupWindowTitle
    return $result
}

Function Start-BitlockerDecryption() {
<#
.SYNOPSIS
    Checks if BitLocker is enabled on the host and starts the decryption process if active.

.DESCRIPTION
    The Start-BitlockerDecryption function checks if BitLocker is enabled on the host by examining the protection status of the C: drive. If BitLocker is active, it displays a warning caption and initiates the decryption process for the C: drive using the `Disable-BitLocker` cmdlet. If BitLocker is not enabled, it displays an informational status message indicating that BitLocker is not active on the machine.

.NOTES
    - This function requires administrative privileges to execute `Disable-BitLocker`.

.EXAMPLE
    Start-BitlockerDecryption

    DESCRIPTION
        Checks if BitLocker is enabled on the C: drive. If active, it starts the decryption process. If not enabled, it displays an informational message.

#>
    # - Checks if Bitlocker is active on host
    If ((Get-BitLockerVolume -MountPoint "C:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue).ProtectionStatus -eq "On") {
        # - Starts Bitlocker Decryption
        Write-CaptionWarning -Text "Alert: Bitlocker is enabled. Starting the decryption process"
        Use-Command 'Disable-Bitlocker -MountPoint C:\'
    } else { Write-Status -Types "?" -Status "Bitlocker is not enabled on this machine" }
}
Function Start-Bootup {
<#
.SYNOPSIS
Starts the bootup process and checks various requirements before running the main application.

.DESCRIPTION
The Start-Bootup function is used to perform several checks and initializations before running the main application. It checks the Windows version, execution policy, administrative privileges, license, and other system requirements. If any of the checks fail, the function displays an error message and exits the application.

.PARAMETER None
This function does not accept any parameters.

.NOTES
Ensure that the user running this function has sufficient privileges and meets the necessary requirements to run the main application successfully.
#>
    $WindowTitle = "New Loads - Checking Requirements" ; $host.UI.RawUI.WindowTitle = $WindowTitle

    # Checks OS version to make sure Windows is atleast v20H2 otherwise it'll display a message and close
    $Global:SYSTEMOSVERSION = Get-CimInstance Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber
    $MINIMUMREQUIREMENT = "19042"  ## Windows 10 v20H2 build version
    If ($SYSTEMOSVERSION -LE $MINIMUMREQUIREMENT) {
        $errorMessage = "
        @|\@@                                                                                    `
        -  @@@@                     New Loads requires a minimum Windows version of 20H2 (19042).`
       /7   @@@@                                                                                 `
      /    @@@@@@                             Please upgrade your OS before continuing.          `
      \-' @@@@@@@@`-_______________                                                              `
       -@@@@@@@@@             /    \                                                             `
  _______/    /_       ______/      |__________-                          /\_____/\              `
 /,__________/  `-.___/,_____________----------_)                Meow.    /  o   o  \            `
                                                                        ( ==  ^  == )             `
                                                                         )         (              `
                                                                        (           )             `
                                                                       ( (  )   (  ) )            `
                                                                      (__(__)___(__)__)          `n`n" 
        Write-Host $errorMessage -ForegroundColor Yellow
        Start-Sleep -Seconds 8
        Exit
    }

    # Checks to make sure New Loads is run as admin otherwise it'll display a message and close
    If ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False) {
    $errorMessage = "
        @|\@@                                                                                    `
        -  @@@@                             New Loads REQUIRES administrative privileges         `
       /7   @@@@                                                                                 `
      /    @@@@@@                              Core features rely on this to function            `
      \-' @@@@@@@@`-_______________                                                              `
       -@@@@@@@@@             /    \                                                             `
  _______/    /_       ______/      |__________-                          /\_____/\              `
 /,__________/  `-.___/,_____________----------_)                Meow.    /  o   o  \            `
                                                                        ( ==  ^  == )            `
                                                                         )         (             `
                                                                        (           )            `
                                                                       ( (  )   (  ) )           `
                                                                      (__(__)___(__)__)          `n`n" 
        Write-Host $errorMessage -ForegroundColor Yellow
        Start-Sleep -Seconds 8
        Exit
    }

    # Function that displays program name, version, creator
    Get-MainScriptLogo
    $executionPolicy = (Get-ExecutionPolicy)
    switch ($ExecutionPolicy) {
        "Restricted" {
            Write-Warning "The execution policy is set to 'Restricted', setting it to 'RemoteSigned'"
            Set-ExecutionPolicy RemoteSigned -Scope Process
        }
        "AllSigned" {
            Write-Warning "The execution policy is set to 'AllSigned', setting it to 'RemoteSigned'"
            Set-ExecutionPolicy RemoteSigned -Scope Process
        }
        "Unrestricted" {
            Write-Warning "The execution policy is set to 'Unrestricted', setting it to 'RemoteSigned'"
            Set-ExecutionPolicy RemoteSigned -Scope Process
        }
        "RemoteSigned" {
            Write-Warning "The execution policy is already set to 'Remote Signed', moving on"
        }
        default {
            Write-Warning "The execution policy is set to an unknown value, setting it to 'RemoteSigned'"
            Set-ExecutionPolicy RemoteSigned -Scope Process
        }
    }

    # Updates Time
    Get-NetworkStatus
    Update-Time
    $Global:Time = (Get-Date -UFormat %Y%m%d)
    $DateReq = 20230630
    # Checks a license date code from github. Used to determine if program can run
    #$License = Invoke-WebRequest -Uri $LicenseURI -UseBasicParsing | Select-Object -ExpandProperty Content
    $License = 20231031

    #Update-Time2
    If ($Time -lt $License -and $Time -gt $DateReq) {} else {
        Clear-Host
        Write-Status -Types ":(","ERROR" -Status "There was an uncorrectable error.. Closing Application." -ForegroundColor RED
        Start-Sleep -Seconds 5
        Exit
    }
    # 
    try {
        Remove-Item .\log.txt -Force -ErrorAction SilentlyCOntinue | out-null
        Remove-Item .\newloads-errorlog.txt -Force -ErrorAction SilentlyContinue | out-null
        Remove-Item .\tmp.txt -Force -ErrorAction SilentlyCOntinue | out-null
    }
    catch {
        Write-Error "An error occurred while removing the files: $_"
        Continue
    }

    # Creates folders if they aren't there.
    Try {
        # Checks if the script folders exist, if they don't they're created
        $folders = @("bin", "assets", "lib", "lib\scripts")
        $folders | ForEach-Object {
            if (!(Test-Path ".\$_" -PathType Container -ErrorAction SilentlyContinue)) {
                Write-Status -Types "+" -Status "Creating $_ Folder."
                New-Item -ItemType Directory -Path ".\$_" -Force | Out-Null
            }
        }

    } Catch {
        Write-Error "An error occurred while creating folders or removing files: $_"
    }
}
Function Start-Chime {
<#
.SYNOPSIS
Plays a specified sound file (typically an alarm sound) using the SoundPlayer class.

.DESCRIPTION
The Start-Chime function is used to play a specified sound file (typically an alarm sound) using the SoundPlayer class from the System.Media namespace. The function checks if the sound file exists at the specified file path before attempting to play the sound. If the file exists, it creates a SoundPlayer object, loads the sound file, plays the sound, waits for the sound to finish playing (optional), and then disposes of the SoundPlayer object to release resources.

.PARAMETER None
This function does not accept any parameters.

.NOTES
Ensure that the specified sound file exists at the specified file path before running this function. The SoundPlayer class is part of the .NET Framework, so the function should work on Windows systems with the necessary .NET components installed.
#>
    $SoundFilePath = "C:\Windows\Media\Alarm06.wav"
    # Check if the file exists before attempting to play the sound
    if (Test-Path $SoundFilePath) {
        try {
            # Create a SoundPlayer object and load the sound file
            $soundPlayer = New-Object System.Media.SoundPlayer
            $soundPlayer.SoundLocation = $SoundFilePath
    
            # Play the sound
            $soundPlayer.Play()
    
            # Wait for the sound to finish playing (optional)
            #Start-Sleep -Seconds 3
    
            # Dispose the SoundPlayer object to release resources
            $soundPlayer.Dispose()
        }
        catch {
            Write-Host "An error occurred while playing the sound: $_.Exception.Message"
        }
    }
    else {
        Write-Host "The sound file doesn't exist at the specified path."
    }
}
Function Start-Cleanup {
    # - Starts Explorer if it isn't already running
    If (!(Get-Process -Name Explorer)){ Restart-Explorer }
    # - Enables F8 Boot Menu 
    Write-Status -Types "+" , $TweakType -Status "Enabling F8 boot menu options"
    Use-Command "bcdedit /set `"{CURRENT}`" bootmenupolicy standard"
    # - Launches Chrome to initiate UBlock Origin
    Write-Status -Types "+", $TweakType -Status "Launching Google Chrome"
    Use-Command "Start-Process Chrome -ErrorAction SilentlyContinue -WarningAction SilentlyContinue" -Suppress
    # - Clears Temp Folder
    Write-Status -Types "-", $TweakType -Status "Cleaning Temp Folder"
    Use-Command "Remove-Item `"$env:temp\*.*`" -Force -Recurse -Exclude `"New Loads`" -ErrorAction SilentlyContinue" -Suppress
    # - Removes installed program shortcuts from Public/User Desktop
    foreach ($shortcut in $shortcuts){
        # - Removes common shortcuts , ex. Acrobat, VLC, Zoom
        Write-Status -Types "-", $TweakType -Status "Removing $shortcut"
        Use-Command "Remove-Item -Path `"$shortcut`" -Force -ErrorAction SilentlyContinue | Out-Null"
    }
    # - Removes layout file
    Use-Command "Remove-Item `"$layoutFile`""
}
Function Start-Debloat {
    param(
        [Switch] $Revert
    )
    If (!$Revert){
    <#
    Write-Section "Legacy Apps"
    Write-Caption -Text "Avast"
    Get-InstalledProgram "Avast" -ErrorAction SilentlyContinue | Out-Null
    If ($? -eq $True) { (Get-InstalledProgram "Avast").UninstallString | ForEach-Object (Remove-InstalledProgram $_) }
    Write-Caption -Text "ExpressVPN"
    Get-InstalledProgram "ExpressVPN" -ErrorAction SilentlyContinue | Out-Null
    If ($? -eq $True) { (Get-InstalledProgram "ExpressVPN").UninstallString | ForEach-Object (Remove-InstalledProgram $_) }
    Write-Caption -Text "McAfee"
    Get-InstalledProgram "McAfee" -ErrorAction SilentlyContinue | Out-Null
    If ($? -eq $True) { (Get-InstalledProgram "McAfee").UninstallString | ForEach-Object (Remove-InstalledProgram $_) }
    Write-Caption -Text "Norton"
    Get-InstalledProgram "Norton" -ErrorAction SilentlyContinue | Out-Null
    If ($? -eq $True) { (Get-InstalledProgram "Norton").UninstallString | ForEach-Object (Remove-InstalledProgram $_) }
    Write-Caption -Text "WildTangent Games"
    Get-InstalledProgram "WildTangent" -ErrorAction SilentlyContinue | Out-Null
    If ($? -eq $True) { (Get-InstalledProgram "WildTangent").UninstallString | ForEach-Object (Remove-InstalledProgram $_) }
    #>

    Write-Section -Text "Checking for Start Menu Ads"
    $apps = @(
        "Adobe offers"
        "Amazon"
        "Booking"
        "Booking.com"
        "ExpressVPN"
        "Forge of Empires"
        "Free Trials"
        "Planet9 Link"
        "Utomik - Play over 1000 games"
    )

    ForEach ($app in $apps) {
        try {
            if (Test-Path -Path "$commonapps\$app.url") {
                # - Checks common start menu .urls
                Write-Status -Types "-", "$TweakType", "$TweakTypeLocal" -Status "Removing $app.url"
                Use-Command "Remove-Item -Path `"$commonapps\$app.url`" -Force"
            }
            if (Test-Path -Path "$commonapps\$app.lnk") {
                # - Checks common start menu .lnks
                Write-Status -Types "-", "$TweakType", "$TweakTypeLocal" -Status "Removing $app.lnk"
                Use-Command "Remove-Item -Path `"$commonapps\$app.lnk`" -Force"
            }
            Write-Status -Types "+", "$TweakType", "$TweakTypeLocal" -Status "Removed $app successfully"
        } catch {
            Write-Status -Types "!", "$TweakType", "$TweakTypeLocal" -Status "An error occurred while removing $app`: $_"
        }
    }
    

    Write-Section -Text "UWP Apps"
    $TotalItems = $Programs.Count
    $CurrentItem = 0
    $PercentComplete = 0
    ForEach($Program in $Programs){
        # - Uses blue progress bar to show debloat progress -- ## Doesn't seem to be working currently.
        Write-Progress -Activity "Debloating System" -Status " $PercentComplete% Complete:" -PercentComplete $PercentComplete
        # - Starts Debloating the system
        Remove-UWPAppx -AppxPackages $Program
        $CurrentItem++
        $PercentComplete = [int](($CurrentItem / $TotalItems) * 100)
    }

    # Disposing the progress bar after the loop finishes
    Write-Progress -Activity "Debloating System" -Completed

    # - Debloat Completion
    Write-Host "Debloat Completed!`n" -Foregroundcolor Green
    Write-Host "Packages Removed: " -NoNewline -ForegroundColor Gray ; Write-Host "$Removed" -ForegroundColor Green
    If ($Failed){ Write-Host "Failed: " -NoNewline -ForegroundColor Gray ; Write-Host "$Failed" -ForegroundColor Red }
    Write-Host "Packages Scanned For: " -NoNewline -ForegroundColor Gray ; Write-Host "$NotFound`n" -ForegroundColor Yellow
    Start-Sleep -Seconds 4
}
elseif ($Revert){
    Write-Status -Types "+", "Bloat" -Status "Reinstalling Default Appx from manifest"
    Get-AppxPackage -allusers | ForEach-Object {Add-AppxPackage -register "$($_.InstallLocation)\appxmanifest.xml" -DisableDevelopmentMode -Verbose -ErrorAction SilentlyContinue} | Out-Host
}
}
Function Start-NewLoads {
<#
.SYNOPSIS
Starts the New Loads script, performing system tweaks, optimizations, and cleanups based on user configuration.

.DESCRIPTION
The Start-NewLoads function is the main function that orchestrates the execution of various tasks in the New Loads script. It performs system tweaks, optimizations, and cleanups based on user configuration and preferences. The function calls several sub-functions to carry out specific tasks, such as getting a list of installed programs, applying visual settings, debloating the system, optimizing performance, security, and privacy settings, and more.

.PARAMETER None
This function does not accept any parameters.

.NOTES
The Start-NewLoads function is the entry point for executing the New Loads script. It initiates various sub-functions to perform specific tasks to customize and optimize the system. The function may require administrative privileges to execute some of the tasks, such as system optimizations, debloating, and creating a system restore point.
#>
    Start-Transcript -Path $Log
    $Global:StartTime = Get-Date -DisplayHint Time
    Write-Host "Script start time is: $StartTime"
    If ($SkipPrograms -eq $False){
        $Counter++
        Set-ScriptStatus -WindowTitle "Apps" -TweakType "Apps" -Title $True -TitleText "Programs" -Section $True -SectionText "Application Installation" 
        Get-Programs
    }
    If ($NoBranding -eq $False -or $Branding.Checked -eq $True){
        $Counter++
        Set-ScriptStatus -WindowTitle "Visual" -TweakType "Visuals" -Title $True -TitleText "Visuals"
        Set-Visuals
        $Counter++
        Set-ScriptStatus -WindowTitle "Branding" -TweakType "Branding" -Section $True -SectionText "Branding" -Title $True -TitleText "Mother Computers Branding"
        Set-Branding
    }
    $Counter++
    Set-ScriptStatus -WindowTitle "Start Menu" -TweakType "StartMenu" -Title $True -TitleText "Start Menu Layout" -Section $True -SectionText "Applying Taskbar Layout" 
    Set-StartMenu
    $Counter++
    Set-ScriptStatus -WindowTitle "Debloat" -TweakType "Debloat" -Title $True -TitleText "Debloat" -Section $True -SectionText "Checking for Win32 Pre-Installed Bloat" 
    Start-Debloat
    If ($SkipADW -eq $False){
        Set-ScriptStatus -Section $True -SectionText "ADWCleaner"
        Get-AdwCleaner
    }
    $Counter++
    Set-ScriptStatus -WindowTitle "Office" -TweakType "Office" -Title $True -TitleText "Office Removal" 
    Get-Office
    $Counter++
    Set-ScriptStatus -WindowTitle "Optimization" -TweakType "Registry" -Title $True -TitleText "Optimization"
    Optimize-GeneralTweaks
    Set-ScriptStatus -TweakType "Performance" -Section $True -SectionText "Optimize Performance"
    Optimize-Performance
    Set-ScriptStatus -TweakType "Privacy" -Section $True -SectionText "Optimize Privacy"
    Optimize-Privacy
    Set-ScriptStatus -TweakType "Security" -Section $True -SectionText "Optimize Security"
    Optimize-Security
    Set-ScriptStatus -TweakType "Services" -Section $True -SectionText "Optimize Services"
    Optimize-Services
    Set-ScriptStatus -TweakType "TaskScheduler" -Section $True -SectionText "Optimize Task Scheduler"
    Optimize-TaskScheduler
    Set-ScriptStatus -TweakType "OptionalFeatures" -Section $True -SectionText "Optimize Optional Features"
    Optimize-WindowsOptionalFeatures
    #Get-MsStoreUpdates - Disabled Temporarily
    If ($SkipBitlocker -eq $false){
        $Counter++
        Set-ScriptStatus -WindowTitle "Bitlocker" -TweakType "Bitlocker" -Title $True -TitleText "Bitlocker Decryption" 
        Start-BitlockerDecryption
    }
    $Counter++
    Set-ScriptStatus -WindowTitle "Restore Point" -TweakType "Backup" -Title $True -TitleText "Creating Restore Point" 
    New-SystemRestorePoint
    $Counter++
    Set-ScriptStatus -WindowTitle "Email Log" -TweakType "Email" -Title $True -TitleText "Email Log"
    Send-EmailLog
    $Counter++
    Set-ScriptStatus -WindowTitle "Cleanup" -TweakType "Cleanup" -Title $True -TitleText "Cleanup" -Section $True -SectionText "Cleaning Up" 
    Start-Cleanup
    Write-Status -Types "WAITING" -Status "User action needed - You may have to ALT + TAB " -WriteWarning
    Request-PCRestart
}

Function Use-Command() {
<#
.SYNOPSIS
    Executes a PowerShell command and handles errors with an option to suppress output.

.DESCRIPTION
    The Use-Command function is used to execute a PowerShell command and handle any errors that may occur during the execution. It provides an option to suppress the command's output if desired.

.PARAMETER Command
    Specifies the PowerShell command to be executed. This parameter is mandatory.

.PARAMETER Suppress
    If this switch is provided, the output of the executed command will be suppressed, and errors will be logged silently. Otherwise, errors will be displayed in the console.

.EXAMPLE
    Use-Command -Command "Get-Process"

    DESCRIPTION
        Executes the "Get-Process" command.

.EXAMPLE
    Use-Command -Command "Get-Service" -Suppress

    DESCRIPTION
        Executes the "Get-Service" command, but suppresses its output and logs any errors in the ErrorLog.txt file.

#>
    param (
        [Parameter(Mandatory=$true)]
        [string]$Command,
        [switch]$Suppress
    )
    try {
        if ($Suppress) {
            Invoke-Expression $Command -ErrorAction SilentlyContinue | Out-Null
        } else {
            Invoke-Expression $Command
        }
    } catch {
        $errorMessage = $_.Exception.Message
        $lineNumber = $_.InvocationInfo.ScriptLineNumber
        $command = $Command
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
    }
}

function Update-Time {
<#
.SYNOPSIS
Updates the system's time zone and synchronizes the time with the specified time zone.

.DESCRIPTION
The Update-Time function is used to update the system's time zone and synchronize the time with the specified time zone. It first checks the current time zone and then sets the new time zone using the Set-TimeZone cmdlet. It then synchronizes the time with the server using the w32tm /resync command. If the required time change is too big for automatic synchronization, the function manually updates the system time based on the server time received from the w32tm /resync output.

.PARAMETER TimeZoneId
Specifies the time zone ID to set for the system. The default value is "Pacific Standard Time." You can provide a different time zone ID to update the system's time zone accordingly.

.EXAMPLE
Update-Time -TimeZoneId "Eastern Standard Time"
This example updates the system's time zone to "Eastern Standard Time" and synchronizes the time with the specified time zone.

.NOTES
The Update-Time function requires administrative privileges to modify the system's time zone and start the W32Time service. Ensure that the user running this function has the necessary privileges to perform these tasks.
#>
    param(
        [string]$TimeZoneId = "Pacific Standard Time"
    )
    
    try {
        $currentTimeZone = (Get-TimeZone).DisplayName
        Write-Status -Types "" -Status "Current Time Zone: $currentTimeZone"
        
        # Set time zone
        Set-TimeZone -Id $TimeZoneId -ErrorAction Stop
        Write-Status -Types "+" -Status "Time Zone successfully updated to: $TimeZoneId"
        
        # Synchronize Time
        $w32TimeService = Get-Service -Name W32Time
        if ($w32TimeService.Status -ne "Running") {
                try {
                    Write-Status -Types "+" -Status "Starting W32Time Service" -NoNewLine
                    Start-Service -Name W32Time -ErrorAction Stop
                    Check
                }
                catch {
                    Write-Error "Failed to start the W32Time Service: $_"
                }
            }

        Write-Status -Types "F5" -Status "Syncing Time"
        Start-Sleep -Seconds 2
        $resyncOutput = w32tm /resync
        if ($resyncOutput -like "*The computer did not resync because the required time change was too big.*") {
            Write-Status -Types "@" -Status "Time change is too big. Setting time manually." -WriteWarning
            #$currentDateTime = Get-Date
            New-Variable -Name currentDateTime -Value (Get-Date) -Force -Scope Global
            $serverDateTime = $resyncOutput | Select-String -Pattern "Time: (\S+)" | ForEach-Object { $_.Matches.Groups[1].Value }
            
            Set-Date -Date $serverDateTime
            Write-Status -Types "+" -Status "System time updated manually to: $serverDateTime"
        }
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}



# # # Formatting functions # # #


Function Write-Break{
<#
.SYNOPSIS
    Writes a horizontal break line to the console.

.DESCRIPTION
    The Write-Break function is used to display a horizontal break line in the console. The break line is a series of "=" characters enclosed within square brackets, creating a visually distinct separator in the console output.

.PARAMETER ForegroundColor
    Specifies the foreground color for the break line. The default value is the current foreground color of the console.

.PARAMETER BackgroundColor
    Specifies the background color for the break line. The default value is the current background color of the console.

.EXAMPLE
    Write-Break -ForegroundColor Red -BackgroundColor Black

    DESCRIPTION
        Displays a horizontal break line using the "Red" foreground color and the "Black" background color.

.EXAMPLE
    Write-Break

    DESCRIPTION
        Displays a horizontal break line using the default foreground and background colors.

#>
    Write-Host "`n`n[" -NoNewline -ForegroundColor $ForegroundColor -Backgroundcolor $BackgroundColor
    Write-Host "================================================================================================" -NoNewLine -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "]`n" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}

Function Write-Caption() {
<#
.SYNOPSIS
    Writes a caption with a distinct visual style to the console.

.DESCRIPTION
    The Write-Caption function is used to display a caption in the console with a visually distinct style. The caption is created using characters such as "==" and ">", and it is highlighted with customizable foreground and background colors.

.PARAMETER Text
    Specifies the text to be displayed as the caption. The default value is "No Text" if no value is provided.

.EXAMPLE
    Write-Caption -Text "Important Note"

    DESCRIPTION
        Displays a caption "==> Important Note" with a distinct visual style in the console.

.EXAMPLE
    Write-Caption

    DESCRIPTION
        Displays a caption with the default text "No Text" and a distinct visual style in the console.

#>
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "> " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}

Function Write-CaptionFailed() {
<#
.SYNOPSIS
    Writes a failed caption with a distinct visual style to the console.

.DESCRIPTION
    The Write-CaptionFailed function is used to display a failed caption in the console with a visually distinct style. The failed caption is created using characters such as "==" and ">", and it is highlighted with red and dark red foreground colors on a specified background color.

.PARAMETER Text
    Specifies the text to be displayed as the failed caption. The default value is "Failed" if no value is provided.

.EXAMPLE
    Write-CaptionFailed -Text "Task execution failed!"

    DESCRIPTION
        Displays a failed caption "==> Task execution failed!" with a distinct visual style in the console.

.EXAMPLE
    Write-CaptionFailed

    DESCRIPTION
        Displays a failed caption with the default text "Failed" and a distinct visual style in the console.

#>
    [CmdletBinding()]
    param (
        [String] $Text = "Failed"
    )
    Write-Host "==" -ForegroundColor Red -BackgroundColor $BackgroundColor -NoNewline
    Write-Host "> " -NoNewline -ForegroundColor DarkRed -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}

Function Write-CaptionSucceed() {
<#
.SYNOPSIS
    Writes a success caption with a distinct visual style to the console.

.DESCRIPTION
    The Write-CaptionSucceed function is used to display a success caption in the console with a visually distinct style. The success caption is created using characters such as "==" and ">", and it is highlighted with green and dark green foreground colors on a specified background color.

.PARAMETER Text
    Specifies the text to be displayed as the success caption. The default value is "Success" if no value is provided.

.EXAMPLE
    Write-CaptionSucceed -Text "Task Completed!"

    DESCRIPTION
        Displays a success caption "==> Task Completed!" with a distinct visual style in the console.

.EXAMPLE
    Write-CaptionSucceed

    DESCRIPTION
        Displays a success caption with the default text "Success" and a distinct visual style in the console.

#>
    [CmdletBinding()]
    param (
        [String] $Text = "Success"
    )
    Write-Host "==" -NoNewline -ForegroundColor Green -BackgroundColor $BackgroundColor
    Write-Host "> " -NoNewline -ForegroundColor DarkGreen -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}

Function Write-CaptionWarning() {
<#
.SYNOPSIS
    Writes a warning caption with a distinct visual style to the console.

.DESCRIPTION
    The Write-CaptionWarning function is used to display a warning caption in the console with a visually distinct style. The warning caption is created using characters such as "==" and ">", and it is highlighted with yellow and dark yellow foreground colors on a specified background color.

.PARAMETER Text
    Specifies the text to be displayed as the warning caption. The default value is "Warning" if no value is provided.

.EXAMPLE
    Write-CaptionWarning -Text "Caution!"

    DESCRIPTION
        Displays a warning caption "==> Caution!" with a distinct visual style in the console.

.EXAMPLE
    Write-CaptionWarning

    DESCRIPTION
        Displays a warning caption with the default text "Warning" and a distinct visual style in the console.

#>
    [CmdletBinding()]
    param (
        [String] $Text = "Warning"
        )
        Write-Host "==" -NoNewline -ForegroundColor Yellow -BackgroundColor $BackgroundColor
        Write-Host "> " -NoNewline -ForegroundColor DarkYellow -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}

Function Write-HostReminder() {
<#
.SYNOPSIS
    Writes a reminder message enclosed in square brackets with a distinct visual style to the console.

.DESCRIPTION
    The Write-HostReminder function is used to display a reminder message in the console with a visually distinct style. The reminder message is enclosed within square brackets and is highlighted with a red background and white foreground, creating a noticeable visual effect.

.PARAMETER Text
    Specifies the text to be displayed as the reminder message. The default value is "Example text" if no value is provided.

.EXAMPLE
    Write-HostReminder -Text "Remember to save your work."

    DESCRIPTION
        Displays a reminder message "Remember to save your work." enclosed within square brackets with a distinct visual style.

.EXAMPLE
    Write-HostReminder

    DESCRIPTION
        Displays a reminder message with the default text "Example text" enclosed within square brackets with a distinct visual style.

#> 
    [CmdletBinding()]
    param (
        [String] $Text = "Example text"
        )
        Write-Host "[" -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
        Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine
        Write-Host "]" -BackgroundColor $BackgroundColor -ForegroundColor $ForegroundColor -NoNewline
        Write-Host ": $text`n"
}

Function Write-Section() {
<#
.SYNOPSIS
    Writes a section heading with horizontal bars to the console.

.DESCRIPTION
    The Write-Section function is used to display a section heading in the console. The section heading is enclosed within angle brackets ("< >") and is flanked by horizontal bars to create a visually distinct section in the console output.

.PARAMETER Text
    Specifies the text to be displayed as the section heading. The default value is "No Text" if no value is provided.

.EXAMPLE
    Write-Section -Text "Introduction"

    DESCRIPTION
        Displays a section heading "Introduction" enclosed within angle brackets ("< >") and flanked by horizontal bars.

.EXAMPLE
    Write-Section

    DESCRIPTION
        Displays a section heading with the default text "No Text" enclosed within angle brackets ("< >") and flanked by horizontal bars.
#>
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )
    Write-Host "`n<" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "=================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "] " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "=================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host ">" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}

Function Write-Status() {
<#
.SYNOPSIS
    Writes a status message with timestamp, message types, and customizable text color to the console.

.DESCRIPTION
    The Write-Status function is used to display a status message in the console with additional information. The status message includes a timestamp, message types, and customizable foreground text color. The message types are displayed within square brackets, and users can provide multiple message types as an array. The status message can be displayed as a regular information message or as a warning message.

.PARAMETER Types
    Specifies an array of message types to be displayed with the status message. Each message type is displayed within square brackets.

.PARAMETER Status
    Specifies the main status message to be displayed in the console.

.PARAMETER WriteWarning
    If this switch is provided, the status message is treated as a warning, and it will be displayed with a "Warning" label. Otherwise, it will be displayed as a regular information message.

.PARAMETER NoNewLine
    By default, the function adds a new line after displaying the status message. If this switch is provided, the new line after the status message will be omitted.

.PARAMETER ForegroundColorText
    Specifies the foreground color for the status message text. The default value is "White" if no value is provided. The available color options are: "Black", "DarkBlue", "DarkGreen", "DarkCyan", "DarkRed", "DarkMagenta", "DarkYellow", "Gray", "DarkGray", "Blue", "Green", "Cyan", "Red", "Magenta", "Yellow", and "White".

.EXAMPLE
    Write-Status -Types @("[Action]", "[Progress]") -Status "Processing items" -WriteWarning

    DESCRIPTION
        Displays a status message "Processing items" with message types "[Action]" and "[Progress]" in the console. The status message is treated as a warning, and it will be displayed with a "Warning" label.

.EXAMPLE
    Write-Status -Types @("[Info]", "[Step 2]") -Status "Completed successfully"

    DESCRIPTION
        Displays a status message "Completed successfully" with message types "[Info]" and "[Step 2]" in the console. The status message is displayed as an information message.

.EXAMPLE
    Write-Status -Types @("[Error]") -Status "An error occurred" -ForegroundColorText "Red"

    DESCRIPTION
        Displays a status message "An error occurred" with message type "[Error]" in the console. The status message text will be displayed in red color.

#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Array]  $Types,
        [Parameter(Mandatory)]
        [String] $Status,
        [Switch] $WriteWarning,
        [Switch] $NoNewLine,
        [ValidateSet("Black", "DarkBlue", "DarkGreen", "DarkCyan", "DarkRed", "DarkMagenta", "DarkYellow", "Gray", "DarkGray",
        "Blue", "Green", "Cyan", "Red", "Magenta", "Yellow", "White")]
        [String] $ForegroundColorText = "White"
    )
    #Write-Host "]" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor -NoNewline 
    $Time = Get-Date
    $FormattedTime = $Time.ToString("MMMM d, yyyy h:mm:ss tt")
    Write-Host "$FormattedTime " -NoNewline -ForegroundColor Gray -BackgroundColor $BackgroundColor

    ForEach ($Type in $Types) {
        Write-Host "$Type " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    }

    If ($WriteWarning) {
        If ($NoNewLine){
            Write-Host "::Warning:: -> $Status" -ForegroundColor Yellow -BackgroundColor $BackgroundColor -NoNewline
        }else{
            Write-Host "::Warning:: -> $Status" -ForegroundColor Yellow -BackgroundColor $BackgroundColor
        }   
    } Else {
        If ($NoNewLine){
            Write-Host "-> $Status" -ForegroundColor $ForegroundColorText -BackgroundColor $BackgroundColor -NoNewline
        }else{
            
            Write-Host "-> $Status" -ForegroundColor $ForegroundColorText -BackgroundColor $BackgroundColor
        }
    }
}

Function Write-Title() {
<#
.SYNOPSIS
    Writes a custom title with horizontal bars to the console.

.DESCRIPTION
    The Write-Title function is used to display a custom title in the console. The title is enclosed within angle brackets ("< >") and is flanked by horizontal bars to create a visually distinct heading in the console output.

.PARAMETER Text
    Specifies the text to be displayed as the custom title. The default value is "No Text" if no value is provided.

.PARAMETER NoNewLineLast
    By default, the function adds a new line after displaying the title. If this switch is provided, the new line after the title will be omitted.

.EXAMPLE
    Write-Title -Text "Welcome to My Script"

    DESCRIPTION
        Displays a custom title "Welcome to My Script" enclosed within angle brackets ("< >") and flanked by horizontal bars.

.EXAMPLE
    Write-Title -Text "Important Message" -NoNewLineLast

    DESCRIPTION
        Displays a custom title "Important Message" without adding a new line after the title.

#>
    [CmdletBinding()]
    param (
        [String] $Text = "No Text",
        [Switch] $NoNewLineLast
    )
    Write-Host "`n<" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "===========================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "] " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "===========================" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host ">" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}

Function Write-TitleCounter() {
<#
.SYNOPSIS
    Writes a custom title with a counter and horizontal bars to the console.

.DESCRIPTION
    The Write-TitleCounter function is used to display a custom title along with a counter in the console. The title is enclosed within angle brackets ("< >") and is flanked by horizontal bars. The counter is displayed in the format "X/Y," where X represents the current counter value and Y represents the maximum length or total count.

.PARAMETER Text
    Specifies the text to be displayed as the custom title. The default value is "No Text" if no value is provided.

.PARAMETER Counter
    Specifies the current counter value to be displayed. The default value is 0 if no value is provided.

.PARAMETER MaxLength
    Specifies the maximum length or total count for the counter. The default value is determined by the caller if no value is provided.

.EXAMPLE
    Write-TitleCounter -Text "Processing Items" -Counter 1 -MaxLength 10

    DESCRIPTION
        Displays a custom title "Processing Items" enclosed within angle brackets ("< >") and flanked by horizontal bars. The counter value is displayed as "1/10".

.EXAMPLE
    Write-TitleCounter -Text "Completed" -Counter 5 -MaxLength 20

    DESCRIPTION
        Displays a custom title "Completed" enclosed within angle brackets ("< >") and flanked by horizontal bars. The counter value is displayed as "5/20".

#>
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param (
        [String] $Text = "No Text",
        [Int]    $Counter = 0,
        [Int] 	 $MaxLength
    )
    Write-Host "`n`n<" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "=-=-=-=-=-=-=-=-=-=-=-=-=-=" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "]" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host " (" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host " $Counter/$MaxLength " -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host ") " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "|" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host " $Text " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "[" -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "=-=-=-=-=-=-=-=-=-=-=-=-=-=" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host ">" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}

# Initiation #

####################################################################################

# Initiates check for OS version, 
Start-Bootup
Import-Variables
Get-Assets
#Get-ZippedAssets
Import-NewLoadsModules
Get-NetworkStatus

####################################################################################

# Script Start #

# Checks if user requested GUI or not.
If (!$GUI) {
    Start-NewLoads
    } elseif ($GUI) {
    Get-NetworkStatus
    GUI
}


####################################################################################

