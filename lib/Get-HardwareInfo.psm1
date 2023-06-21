
function Get-CPU() {
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
function Get-GPU() {
    $gpu = Get-WmiObject Win32_VideoController | Select-Object Name | Out-String
    return $gpu.Trim()
}
function Get-RAM() {
    $ram = Get-CimInstance Win32_ComputerSystem | Select-Object TotalPhysicalMemory
    $ram = $ram.TotalPhysicalMemory / 1GB
    return "{0:N2} GB" -f $ram
}
function Get-OSArchitecture() {
    $osarch = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
    return $osarch
}
function Get-OSDriveType() {
    $osdrive = (Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'").DriveType
    return $osdrive
}
function Get-DriveSpace() {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(Mandatory = $false)]
        [ValidatePattern("^([a-zA-Z]:\\)?$")]
        [String] $DriveLetter = $env:SystemDrive[0]
    )

    try {
        $SystemDrive = Get-PSDrive -Name $DriveLetter -ErrorAction Stop
        $AvailableStorage = $SystemDrive.Free / 1GB
        $UsedStorage = $SystemDrive.Used / 1GB
        $TotalStorage = $AvailableStorage + $UsedStorage

        return "$DriveLetter`: $($AvailableStorage.ToString("#.#"))/$($TotalStorage.ToString("#.#")) GB ($((($AvailableStorage / $TotalStorage) * 100).ToString("#.#"))%)"
    }
    catch {
        Write-Warning "Failed to retrieve drive space for drive $($DriveLetter.ToUpper()): $_"
        return $null
    }
}
function Get-SystemSpec() {
    [OutputType([System.Object[]])]
    param (
        [Parameter(Mandatory = $false)]
        [String] $Separator = '|'
    )

    #Write-Status -Types "@" -Status "Loading system specs..."
    # Adapted From: https://www.delftstack.com/howto/powershell/find-windows-version-in-powershell/#using-the-wmi-class-with-get-wmiobject-cmdlet-in-powershell-to-get-the-windows-version
    $WinVer = (Get-CimInstance -class Win32_OperatingSystem).Caption -replace 'Microsoft ', ''
    $DisplayVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").DisplayVersion
    $OldBuildNumber = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId
    $DisplayedVersionResult = '(' + @{ $true = $DisplayVersion; $false = $OldBuildNumber }[$null -ne $DisplayVersion] + ')'

    return <#$(Get-OSDriveType), $Separator,#> $WinVer, $DisplayedVersionResult, $Separator, $(Get-RAM), $Separator, $(Get-CPU -Separator $Separator), $Separator, $(Get-GPU)
}