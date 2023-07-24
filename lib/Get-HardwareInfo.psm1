
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
function Get-CPU {
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
function Get-GPU {
    [CmdletBinding()]
    [OutputType([String])]
    param ()
    $gpu = Get-CimInstance -Class Win32_VideoController | Select-Object -ExpandProperty Name
    return $gpu.Trim()
}



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
function Get-RAM {
    [CmdletBinding()]
    [OutputType([String])]
    param ()
    $ram = Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
    $ram = $ram / 1GB
    return "{0:N2} GB" -f $ram
}


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
function Get-OSArchitecture {
    [CmdletBinding()]
    [OutputType([String])]
    param ()
    $osarch = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
    return $osarch
}


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
function Get-DriveInfo {
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
function Get-DriveSpace {
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
function Get-SystemSpec {
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



# SIG # Begin signature block
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUe31nmU78I624+geyUjIukjpJ
# 1fugggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFH8/bOFeBrUubRYY3dRdVGKz321uMA0GCSqGSIb3DQEB
# AQUABIIBAI42lGKYlOvbTAi6IBEFMAuViIC52YeucfJV8ScW5VgAX548J/EiGxkV
# bzq3NNJ/VoYvKUgTEWw49989IfEKR+LyqmznsIuTI3rc6fuhGSL8f5LcXA+2wj/m
# fFRwxsNaiu8SDOzjkEh+1t27tkhA5mMpHBmm6pbQjo68hjKtb7wqoWWeOi1rdTC0
# QxXxfvx4Rhob37uPCILnHPl8+wRBTjtGUeROmJxMf3RdubbwO0jhukuZIKwS/v5y
# /UEaRqw4RHXY7UWpWMFxMl4nBaJUDpgdbjPE8aVutytM7RUOTFj+0fk/O2KTqTG6
# NW6LUyDcw/c2WXTpK6PvTsKIDvKEQ+s=
# SIG # End signature block
