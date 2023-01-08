#Requires -RunAsAdministrator
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
$WindowTitle = "New Loads - Initializing" ; $host.UI.RawUI.WindowTitle = $WindowTitle
$host.UI.RawUI.BackgroundColor = 'Black' ; $host.UI.RawUI.ForegroundColor = 'White'
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
Clear-Host

Function Bootup() {
    $SYSTEMOSVERSION = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name CurrentBuild).CurrentBuild
    $MINIMUMREQUIREMENT = "20000"
    If ($SYSTEMOSVERSION -LE $MINIMUMREQUIREMENT){ Write-Host "Error: New Loads requires a minimum Windows version of Win10-20H2" ; Start-Sleep -Seconds 5 ; EXIT }
    If ((New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False){
        Write-Host "Error: New Loads needs to be run as administrator.." ; Start-Sleep -Seconds 3 ; Exit 
    }
    If (Test-Path .\assets.psm1 ) { Import-Module .\assets.psm1 -Force}
    ScriptInfo
    do{ Write-Host " ATTENTION " -NoNewline -BackgroundColor RED -ForegroundColor WHITE
        Write-Host " I need modules to work properly! Can I download them? Type " -NoNewline -BackgroundColor Black -ForegroundColor White
        Write-Host "'AGREE'" -NoNewline -BackgroundColor Black -ForegroundColor Green
        Write-Host ": " -NoNewline -BackgroundColor Black -ForegroundColor White
        $Consent = Read-Host
        } until ( $Consent -eq "AGREE") #-Or Deny
    try {
        stop-transcript | out-null
        If (Test-Path .\Log.txt) { Remove-Item .\log.txt -Force }
        If (Test-Path .\ErrorLog.txt) { Remove-Item .\ErrorLog.txt -Force}
        If (Test-Path .\tmp.txt) { Remove-Item .\tmp.txt -Force }
    }catch [System.InvalidOperationException] {}
}    
Function LocalVariables() {
    New-Variable -Name "ProgramVersion" -Value "Jan 02, 23" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "newloads" -Value ".\" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "MaxLength" -Value '17' -Scope Global -Force
    New-Variable -Name "ErrorLog" -Value ".\ErrorLog.txt" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Log" -Value ".\Log.txt" -Scope Global -Force
    New-Variable -Name "temp" -Value "$env:temp" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Win11" -Value "22000" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "22H2" -Value "22621" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "BuildNumber" -Value (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name CurrentBuild).CurrentBuild
    New-Variable -Name "NetStatus" -Value (Get-NetConnectionProfile).IPv4Connectivity -Scope Global -Force
    New-Variable -Name "Connected" -Value "Internet" -Scope Global -Force
}
Function ScriptInfo() {
    Write-Host '                                                                                              '
    Write-Host " _   _                 _                     _     " -ForegroundColor White -BackgroundColor Black
    Write-Host "| \ | |               | |                   | |    " -ForegroundColor White -BackgroundColor Black
    Write-Host "|  \| | _____      __ | |     ___   __ _  __| |___ " -ForegroundColor White -BackgroundColor Black
    Write-Host "| . `` |/ _ \ \ /\ / / | |    / _ \ / _`` |/ _``  / __|" -ForegroundColor White -BackgroundColor Black
    Write-Host "| |\  |  __/\ V  V /  | |___| (_) | (_| | (_| \__ \" -ForegroundColor White -BackgroundColor Black
    Write-Host "\_| \_/\___| \_/\_/   \_____/\___/ \__,_|\__,_|___/" -ForegroundColor White -BackgroundColor Black
    
    Write-Host '                                                                                              '
    Write-Break
    Write-Host "Created by " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "Mike" -ForegroundColor Red -BackgroundColor Black -NoNewLine
    Write-Host "      Last Update: " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "$ProgramVersion" -NoNewLine -ForegroundColor Red -BackgroundColor Black
    Write-Host "      Recommended: " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "Update Windows before using New Loads" -NoNewLine -ForegroundColor Red -BackgroundColor Black
    Write-Break
    Write-Host ""
}
Function Use-WindowsForm() {
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null # Load assembly
}
Function Show-Question() {
    [CmdletBinding()]
    [OutputType([System.Windows.Forms.DialogResult])]
    param (
        [String] $Title = "New Loads",
        [Array]  $Message = "      ",
        [String] $BoxButtons = "YesNoCancel", # With Yes, No and Cancel, the user can press Esc to exit
        [String] $BoxIcon = "Question"
    )

    Use-WindowsForm
    $Answer = [System.Windows.Forms.MessageBox]::Show($Message, $Title, [System.Windows.Forms.MessageBoxButtons]::$BoxButtons, [System.Windows.Forms.MessageBoxIcon]::$BoxIcon)

    return $Answer
}
Function Selector() {
    $Ask = "    Run New Loads in GUI or Automated mode?
        (  YES  ) = Automated
        (  NO  )  =   GUI
        ( CANCEL ) =  Exit"

    switch (Show-Question -Title "New Loads" -Message $Ask) {
        'Yes' {
            Write-Host "You have chosen to run New Loads in Automated Mode.. Initiating"
        }
        'No' {
            Write-Host "You have chosen to run New Loads in GUI Mode.. Initiating"
            New-Variable -Name "GUI" -Value $True -Scope Global
        }
        'Cancel' {
            Write-Host "Closing."
            Exit
        }
    }
}
Function CheckNetworkStatus() {
    Set-Variable -Name "NetStatus" -Value (Get-NetConnectionProfile).IPv4Connectivity -Scope Global -Force
    if ($NetStatus -ne $Connected) {
        Write-Status -Types "WAITING" -Status "Seems like theres no network connection.. Please Reconnect..." -Warning 
        do {
            Write-Status -Types ":(" -Status "Waiting for internet..."
            Start-Sleep -Seconds 3
            } until ((Get-NetConnectionProfile).IPv4Connectivity -Or (Get-NetConnectionProfile).IPv6Connectivity -eq 'Internet') 
        Start-Sleep -Seconds 4
        Write-Status -Types ":)" -Status "Connected... Moving on"
    }
}
Function Request-PcRestart() {
    $Ask = "Reboot?"

    switch (Show-Question -Title "New Loads" -Message $Ask) {
        'Yes' {
            Write-Host "You choose to Restart now"
            Restart-Computer
        }
        'No' {
            Write-Host "You choose to Restart later"
        }
        'Cancel' {
            # With Yes, No and Cancel, the user can press Esc to exit
            Write-Host "You choose to Restart later"
        }
    }
}

Bootup
Selector
LocalVariables
If (Test-Path .\CheckFiles.psm1) {
    Import-Module .\CheckFiles.psm1 -Force 
    Write-Host "New Loads Integrity Check" 
    CheckFiles
}else{ 
    Clear-Host 
    Write-Host "CheckFiles.psm1 is missing. Please acquire this file to continue." 
    Start-Sleep 4
    Exit
}
#CheckNetworkStatus ; Invoke-WebRequest -useb https://raw.githubusercontent.com/circlol/newload/main/New%20Loads.ps1 | Invoke-Expression
$Modules = (Get-ChildItem -Path ".\lib" -Include "*.psm1" -Recurse).Name
ForEach ($Module in $Modules){
    Import-Module .\lib\"$Module" -Force
}

$URL = "https://raw.githubusercontent.com/circlol/newloadsTesting/main/New%20Loads.ps1"
$wc = New-Object System.Net.WebClient
If ( $Valid -eq $True ) { 
    CheckNetworkStatus 
    $wc.DownloadString($URL) | Invoke-Expression 
    }

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUSgD1rP8xlH7HT1oEIIaxrS+0
# hwqgggMQMIIDDDCCAfSgAwIBAgIQbsRA190DwbdBuskmJyNY4jANBgkqhkiG9w0B
# AQsFADAeMRwwGgYDVQQDDBNOZXcgTG9hZHMgQ29kZSBTaWduMB4XDTIyMTIyNDA1
# MDQzMloXDTIzMTIyNDA1MjQzMlowHjEcMBoGA1UEAwwTTmV3IExvYWRzIENvZGUg
# U2lnbjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKBzm18SMDaGJ9ft
# 4mCIOUCCNB1afaXS8Tx2dAnJ+84pGS4prKCxc7/F+n5uqXtPZcl88tr9VR1N/BBE
# Md4LWvD2o/k5WfkYPtBoatldnZs9d1HBgIrWJoulc3PidboCD4Xz9Z9ktfrcmhc8
# MfDD0DfSKswyi3N9L6t8ZRdLUW+JCh/1WHbt7o3ckvijEuKh9AOnzYtkXJfE+eRd
# DKK2sq46WlZG2Sm3J+WOo2oeoFvvYHRG9RtzSY2EhmVRYWzGFM/GCqLUbh2wZwdY
# uG61lCrkC6ZjEYPhs5ckoijMFC6bb4zYk4lYDzartHYiMxH1Ac0jNpaq+7kB3oRF
# QLXWc+kCAwEAAaNGMEQwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUF
# BwMDMB0GA1UdDgQWBBRkAPIg1GpPJcyyzANerOe2sUGidTANBgkqhkiG9w0BAQsF
# AAOCAQEABc3czHPSCyEDQ9MzWSiW7EhjXsyyj6JfP0a2onvRPoW0EzBq3BxwpGGJ
# btML2ST94OmT8huibh8Cp2TnbAAxIhNU0tN3XMz2AXfJT5cr4MdHGDksiMj1Hcjn
# wxXAf6uYX3+jovGZbgpog0KUk88p2vhU1oZP0YpaRaOqnjUH+Ml4g1fOx8siBmGu
# vs9L+Kb5w2W8TjCBuGqGY4d8chxQe8A0ViZtp4LB+/1NAkt14GTwqOdWrKNIynMz
# Rpa+Wkey1J0tG5AhNp0hvwmAO6KFSGtXHuNWwua9IpLMJsowj2U2TmzqLSDC2YrO
# BgC97m41lByepRPQwnnV3p8NFn4CyTGCAdMwggHPAgEBMDIwHjEcMBoGA1UEAwwT
# TmV3IExvYWRzIENvZGUgU2lnbgIQbsRA190DwbdBuskmJyNY4jAJBgUrDgMCGgUA
# oHgwGAYKKwYBBAGCNwIBDDEKMAigAoAAoQKAADAZBgkqhkiG9w0BCQMxDAYKKwYB
# BAGCNwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0B
# CQQxFgQUtHsyI/JZoYHF9qlCAIs8SYBjEdYwDQYJKoZIhvcNAQEBBQAEggEACz7x
# iXUIb28xVcIIQzRWjHcRsO2uYVsL0wTmUTbptCTZPs4MyBRgD6ebKxatAdBL2C5B
# SjOLcxaZv8lq1rp+/dDi8O/1UrZuQcCrRfasY3TN40HkcaXGLuVgMpRnA9E4mUAv
# lVGzQywQheOk25kqYu18A0rG5SB4wSMq95ECkcD5pPmGVSSgyDMm/vGVWvSmJGr7
# hGG5n4yeQvEZMtJIDlNDmovtXbl/SR42HZZqCucuXpBG/Or5Q1iGo7ZP2JsiK2mu
# 8AXrn772EG7T5GR0G3vaBIED2sN9+rqgnXKtPlqa/6hj8eQNDi0+4CriTAVd6QPL
# BbWJobdTgTVgiyNlqg==
# SIG # End signature block
