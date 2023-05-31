param(
    [switch]$Global:GUI,
    [switch]$Global:WhatIf
)
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
New-Variable -Name "ProgramVersion" -Value "v2023.1.06" -Scope Global -Force
New-Variable -Name "ReleaseDate" -Value "May 29th, 2023" -Scope Global -Force
New-Variable -Name "NewLoadsURL" -Value "https://raw.githubusercontent.com/circlol/newloadsTesting/main/New%20Loads.ps1" -Scope Global -Force
New-Variable -Name "NewLoadsURLMain" -Value "https://raw.githubusercontent.com/circlol/newloadsTesting/main/" -Scope Global -Force
New-Variable -Name "AssetsURL" -Value "https://raw.githubusercontent.com/circlol/newloadsTesting/main/exe/assets.psm1" -Scope Global -Force
$LogoColor = "Yellow"
$WindowTitle = "New Loads"
$Global:BackgroundColor = "Black"
$Global:ForegroundColor = "Red"
$host.UI.RawUI.WindowTitle = $WindowTitle
$host.UI.RawUI.BackgroundColor = 'Black'
$host.UI.RawUI.ForegroundColor = 'White'
Clear-Host
Function Start-Bootup() {
    $WindowTitle = "New Loads - Checking Requirements" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    $SYSTEMOSVERSION = [System.Environment]::OSVersion.Version.Build
    $MINIMUMREQUIREMENT = "19042"  ## Windows 10 v20H2 build version
    If ($SYSTEMOSVERSION -LE $MINIMUMREQUIREMENT) {
        $errorMessage = "New Loads requires a minimum Windows version of 20H2 (19042). Please upgrade your OS before continuing."
        throw $errorMessage
        Start-Sleep -Milliseconds 1500
        Exit
    }

    If ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False) {
        $errorMessage = "New Loads requires a minimum Windows version of 20H2 (19042). Please upgrade your OS before continuing."
        throw $errorMessage
        Start-Sleep -Seconds 3
        Exit
    }

    # Function that displays program name, version, creator
    Get-ScriptInfo
    $executionPolicy = (Get-ExecutionPolicy)
    switch ($ExecutionPolicy) {
        "Restricted" {
            Write-Warning "The execution policy is set to 'Restricted', setting it to 'RemoteSigned'"
            Set-ExecutionPolicy RemoteSigned -Scope Process -Confirm
        }
        "AllSigned" {
            Write-Warning "The execution policy is set to 'AllSigned', setting it to 'RemoteSigned'"
            Set-ExecutionPolicy RemoteSigned -Scope Process -Confirm
        }
        "Unrestricted" {
            Write-Warning "The execution policy is set to 'Unrestricted', setting it to 'RemoteSigned'"
            Set-ExecutionPolicy RemoteSigned -Scope Process -Confirm
        }
        "RemoteSigned" {
            Write-Host "The execution policy is already set to 'RemoteSigned'."
        }
        default {
            Write-Warning "The execution policy is set to an unknown value, setting it to 'RemoteSigned'"
            Set-ExecutionPolicy RemoteSigned -Scope Process -Confirm
        }
    }

    $localPath = ".\assets.psm1"
    
    # Check if the file exists in the local path
    if (Test-Path $localPath) {
        Import-Module $localPath -Force
    } else {
        # Download the module from the remote URL and save it to the local path
        Invoke-WebRequest $AssetsURL -OutFile $localPath
        Import-Module $localPath -Force
    }

    # We check the time here so later
    Get-NetworkStatus
    Update-Time
    $Global:Time = (Get-Date -UFormat %Y%m%d)
    $DateReq = 20230101
    $License = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/circlol/newloadsTesting/main/assets/license.txt" -UseBasicParsing | Select-Object -ExpandProperty Content

    #Update-Time2
    If ($Time -lt $License -and $Time -gt $DateReq) {} else {
        Clear-Host
        Write-Host "There was an uncorrectable error.. Closing Application."
        Start-Sleep -S 5 ; Exit
    }
    try {
        Remove-Item .\log.txt -Force -ErrorAction SilentlyCOntinue | out-null
        Remove-Item .\newloads-errorlog.txt -Force -ErrorAction SilentlyCOntinue | out-null
        Remove-Item .\tmp.txt -Force -ErrorAction SilentlyCOntinue | out-null
    }
    catch {
        Write-Error "An error occurred while removing the files: $_"
        Continue
    }
}
<#Function Update-Time {
    $CurrentTimeZone = (Get-TimeZone).DisplayName
    $CurrentTime = (Get-Date).ToString("hh:mm tt")
    $TimeZone = "Pacific Standard Time"
    Write-Host "Current Time: $currentTime  Current Time Zone: $CurrentTimeZone"

    # Set time zone to Pacific
    Set-TimeZone -Id $TimeZone -ErrorAction SilentlyContinue
    If ($?) { Write-Host "Time Zone successfully updated." } elseif (!$?) { Write-Host "Time Zone failed to update." }
    #Synchronize Time
    If ((Get-Service -Name W32Time).Status -ne "Running") {
        Write-Host "Starting W32Time Service"
        Start-Service -Name W32Time
        Write-Host "Syncing Time"
        w32tm /resync
    }
    else {
        Write-Host "Syncing Time"
        w32tm /resync
    }
}#>
Function Update-Time() {
    $CurrentTimeZone = (Get-TimeZone).DisplayName
    $CurrentTime = (Get-Date).ToString("hh:mm tt")
    $TimeZone = "Pacific Standard Time"
    Write-Output "Current Time: $CurrentTime  Current Time Zone: $CurrentTimeZone"
    
    # Set time zone to Pacific
    Set-TimeZone -Id $TimeZone -ErrorAction SilentlyContinue
    Write-Output "Time Zone successfully updated."
    
    # Synchronize Time
    $w32TimeService = Get-Service -Name W32Time
    if ($w32TimeService.Status -ne "Running") {
        Write-Output "Starting W32Time Service"
        $w32TimeService | Start-Service
    }
    
    Write-Output "Syncing Time"
    w32tm /resync
}
Function Update-Time2() {
    $response = Invoke-WebRequest -Uri "http://worldclockapi.com/api/json/utc/now"
    $jsonResponse = $response | ConvertFrom-Json
    $currentDateTime = $jsonResponse.currentDateTime
    $dateTime = [DateTime]::Parse($currentDateTime)
    Set-Date -Date $dateTime
    Start-Process -FilePath "w32tm" -ArgumentList "/resync" -NoNewWindow -PassThru | Out-Host
    Start-Sleep -Seconds 2
}
Function Get-ScriptInfo() {
    $WindowTitle = "New Loads - Initialization" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    $Logo = "`n`n`n▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀`n`n
                        ███╗   ██╗███████╗██╗    ██╗    ██╗      ██████╗  █████╗ ██████╗ ███████╗
                        ████╗  ██║██╔════╝██║    ██║    ██║     ██╔═══██╗██╔══██╗██╔══██╗██╔════╝
                        ██╔██╗ ██║█████╗  ██║ █╗ ██║    ██║     ██║   ██║███████║██║  ██║███████╗
                        ██║╚██╗██║██╔══╝  ██║███╗██║    ██║     ██║   ██║██╔══██║██║  ██║╚════██║
                        ██║ ╚████║███████╗╚███╔███╔╝    ███████╗╚██████╔╝██║  ██║██████╔╝███████║
                        ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝`n`n
                        "
    Write-Host $Logo -ForegroundColor $LogoColor -BackgroundColor Black -NoNewline
    Write-Host "     Created by " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "Papi" -ForegroundColor Red -BackgroundColor Black -NoNewLine
    Write-Host "      Last Update: " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "$ProgramVersion - $ReleaseDate" -ForegroundColor Green -BackgroundColor Black
    Write-Host "`n`n  Notice: " -NoNewLine -ForegroundColor RED -BackgroundColor Black
    Write-Host "For New Loads to function correctly, it is important to update your system to the latest version of Windows." -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "`n`n`n▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀`n`n" -ForegroundColor $LogoColor -BackgroundColor Black
    $WindowTitle = "New Loads" ; $host.UI.RawUI.WindowTitle = $WindowTitle
}
Function Show-YesNoCancelDialog() {
    [CmdletBinding()]
    param (
        [String] $Title = "New Loads",
        [String] $Message = "Set Execution Policy to RemoteSigned?",
        [Switch] $YesNoCancel
    )
    $BackupWindowTitle = $host.UI.RawUI.WindowTitle
    $WindowTitle = "New Loads - WAITING FOR USER INPUT" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    if ($YesNoCancel) {
        $result = [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::YesNoCancel)
    }
    $host.UI.RawUI.WindowTitle = $BackupWindowTitle                                 
    return $result                                                                  
    # Example - Show-YesNoCancelDialog -YesNoCancel
    # Example - Show-YesNoCancelDialog -YesNoCancel -Title "Example" -Message "Do you want to x?"
}
Function Get-NetworkStatus() {
    [CmdletBinding()]
    param(
        [string]$NetworkStatusType = "IPv4Connectivity"
    )
    $NetStatus = (Get-NetConnectionProfile).$NetworkStatusType
    if ($NetStatus -ne 'Internet') {
        Write-Status -Types "WAITING" -Status "Seems like there's no network connection. Please reconnect." -Warning
        while ($NetStatus -ne 'Internet') {
            Write-Status -Types ":(" -Status "Waiting for internet..."
            Start-Sleep -Seconds 2
            $NetStatus = (Get-NetConnectionProfile).$NetworkStatusType
        }
        Start-Sleep -Seconds 3
        Write-Status -Types ":)" -Status "Connected. Moving on."
    }
}
Function Check() {
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
####################################################################################


### RUN ORDER


####################################################################################

Start-Bootup
Import-Variables
Import-Files
Import-NewLoadsModules
Get-NetworkStatus
Start-NewLoads


####################################################################################





####################################################################################
# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU+2NUvEPX567CMsIQUgCKS4rt
# CiCgggMQMIIDDDCCAfSgAwIBAgIQOtpMekE2BIRJ/swv2v8NGDANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIzMDUzMTA0
# MjM1NVoXDTI0MDUzMTA0NDM1NVowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMWf9Y3819xnY6KW
# p0CYtLc6vBDWMvATfsxnp3dXzZ1umVRwI0tqKQ3yTursULPsAZIBm06zN+N74hnR
# +xncqME0LwdqFrodwLlmIso0Cbe70iif+fd3ySrdpHXZQVJfFySPyPjOoq9Mfeo9
# 3hPE6gh28dBRG+KmDukamTHgxhkZ6w4JvYRAFJs3xwucH0FhGsDlQAji9zs636tp
# N9amsVCZy3FfNajYRrVHvOf+0nzch5dRuHw4hQMr8wo6oQhrUskx9eeqxzvAZUI4
# wPqwfOEa9Fcqrz2LWRZmvLVaw1Ci/YQ4+caJwmktMnR1wntmaPzwAkcq1v+fP9ql
# DJqR3P0CAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBS6ttW6EPvULmOEpRijcxJtJnpZxzANBgkqhkiG9w0BAQsF
# AAOCAQEAicq1fzgkUi8pCtZ3HwRrnajPLjralGKmgN0IOuBB697YfSjKOb8QFRDa
# vCNQRrfzzhYalhy1uU9AQS88wZA7OYFa6bDgFMpBGZ3BZ7MPzUUKLzYVR5S5jF+v
# gIaE6UWdLVpzUZGSkdpYjnEHnGZ5Yp/ZOQhh49C+FX0q/VM8reyf/SThhvTZV6jO
# Nflhk26fANgDSkh8btwnGnpXlV7fafrXlcSkfP/2M3HQER3/ziDdQGzb76b1YS8o
# lL8E0Lk1jMp2qh37ro4LpEpMsFGOtx4cRXwR4N1KG+nqjjk7fEEVGAbaaipypQnP
# 2aAxrMDxbK+nA3RHwMmuoX+ION3gXTGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQOtpMekE2BIRJ/swv2v8NGDAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUzqQ1pyyc6H/26q8P85a1MbpL5J8wDQYJKoZIhvcNAQEBBQAEggEAQZjr
# vEIRE3tkwg2lh9lx3NGDOnX0nxOcU5DhHFGeektvHP7BgP24N0dc1ra9JF5r9RCW
# YzUZoQj+7SujDkshLbTLpTOO5MglzB/Z1NYOxmCGEi6dgT2LJSarVItttoau7IC0
# 6RdRijS51Q074RgFfdxzT4XcNVDgET1QZI9+j/o7EDKGznJdLa+Rlha/MtYdxjPQ
# vjqXTyIJGtXNXVursvcTr/aJKOQTFNvGu7teI68orC/3UQhv5ZqFAycR8BBHn0jO
# Ywnqo2OyS2XZMYQGvo+vsdylu7iG4AMTFCnq4eKY2Al+7cUAmVjqgMwjG72BecnF
# dhlAYxnYA8zSxXzQhQ==
# SIG # End signature block
