Function Variables2 () {
New-Variable -Name "Package1" -Value "googlechromestandaloneenterprise64.msi" -Option ReadOnly -Scope Global -Force
New-Variable -Name "Package2" -Value "vlc-3.0.17-win64.msi" -Option ReadOnly -Scope Global -Force 
New-Variable -Name "Package3" -Value "ZoomInstallerFull.msi" -Option ReadOnly -Scope Global -Force
New-Variable -Name "Package4" -Value "AcroRdrDCx642200120085_MUI.exe" -Option ReadOnly -Scope Global -Force
New-Variable -Name "oi" -Value ".\bin" -Option ReadOnly -Scope Global -Force
#Offline installer locations
New-Variable -Name "Location1" -Value "$Env:PROGRAMFILES\Google\Chrome\Application\chrome.exe" -Option ReadOnly -Scope Global -Force
New-Variable -Name "Location2" -Value "$Env:PROGRAMFILES\VideoLAN\VLC\vlc.exe" -Option ReadOnly -Scope Global -Force
New-Variable -Name "Location3" -Value "$Env:PROGRAMFILES\Zoom\bin\Zoom.exe" -Option ReadOnly -Scope Global -Force
New-Variable -Name "Location4" -Value "${Env:Programfiles(x86)}\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe" -Option ReadOnly -Scope Global -Force
New-Variable -Name "Location5" -Value "C:\Windows\SysWOW64\OneDriveSetup.exe" -Option ReadOnly -Scope Global -Force
#Offline installer package location
New-Variable -Name "Package1lc" -Value "$oi\$package1" -Option ReadOnly -Scope Global -Force
New-Variable -Name "Package2lc" -Value "$oi\$package2" -Option ReadOnly -Scope Global -Force
New-Variable -Name "Package3lc" -Value "$oi\$package3" -Option ReadOnly -Scope Global -Force
New-Variable -Name "Package4lc" -Value "$oi\$package4" -Option ReadOnly -Scope Global -Force
New-Variable -Name "OneDriveLocation" -Value "$Env:SystemRoot\SysWOW64\OneDriveSetup.exe" -Option ReadOnly -Scope Global -Force
#download links
New-Variable -Name "Package1dl" -Value "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi" -Option ReadOnly -Scope Global -Force
New-Variable -Name "Package2dl" -Value "https://get.videolan.org/vlc/3.0.17.4/win64/vlc-3.0.17.4-win64.msi" -Option ReadOnly -Scope Global -Force
New-Variable -Name "Package3dl" -Value "https://zoom.us/client/5.11.4.7185/ZoomInstallerFull.msi?archType=x64" -Option ReadOnly -Scope Global -Force
New-Variable -Name "Package4dl" -Value "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2200120169/AcroRdrDC2200120169_en_US.exe" -Option ReadOnly -Scope Global -Force
#Offline installers
New-Variable -Name "gcoi" -Value ".\bin\$package1" -Option ReadOnly -Scope Global -Force
New-Variable -Name "vlcoi" -Value ".\bin\$package2" -Option ReadOnly -Scope Global -Force
New-Variable -Name "zoomoi" -Value ".\bin\$package3" -Option ReadOnly -Scope Global -Force
New-Variable -Name "aroi" -Value ".\bin\$package4" -Option ReadOnly -Scope Global -Force
#Bloat
New-Variable -Name "livesafe" -Value "$Env:PROGRAMFILES\McAfee\MSC\mcuihost.exe" -Option ReadOnly -Scope Global -Force
New-Variable -Name "webadvisor" -Value "$Env:PROGRAMFILES\McAfee\WebAdvisor\Uninstaller.exe" -Option ReadOnly -Scope Global -Force
New-Variable -Name "WildGames" -Value "${Env:PROGRAMFILES(x86)}\WildGames\Uninstall.exe" -Option ReadOnly -Scope Global -Force
#shortcuts
New-Variable -Name "EdgeShortcut" -Value "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk" -Option ReadOnly -Scope Global -Force
New-Variable -Name "acrosc" -Value "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk" -Option ReadOnly -Scope Global -Force
New-Variable -Name "edgescpub" -Value "$Env:PUBLIC\Desktop\Microsoft Edge.lnk" -Option ReadOnly -Scope Global -Force
New-Variable -Name "vlcsc" -Value "$Env:PUBLIC\Desktop\VLC Media Player.lnk" -Option ReadOnly -Scope Global -Force
New-Variable -Name "zoomsc" -Value "$Env:PUBLIC\Desktop\Zoom.lnk" -Option ReadOnly -Scope Global -Force

New-Variable -Name "commonapps" -Value "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs" -Option ReadOnly -Scope Global -Force
#Wallpaper
New-Variable -Name "wallpaper" -Value "$env:appdata\Microsoft\Windows\Themes\MotherComputersWallpaper.jpg" -Option ReadOnly -Scope Global -Force
New-Variable -Name "currentwallpaper" -Value (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper).Wallpaper -Option ReadOnly -Scope Global -Force
New-Variable -Name "sysmode" -Value (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name SystemUsesLightTheme).SystemUsesLightTheme -Option ReadOnly -Scope Global -Force
New-Variable -Name "appmode" -Value (Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme).AppsUseLightTheme -Option ReadOnly -Scope Global -Force
#Office Removal
New-Variable -Name "PathToOffice86" -Value "C:\Program Files (x86)\Microsoft Office" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToOffice64" -Value "C:\Program Files\Microsoft Office 15" -Option ReadOnly -Scope Global -Force
New-Variable -Name "officecheck" -Value "$false" -Option ReadOnly -Scope Global -Force
New-Variable -Name "office32" -Value "$false" -Option ReadOnly -Scope Global -Force
New-Variable -Name "office64" -Value "$false" -Option ReadOnly -Scope Global -Force
New-Variable -Name "SaRA" -Value "$newloads\SaRA.zip" -Option ReadOnly -Scope Global -Force
New-Variable -Name "Sexp" -Value "$newloads\SaRA" -Option ReadOnly -Scope Global -Force
#Reg
New-Variable -Name "PathToChromeExtensions" -Value "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToChromeLink" -Value "https://clients2.google.com/service/update2/crx" -Option ReadOnly -Scope Global -Force
New-Variable -Name "siufrules" -Value "HKCU:\Software\Microsoft\Siuf\Rules" -Option ReadOnly -Scope Global -Force
New-Variable -Name "lfsvc" -Value "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Option ReadOnly -Scope Global -Force
New-Variable -Name "wifisense" -Value "HKLM:\Software\Microsoft\PolicyManager\default\WiFi" -Option ReadOnly -Scope Global -Force
New-Variable -Name "regcam" -Value "HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToRegExplorerLocalMachine" -Value "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToRegSystem" -Value "HKLM:\Software\Policies\Microsoft\Windows\System" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToRegInputPersonalization" -Value "HKCU:\Software\Microsoft\InputPersonalization" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToRegCurrentVersion" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToRegContentDelivery" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToRegExplorer" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToRegExplorerAdv" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToRegAdvertising" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToRegPersonalize" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToRegSearch" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Option ReadOnly -Scope Global -Force
# Initialize all Path variables used to Registry Tweaks
New-Variable -Name "PathToLMActivityHistory" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToLMAutoLogger" -Value "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger" -Option ReadOnly -Scope Global -Force
#$PathToLMDeliveryOptimizationCfg = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"
New-Variable -Name "PathToLMPoliciesAdvertisingInfo" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToLMPoliciesCloudContent" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToLMPoliciesSQMClient" -Value "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToLMPoliciesTelemetry" -Value "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToLMPoliciesTelemetry2" -Value "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToLMPoliciesToWifi" -Value "HKLM:\Software\Microsoft\PolicyManager\default\WiFi" -Option ReadOnly -Scope Global -Force
#$PathToLMPoliciesWindowsUpdate = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
New-Variable -Name "PathToLMWindowsTroubleshoot" -Value "HKLM:\SOFTWARE\Microsoft\WindowsMitigation" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToCUContentDeliveryManager" -Value "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToCUDeviceAccessGlobal" -Value "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToCUInputPersonalization" -Value "HKCU:\SOFTWARE\Microsoft\InputPersonalization" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToCUInputTIPC" -Value "HKCU:\SOFTWARE\Microsoft\Input\TIPC" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToCUOnlineSpeech" -Value "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToCUPoliciesCloudContent" -Value "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToCUSearch" -Value "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToCUSiufRules" -Value "HKCU:\SOFTWARE\Microsoft\Siuf\Rules" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToVoiceActivation" -Value "HKCU:\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" -Option ReadOnly -Scope Global -Force
New-Variable -Name "PathToBackgroundAppAccess" -Value "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Option ReadOnly -Scope Global -Force
}