#Requires -RunAsAdministrator
Set-Variable -Name ScriptVersion -Value "v2023.1.06"
$os = Get-CimInstance -ClassName Win32_OperatingSystem
$global:osVersion = $os.Caption

Function Programs() {
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
        DownloadURL = "https://zoom.us/client/5.15.1.17948/ZoomInstallerFull.msi?archType=x64"
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
        # Downloads each program if not found
        If (!(Test-Path -Path:$program.Location)) {
            If (!(Test-Path -Path:$program.Installer)) {
                Get-NetworkStatus
                Write-Status -Types "+", $TweakType -Status "Downloading $($program.Name)"
                Start-BitsTransfer -Source $program.DownloadURL -Destination $program.Installer -TransferType Download -Dynamic
            }

            # Installs UBlock Origin
            Write-Status -Types "+", $TweakType -Status "Installing $($program.Name)"
            If ($($program.Name) -eq "Google Chrome"){
                Start-Process -FilePath $program.Installer -ArgumentList $program.ArgumentList -Wait
                Write-Status "+", $TweakType -Status "Adding UBlock Origin to Google Chrome"
                Set-ItemPropertyVerified -Path "HKLM:\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" -Name "update_url" -value "https://clients2.google.com/service/update2/crx" -Type STRING 
            }Else {
                # Runs Installer setup
                Start-Process -FilePath $program.Installer -ArgumentList $program.ArgumentList
            }
        # Installs hevc/h.265 codec
        If ($($Program.Name) -eq "$VLC.Name"){
            Write-Status -Types "+", $TweakType -Status "Adding support to HEVC/H.265 video codec (MUST HAVE)..."
            Add-AppPackage -Path $HVECCodec -ErrorAction SilentlyContinue
        }
        } else {
            Write-Status -Types "@", $TweakType -Status "$($program.Name) already seems to be installed on this system.. Skipping Installation"
        }
    }
}
Function Visuals() {
    # Sets wallpaper
    Write-Status -Types "+", $TweakType -Status "Applying Wallpaper"
    Write-HostReminder "Wallpaper may not apply until computer is Restarted"
    New-Variable -Name "WallpaperPath" -Value ".\assets\mother.jpg" -Scope Global -Force
    Use-Command "Copy-Item -Path `"$WallpaperPath`" -Destination `"$wallpaperDestination`" -Force"
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name WallpaperStyle -Value "2" -Type String
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper -Value $wallpaperDestination -Type String
    Set-ItemPropertyVerified -Path "$PathToRegPersonalize" -Name "SystemUsesLightTheme" -Value "1" -Type DWord
    Set-ItemPropertyVerified -Path "$PathToRegPersonalize" -Name "AppsUseLightTheme" -Value "1" -Type DWord
    # Triggers a user  system parameter refresh
    Use-Command "Start-Process `"RUNDLL32.EXE`" `"user32.dll, UpdatePerUserSystemParameters`""
    Use-Command "Start-Process `"RUNDLL32.EXE`" `"user32.dll, UpdatePerUserSystemParameters`""
    If ($?) { Write-Status -Types "+", "Visual" -Status "Wallpaper Set`n" } 
    elseif (!$?) { Write-Status -Types "?", "Visual" -Status "Error Applying Wallpaper`n" -Warning}else { }
}
Function Branding() {
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
}

Function StartMenu () {
    $StartLayout = @"
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
        Write-Status -Types "+", $TweakType -Status "Applying Taskbar Layout"
        $layoutFile = "$Env:LOCALAPPDATA\Microsoft\Windows\Shell\LayoutModification.xml"
        If (Test-Path $layoutFile) { Use-Command "Remove-Item `"$layoutFile`"" | Out-Null }
        $StartLayout | Out-File $layoutFile -Encoding ASCII
        Check
        Restart-Explorer
        Start-Sleep -Seconds 4
        Use-Command "Remove-Item `"$layoutFile`""
        If ($osVersion -like "*11*"){
        Write-Section -Text "Applying Start Menu Layout"
        Write-Status -Types "+", $TweakType -Status "Generating Layout File"
        $StartBinDefault = "$Env:SystemDrive\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\"
        $StartBinCurrent = "$Env:userprofile\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState"
        $StartBinFiles = Get-ChildItem -Path ".\assets" -Filter "*.bin" -File
        $TotalBinFiles = $StartBinFiles.Count * 2
        for ($i = 0; $i -lt $StartBinFiles.Count; $i++) {
            $StartBinFile = $StartBinFiles[$i]
            $progress = ($i * 2) + 1
            Write-Status -Types "+", $TweakType -Status "Copying $($StartBinFile.Name) for new users ($progress/$TotalBinFiles)"
            xcopy $StartBinFile.FullName $StartBinDefault /y
            Check
            Write-Status -Types "+", $TweakType -Status "Copying $($StartBinFile.Name) to current user ($($progress+1)/$TotalBinFiles)"
            xcopy $StartBinFile.FullName $StartBinCurrent /y
            Check
        }
        Use-Command "Taskkill /f /im StartMenuExperienceHost.exe" -Suppress
        }elseif ($osVersion -like "*10*"){
            Write-Status -Types "-", $TweakType -Status "Clearing Windows 10 Start Menu Pins"
            ClearStartMenuPinned
        }
}
Function ClearStartMenuPinned() {
    #Requires -RunAsAdministrator
    $START_MENU_LAYOUT = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
    <LayoutOptions StartTileGroupCellWidth="6" />
    <DefaultLayoutOverride>
        <StartLayoutCollection>
            <defaultlayout:StartLayout GroupCellWidth="6" />
        </StartLayoutCollection>
    </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@
    $Global:layoutFile="C:\Windows\StartMenuLayout.xml"
    If(Test-Path $layoutFile){
        Use-Command "Remove-Item `"$layoutFile`"" -Suppress
    }
    $START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII
    $regAliases = @("HKLM", "HKCU")
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemPropertyVerified -Path "$keyPath" -Name "LockedStartLayout" -Value "1" -Type DWord
        Set-ItemPropertyVerified -Path "$keyPath" -Name "StartLayoutFile" -Value "$layoutFile" -Type ExpandString
    }
    Restart-Explorer
    Start-Sleep -Seconds 5
    $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
    Start-Sleep -Seconds 5
    foreach ($regAlias in $regAliases){
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemPropertyVerified -Path "$keyPath" -Name "LockedStartLayout" -Value "0" -Type DWord
    }
    Restart-Explorer
    Use-Command "Remove-Item `"$layoutFile`"" -Suppress
}
Function Find-InstalledPrograms {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$Keyword
    )
    # Construct the registry path for the installed programs list
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    # Retrieve all subkeys under the installed programs registry path
    $installedPrograms = Get-ChildItem -Path $registryPath
    # Filter the installed programs by their display names and descriptions, searching for the specified keyword
    $matchingPrograms = $installedPrograms | Where-Object { 
        ($_.GetValue("DisplayName") -like "*$Keyword*") -or 
        ($_.GetValue("DisplayVersion") -like "*$Keyword*") -or 
        ($_.GetValue("Publisher") -like "*$Keyword*") -or 
        ($_.GetValue("Comments") -like "*$Keyword*") 
    }
    # Output the matching programs as a list of objects with Name, Version, and Publisher properties
    $matchingPrograms | ForEach-Object {
        [PSCustomObject]@{
            Name = $_.GetValue("DisplayName")
            Version = $_.GetValue("DisplayVersion")
            Publisher = $_.GetValue("Publisher")
        }
    }
}
Function Debloat() {

    #McAfee Live Safe Removal
    Write-Caption -Text "McAfee"
    If (Test-Path -Path $livesafe -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of McAfee Live Safe..."
        Use-Command "Start-Process `"$livesafe`""
    }    
    
    #WebAdvisor Removal
    Write-Caption -Text "McAfee WebAdvisor"
    If (Test-Path -Path $webadvisor -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of McAfee WebAdvisor Uninstall."
        Use-Command "Start-Process `"$webadvisor`""
    }
    
    #Preinsatlled on Acer machines primarily WildTangent Games
    Write-Caption -Text "WildTangent Games"
    If (Test-Path -Path $WildGames -ErrorAction SilentlyContinue | Out-Null) {
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal WildTangent Games."
        Use-Command "Start-Process `"$WildGames`""
    }
    
    #Norton cuz LUL Norton
    Write-Caption -Text "Norton x86"
    $Global:NortonPath = "C:\Program Files (x86)\NortonInstaller"
    $Global:CheckNorton = Get-ChildItem -Path $NortonPath -Name "InstStub.exe" -Recurse -ErrorAction SilentlyContinue
    If ($CheckNorton) {
        New-Variable -Name "Norton" -Value "$NortonPath\$CheckNorton" -Scope Global -Force
        Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Detected and Attemping Removal of Norton..."
        Use-Command "Start-Process `"$Norton`" -ArgumentList `"/X /ARP`""
    }
    
    #Avast Cleanup Premium
    Write-Caption -Text "Avast Cleanup"
    $Global:AvastCleanupLocation = "C:\Program Files\Common Files\Avast Software\Icarus\avast-tu\icarus.exe"
    If (Test-Path $AvastCleanupLocation) {
        Use-Command "Start-Process `"$AvastCleanupLocation`" -ArgumentList `"/manual_update /uninstall:avast-tu`""
    }
    
    #Avast Antivirus
    Write-Caption -Text "Avast AV"
    $Global:AvastLocation = "C:\Program Files\Avast Software\Avast\setup\Instup.exe"
    If (Test-Path $AvastLocation) {
        Use-Command "Start-Process `"$AvastLocation`" -ArgumentList `"/control_panel`""
    }
    
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
        If (Test-Path -Path "$commonapps\$app.url") {
            Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Removing $app.url"
            Use-Command "Remove-Item -Path `"$commonapps\$app.url`" -Force"
        }
        If (Test-Path -Path "$commonapps\$app.lnk") {
            Write-Status -Types "-", "$TweakType" , "$TweakTypeLocal" -Status "Removing $app.lnk"
            Use-Command "Remove-Item -Path `"$commonapps\$app.lnk`" -Force"
        }
    }

    # UWP Apps
    Write-Section -Text "Checking for UWP Apps"
    $TotalItems = $Programs.Count
    $CurrentItem = 0
    $PercentComplete = 0
    ForEach($Program in $Programs){
    Write-Progress -Activity "Debloating System" -Status " $PercentComplete% Complete:" -PercentComplete $PercentComplete | Out-Host
    Remove-UWPAppx -AppxPackages $Program
    $CurrentItem++
    $PercentComplete = [int](($CurrentItem / $TotalItems) * 100)
    }

    # Debloat Completion
    Write-Host "Debloat Completed!`n" -Foregroundcolor Green
    Write-Host "Packages Removed: " -NoNewline -ForegroundColor Gray ; Write-Host "$Removed" -ForegroundColor Green
    If ($Failed){ Write-Host "Failed: " -NoNewline -ForegroundColor Gray ; Write-Host "$Failed" -ForegroundColor Red }
    Write-Host "Packages Scanned For: " -NoNewline -ForegroundColor Gray ; Write-Host "$NotFound`n" -ForegroundColor Yellow
    Start-Sleep -Seconds 4
}
Function BitlockerDecryption() {
    # Checks if Bitlocker is active on host
    If ((Get-BitLockerVolume -MountPoint "C:" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue).ProtectionStatus -eq "On") {
        # Starts Bitlocker Decryption
        Write-CaptionWarning -Text "Alert: Bitlocker is enabled. Starting the decryption process"
        Use-Command 'Disable-Bitlocker -MountPoint C:\'
    } else { Write-Status -Types "?" -Status "Bitlocker is not enabled on this machine" -Warning }
}
Function Cleanup() {
    # Starts Explorer if it isn't already running
    If (!(Get-Process -Name Explorer)){ Restart-Explorer }
    # Enables F8 Boot Menu 
    Write-Status -Types "+" , $TweakType -Status "Enabling F8 boot menu options"
    Use-Command "bcdedit /set `"{CURRENT}`" bootmenupolicy standard"
    # Launches Chrome to initiate UBlock Origin
    Write-Status -Types "+", $TweakType -Status "Launching Google Chrome"
    Use-Command "Start-Process Chrome -ErrorAction SilentlyContinue -WarningAction SilentlyContinue" -Suppress
    # Clears Temp Folder
    Write-Status -Types "-", $TweakType -Status "Cleaning Temp Folder"
    Use-Command "Remove-Item `"$env:Userprofile\AppData\Local\Temp\*.*`" -Force -Recurse -Confirm:$false -Exclude `"New Loads`" -ErrorAction SilentlyContinue" -Suppress
    # Removes installed program shortcuts from Public/User Desktop
    foreach ($shortcut in $shortcuts){
        Write-Status -Types "-", $TweakType -Status "Removing $shortcut"
        Use-Command "Remove-Item -Path `"$shortcut`" -Force" -Suppress
    }
}
Function ADWCleaner() {
    # Checks if executable exists
    If (!(Test-Path ".\bin\adwcleaner.exe")){
        Write-Status -Types "+","ADWCleaner" -Status "Downloading ADWCleaner"
        # Downloads adw
        Use-Command "Start-BitsTransfer -Source `"$adwLink`" -Destination `"$adwDestination`""
    }
    Write-Status -Types "+","ADWCleaner" -Status "Starting ADWCleaner with ArgumentList /Scan & /Clean"
    # Runs ADW
    Use-Command "Start-Process -FilePath `"$adwDestination`" -ArgumentList `"/EULA`",`"/PreInstalled`",`"/Clean`",`"/NoReboot`" -Wait -NoNewWindow"
    Write-Status -Types "-","ADWCleaner" -Status "Removing traces of ADWCleaner"
    # Removes traces of adw from system
    Use-Command "Start-Process -FilePath `"$adwDestination`" -ArgumentList `"/Uninstall`",`"/NoReboot`" -WindowStyle Minimized"
}
Function CreateRestorePoint() {
    Write-Status -Types "+", $TweakType -Status "Enabling system drive Restore Point..."
    # Assures System Restore is enabled
    Use-Command "Enable-ComputerRestore -Drive `"$env:SystemDrive\`""
    # Creates a System Restore point
    Use-Command 'Checkpoint-Computer -Description "Mother Computers Courtesy Restore Point" -RestorePointType "MODIFY_SETTINGS"'
}
Function EmailLog() {
    Stop-Transcript
    Write-Section -Text "Gathering Logs "
    Write-Caption -Text "System Statistics"
    # Current time 
    $EndTime = Get-Date -DisplayHint Time
    $ElapsedTime = $EndTime - $StartTime
    # Current Date and Time
    $CurrentDate = Get-Date
    # Resolves Public IP of host system
    $IP = $(Resolve-DnsName -Name myip.opendns.com -Server 208.67.222.220).IPAddress
    # Motherboard
    $Mobo = (Get-CimInstance -ClassName Win32_BaseBoard).Product
    # CPU
    $CPU = Get-CPU
    # RAM
    $RAM = Get-RAM
    # GPU
    $GPU = Get-GPU
    # Windows letter version (21H1,22H2)
    $Displayversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "DisplayVersion").DisplayVersion
    # Windows version
    $WindowsVersion = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
    # Drive type
    $SSD = Get-OSDriveType
    # Free Space
    $DriveSpace = Get-DriveSpace

    # Gathers computer info appending to log
    Get-ComputerInfo | Out-File -Append $log -Encoding ascii
    [String]$SystemSpec = Get-SystemSpec
    $SystemSpec | Out-Null


    <#  
    Here's how this script works:
    The script removes unwanted characters from the variable $logFile and eliminates empty lines from the 
    variable $newLogFile by filtering out lines without non-whitespace characters and joining the remaining lines.
    #>
    Write-Caption -Text "Cleaning $Log"
    # Read the contents of the log file into a variable
    $logFile = Get-Content $Log
    # Define a regular expression pattern to match the unwanted characters
    $pattern = "[\[\]><\+@),|=]"
    # Replace the unwanted characters with nothing
    $newLogFile = $logFile -replace $pattern
    # Remove empty lines
    $newLogFile = ($newLogFile | Where-Object { $_ -match '\S' }) -join "`n"
    # Overwrite the log file with the new contents
    Set-Content -Path $Log -Value $newLogFile

    # Cleans up Motherboards Output
    Write-Caption -Text "Generating New Loads Summary"
    If ($CurrentWallpaper -eq $Wallpaper) { $WallpaperApplied = "YES" }Else { $WallpaperApplied = "NO" }
    $TempFile = "$Env:Temp\tempmobo.txt" ; $Mobo | Out-File $TempFile -Encoding ASCII
    (Get-Content $TempFile).replace('Product', '') | Set-Content $TempFile
    (Get-Content $TempFile).replace("  ", '') | Set-Content $TempFile
    $Mobo = Get-Content $TempFile
    Remove-Item $TempFile

    # Checks if all the programs got installed
    $CheckChrome = Find-InstalledPrograms -Keyword "Google Chrome"
    If (!$CheckChrome){ $ChromeYN = "NO" } Else { $ChromeYN = "YES" }
    $CheckVLC = Find-InstalledPrograms -Keyword "VLC"
    If (!$CheckVLC){ $VLCYN = "NO" } Else { $VLCYN = "YES" }
    $CheckZoom = Find-InstalledPrograms -Keyword "Zoom"
    If (!$CheckZoom){ $ZoomYN = "NO" } Else { $ZoomYN = "YES" }
    $CheckAcrobat = Find-InstalledPrograms -Keyword "Acrobat"
    If (!$CheckAcrobat){ $AdobeYN = "NO"} Else { $AdobeYN = "YES"}

    $LogFiles = @()
    if (Test-Path -Path ".\Log.txt") {
    $LogFiles += ".\Log.txt"
    }
    if (Test-Path -Path ".\ErrorLog.txt") {
    $LogFiles += ".\ErrorLog.txt"
    }

    # Converts the array into a neat string 
    $packagesRemovedString = $packagesRemoved -join "`n - "

    
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

- Script Information:
    - Date: $CurrentDate
    - Elapsed Time: $ElapsedTime
    - Start Time: $StartTime
    - End Time: $EndTime
    - Program Version: $ProgramVersion
    - Script Version: $ScriptVersion

- Computer Information:
    - CPU: $CPU
    - Motherboard: $Mobo
    - RAM: $RAM
    - GPU: $GPU
    - SSD: $SSD
    - Drive Space: $DriveSpace free
    - OS: $WindowsVersion ($DisplayVersion)

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
    $PackagesRemovedstring
"

    Write-Caption -Text "Sending log + hardware info home"
    Send-MailMessage -From $From -To $To -Subject $Sub -Body $EmailBody -Attachments $LogFiles -DN OnSuccess, OnFailure -SmtpServer $smtp -EA SilentlyContinue 
    Send-BackupHome
}
Function Request-PcRestart() {
    switch (Show-YesNoCancelDialog -YesNoCancel -Message "Would you like to reboot the system now? ") {
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
If (!($GUI)) {
Start-Transcript -Path $Log
$StartTime = Get-Date -DisplayHint Time
Set-ScriptStatus -Counter 1 -WindowTitle "Apps" -TweakType "Apps" -Title $True -TitleText "Programs" -Section $True -SectionText "Application Installation" 
Programs
Set-ScriptStatus -Counter 2 -WindowTitle "Visual" -TweakType "Visuals" -Title $True -TitleText "Visuals"
Visuals
Set-ScriptStatus -Counter 3 -WindowTitle "Branding" -TweakType "Branding" -Section $True -SectionText "Branding" -Title $True -TitleText "Mother Computers Branding"
Branding
Set-ScriptStatus -Counter 4 -WindowTitle "Start Menu" -TweakType "StartMenu" -Title $True -TitleText "Start Menu Layout" -Section $True -SectionText "Applying Taskbar Layout" 
StartMenu
Set-ScriptStatus -Counter 5 -WindowTitle "Debloat" -TweakType "Debloat" -Title $True -TitleText "Debloat" -Section $True -SectionText "Checking for Win32 Pre-Installed Bloat" 
Debloat
Set-ScriptStatus -Section $True -SectionText "ADWCleaner"
AdwCleaner
Set-ScriptStatus -Counter 6 -WindowTitle "Office" -TweakType "Office" -Title $True -TitleText "Office Removal" 
OfficeCheck
Set-ScriptStatus -Counter 7 -WindowTitle "Optimization" -TweakType "Registry" -Title $True -TitleText "Optimization"
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
Set-ScriptStatus -Counter 8 -WindowTitle "Bitlocker" -TweakType "Bitlocker" -Title $True -TitleText "Bitlocker Decryption" 
BitlockerDecryption
Set-ScriptStatus -Counter 9 -WindowTitle "Restore Point" -TweakType "Backup" -Title $True -TitleText "Creating Restore Point" 
CreateRestorePoint
Set-ScriptStatus -Counter 10 -WindowTitle "Email Log" -TweakType "Email" -Title $True -TitleText "Email Log"
EmailLog
Set-ScriptStatus -Counter 11 -WindowTitle "Cleanup" -TweakType "Cleanup" -Title $True -TitleText "Cleanup" -Section $True -SectionText "Cleaning Up" 
Cleanup
Write-Status -Types "WAITING" -Status "User action needed - You may have to ALT + TAB "
Request-PCRestart
}
else {
Clear-Host
Write-Host "GUI is currently disabled, try running without -GUI"
EXIT
#
#Get-NetworkStatus
#GUI
}



# SIG # Begin signature block
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU4/SQ3n3qRuYzUcLfD0CvgJhX
# IKmgggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFDeDpwUSM/wej1jG/xKFcQQlYuzWMA0GCSqGSIb3DQEB
# AQUABIIBAJSdN+89e/LNAtceW1N0Fu1dFhfM5zVGK7RhmEejaqjW2oso/6SXa9LX
# pfMI6sGtrIIyWTwZ9gaeum99hVcGEYO91dH7optCqzepP8KTN7im11vVgF8DOMbq
# T4Nb8fftIBHgqUzGRXPtPVOwJ6/hnMLxeTcfO/h2DB5v1bJo6GY7VADgPpERjdSs
# fO5LzJwY3jlRt69M/wyYv+fV81V+X1kp959bB5i7qHSsdlYC5X8NtSFK0RyzdNz4
# aPWRpkzlWU2q20xf/k5hsqX1JlYYuUANQuzj39X17A4VIKVXwcIDppPKoJBzFtLr
# RAgah5PUXZgb3oioGgs+LCONRsQ/4Ws=
# SIG # End signature block
