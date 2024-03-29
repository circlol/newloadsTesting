﻿###############################################
#                 New Loads                   #
###############################################
<#
.NOTES
    Author         : @Circlol
    GitHub         : https://github.com/Circlol/newload
    Version        : 1.07
    Release        : Sept 21st, 2023

#>

$WindowTitle = "New Loads"
$host.UI.RawUI.WindowTitle = $WindowTitle
$host.UI.RawUI.ForegroundColor = 'White'
$host.UI.RawUI.BackgroundColor = 'Black'
Clear-Host
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
filter TimeStamp { "$(Get-Date -Format g)- $_" }
$ErrorActionPreference = "SilentlyContinue"
$NewLoads = "$env:temp"
$Variables = @{
    "Logo"                                       = "
                    ███╗   ██╗███████╗██╗    ██╗    ██╗      ██████╗  █████╗ ██████╗ ███████╗
                    ████╗  ██║██╔════╝██║    ██║    ██║     ██╔═══██╗██╔══██╗██╔══██╗██╔════╝
                    ██╔██╗ ██║█████╗  ██║ █╗ ██║    ██║     ██║   ██║███████║██║  ██║███████╗
                    ██║╚██╗██║██╔══╝  ██║███╗██║    ██║     ██║   ██║██╔══██║██║  ██║╚════██║
                    ██║ ╚████║███████╗╚███╔███╔╝    ███████╗╚██████╔╝██║  ██║██████╔╝███████║
                    ╚═╝  ╚═══╝╚══════╝ ╚══╝╚══╝     ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═════╝ ╚══════╝`n"
    "errorMessage1"                              = "
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
    "errorMessage2"                              = "
        @|\@@                                                                                    `
        -  @@@@                             New Loads REQUIRES administrative privileges         `
       /7   @@@@                                                                                 `
      /    @@@@@@                             for core features to function correctly.           `
      \-' @@@@@@@@`-_______________                                                              `
       -@@@@@@@@@             /    \                                                             `
  _______/    /_       ______/      |__________-                          /\_____/\              `
 /,__________/  `-.___/,_____________----------_)                Meow.    /  o   o  \            `
                                                                        ( ==  ^  == )            `
                                                                         )         (             `
                                                                        (           )            `
                                                                       ( (  )   (  ) )           `
                                                                      (__(__)___(__)__)          `n`n"
    "ForegroundColor"                            = "DarkMagenta"
    "BackgroundColor"                            = "Black"
    "LogoColor"                                  = "DarkMagenta"
    "ProgramVersion"                             = "v1.07.02"
    "ReleaseDate"                                = "September 21st"
    "Time"                                       = Get-Date -UFormat %Y%m%d
    "MinTime"                                    = 20230630
    "MaxTime"                                    = 20231031
    "Counter"                                    = 1
    "SelectedParameters"                         = @()
    "temp"                                       = $Env:temp
    "MaxLength"                                  = "10"
    "Win11"                                      = "22000"
    "Win22H2"                                    = "22621"
    "MinimumBuildNumber"                         = "19042"
    "OSVersion"                                  = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
    "BuildNumber"                                = [System.Environment]::OSVersion.Version.Build
    "Connected"                                  = "Internet"
    # Local File Paths
    "WallpaperDestination"                       = "C:\Windows\Resources\Themes\mother.jpg"
    "WallpaperPath"                              = "$NewLoads\mother.jpg"
    "ErrorLog"                                   = "$env:userprofile\Desktop\New Loads Errors.txt"
    "Log"                                        = "$env:userprofile\Desktop\New Loads.txt"
    "adwDestination"                             = "$NewLoads\adwcleaner.exe"
    "SaRA"                                       = "$newloads\SaRA.zip"
    "Sexp"                                       = "$newloads\SaRA"
    "SaRAURL"                                    = "https://github.com/circlol/newload/raw/main/SaRACmd_17_01_0495_021.zip"
    "StartBinURL"                                = "https://github.com/circlol/newload/raw/main/assets/start.bin"
    "StartBin2URL"                               = "https://github.com/circlol/newload/raw/main/assets/start2.bin"
    "PackagesRemoved"                            = @()
    "Removed"                                    = 0
    "Failed"                                     = 0
    "NotFound"                                   = 0
    "StartBinDefault"                            = "$Env:SystemDrive\Users\Default\AppData\Local\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState\"
    "StartBinCurrent"                            = "$Env:LocalAppData\Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState"
    "LayoutFile"                                 = "$Env:LocalAppData\Microsoft\Windows\Shell\LayoutModification.xml"
    "adwLink"                                    = "https://github.com/circlol/newload/raw/main/adwcleaner.exe"
    "livesafe"                                   = "$Env:PROGRAMFILES\McAfee\MSC\mcuihost.exe"
    "WebAdvisor"                                 = "$Env:PROGRAMFILES\McAfee\WebAdvisor\Uninstaller.exe"
    "WildGames"                                  = "${Env:PROGRAMFILES(x86)}\WildGames\Uninstall.exe"
    #New-Variable -Name "AcroSC" = "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk"
    "EdgeShortcut"                               = "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
    "AcroSC"                                     = "$Env:PUBLIC\Desktop\Acrobat Reader DC.lnk"
    "EdgeSCPub"                                  = "$Env:PUBLIC\Desktop\Microsoft Edge.lnk"
    "VLCSC"                                      = "$Env:PUBLIC\Desktop\VLC Media Player.lnk"
    "ZoomSC"                                     = "$Env:PUBLIC\Desktop\Zoom.lnk"
    "CommonApps"                                 = "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs"
    #Wallpaper
    #New-Variable -Name "Wallpaper" = "$env:appdata\Microsoft\Windows\Themes\MotherComputersWallpaper.jpg"
    "CurrentWallpaper"                           = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name Wallpaper).Wallpaper
    #Office Removal
    "PathToOffice86"                             = "${env:ProgramFiles(x86)}\Microsoft Office"
    "PathToOffice64"                             = "$env:ProgramFiles\Microsoft Office 15"
    "OfficeCheck"                                = "$false"
    "Office32"                                   = "$false"
    "Office64"                                   = "$false"
    "UsersFolder"                                = "{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
    "ThisPC"                                     = "{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
    "PathToUblockChrome"                         = "HKLM:\SOFTWARE\Wow6432Node\Google\Chrome\Extensions\cjpalhdlnbpafiamejdnhcphjbkeiagm"
    "PathToChromeLink"                           = "https://clients2.google.com/service/update2/crx"
    "PathToLFSVC"                                = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
    "RegCAM"                                     = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"
    "TimeoutScreenBattery"                       = 5
    "TimeoutScreenPluggedIn"                     = 10
    "TimeoutStandByBattery"                      = 15
    "TimeoutStandByPluggedIn"                    = 30
    "TimeoutDiskBattery"                         = 15
    "TimeoutDiskPluggedIn"                       = 30
    "TimeoutHibernateBattery"                    = 15
    "TimeoutHibernatePluggedIn"                  = 30
    "PathToUsersControlPanelDesktop"             = "Registry::HKEY_USERS\.DEFAULT\Control Panel\Desktop"
    "PathToCUControlPanelDesktop"                = "HKCU:\Control Panel\Desktop"
    "PathToCUGameBar"                            = "HKCU:\SOFTWARE\Microsoft\GameBar"
    "PathToGraphicsDrives"                       = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
    "PathToOEMInfo"                              = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"
    "PathToRegExplorerLocalMachine"              = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
    "PathToRegCurrentVersion"                    = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion"
    "PathToRegAdvertising"                       = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
    "PathToRegPersonalize"                       = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    "PathToPrivacy"                              = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy"

    # Initialize all Path variables used to Registry Tweaks
    "PathToLMActivityHistory"                    = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
    "PathToLMAutoLogger"                         = "HKLM:\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger"
    "PathToLMControl"                            = "HKLM:\SYSTEM\CurrentControlSet\Control"
    #"PathToLMCurrentVersion" = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    "PathToLMConsentStoreUAI"                    = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation"
    "PathToLMConsentStoreUN"                     = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userNotificationListener"
    "PathToLMConsentStoreAD"                     = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics"
    "PathToLMDeviceMetaData"                     = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata"
    "PathToLMDriverSearching"                    = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching"
    "PathToLMEventKey"                           = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack\EventTranscriptKey"
    "PathToLMLanmanServer"                       = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
    "PathToLMMemoryManagement"                   = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
    "PathToLMNdu"                                = "HKLM:\SYSTEM\ControlSet001\Services\Ndu"
    #$PathToLMDeliveryOptimizationCfg = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config"
    "PathToLMPoliciesAdvertisingInfo"            = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo"
    "PathToLMPoliciesAppCompact"                 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat"
    "PathToLMPoliciesCloudContent"               = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    "PathToLMPoliciesEdge"                       = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"
    "PathToLMPoliciesExplorer"                   = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
    "PathToLMPoliciesMRT"                        = "HKLM:\SOFTWARE\Policies\Microsoft\MRT"
    "PathToLMPoliciesPsched"                     = "HKLM:\SOFTWARE\Policies\Microsoft\Psched"
    "PathToLMPoliciesSQMClient"                  = "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows"
    "PathToLMPoliciesTelemetry"                  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    "PathToLMPoliciesTelemetry2"                 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
    "PathToLMPoliciesToWifi"                     = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi"
    "PathToLMPoliciesWindowsStore"               = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
    "PathToLMPoliciesSystem"                     = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    "PathToLMOldDotNet"                          = "HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319"
    "PathToLMWowNodeOldDotNet"                   = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v4.0.30319"
    #$PathToLMPoliciesWindowsUpdate = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    "PathToLMWindowsTroubleshoot"                = "HKLM:\SOFTWARE\Microsoft\WindowsMitigation"
    "PathToCUAccessibility"                      = "HKCU:\Control Pane\Accessibility"
    "PathToCUAppHost"                            = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost"
    "PathToCUContentDeliveryManager"             = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    "PathToCUConsentStoreAD"                     = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics"
    "PathToCUConsentStoreUAI"                    = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation"
    "PathToCUDeviceAccessGlobal"                 = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global"
    "PathToCUExplorer"                           = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
    "PathToCUExplorerAdvanced"                   = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    "PathToCUInputPersonalization"               = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
    "PathToCUInputTIPC"                          = "HKCU:\SOFTWARE\Microsoft\Input\TIPC"
    "PathToCUMouse"                              = "HKCU:\Control Panel\Mouse"
    "PathToCUFeedsDSB"                           = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB"
    "PathToCUOnlineSpeech"                       = "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy"
    "PathToCUPersonalization"                    = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
    "PathToCUPoliciesCloudContent"               = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    "PathToCUSearch"                             = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
    "PathToCUSearchSettings"                     = "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings"
    "PathToCUSiufRules"                          = "HKCU:\SOFTWARE\Microsoft\Siuf\Rules"
    "PathToCUUserProfileEngagemment"             = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement"
    "PathToCUUP"                                 = "HKCU:\Control Panel\International\User Profile"
    "PathToVoiceActivation"                      = "HKCU:\SOFTWARE\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps"
    "PathToBackgroundAppAccess"                  = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"
    "PathToLMMultimediaSystemProfile"            = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    "PathToLMMultimediaSystemProfileOnGameTasks" = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
    "KeysToDelete"                               = @(
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

    # - Shortcuts
    "Shortcuts"                                  = @(
        "$Env:USERPROFILE\Desktop\Microsoft Edge.lnk"
        "$Env:PUBLIC\Desktop\Microsoft Edge.lnk"
        "$Env:PUBLIC\Desktop\Adobe Reader.lnk"
        "$Env:PUBLIC\Desktop\Adobe Reader DC.lnk"
        "$Env:PUBLIC\Desktop\Adobe Acrobat DC.lnk"
        "$Env:PUBLIC\Desktop\Acrobat Reader DC.lnk"
        "$Env:PUBLIC\Desktop\VLC Media Player.lnk"
        "$Env:PUBLIC\Desktop\Zoom.lnk"
    )
    "CloudContentDisableOnOne"                   = @(
        "DisableWindowsSpotlightFeatures"
        "DisableWindowsSpotlightOnActionCenter"
        "DisableWindowsSpotlightOnSettings"
        "DisableWindowsSpotlightWindowsWelcomeExperience"
        "DisableTailoredExperiencesWithDiagnosticData"      # Tailored Experiences
        "DisableThirdPartySuggestions"
    )
    # - Scheduled Tasks
    # Adapted from: https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/rds-vdi-recommendations#task-scheduler
    "EnableScheduledTasks"                       = @(
        "\Microsoft\Windows\Defrag\ScheduledDefrag"                 # Defragments all internal storages connected to your computer
        "\Microsoft\Windows\Maintenance\WinSAT"                     # WinSAT detects incorrect system configurations, that causes performance loss, then sends it via telemetry | Reference (PT-BR): https://youtu.be/wN1I0IPgp6U?t=16
        "\Microsoft\Windows\RecoveryEnvironment\VerifyWinRE"        # Verify the Recovery Environment integrity, it's the Diagnostic tools and Troubleshooting when your PC isn't healthy on BOOT, need this ON.
        "\Microsoft\Windows\Windows Error Reporting\QueueReporting" # Windows Error Reporting event, needed to improve compatibility with your hardware
    )
    "DisableScheduledTasks"                      = @(
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
        "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"                   # Recommended state for VDI use
        "\Microsoft\Windows\Retail Demo\CleanupOfflineContent"                            # Recommended state for VDI use
        "\Microsoft\Windows\Shell\FamilySafetyMonitor"                                    # Recommended state for VDI use
        "\Microsoft\Windows\Shell\FamilySafetyRefreshTask"                                # Recommended state for VDI use
        "\Microsoft\Windows\Shell\FamilySafetyUpload"
        "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary"                          # Recommended state for VDI use
    )
    #"IsSystemDriveSSD" = $(Get-OSDriveType) -eq "SSD"
    # - Services
    "EnableServicesOnSSD"                        = @("SysMain", "WSearch", "fhsvc")
    # Services which will be totally disabled
    "ServicesToDisabled"                         = @(
        "DiagTrack"                                 # DEFAULT: Automatic | Connected User Experiences and Telemetry
        "diagnosticshub.standardcollector.service"  # DEFAULT: Manual    | Microsoft (R) Diagnostics Hub Standard Collector Service
        "dmwappushservice"                          # DEFAULT: Manual    | Device Management Wireless Application Protocol (WAP)
        "GraphicsPerfSvc"                           # DEFAULT: Manual    | Graphics performance monitor service
        "HomeGroupListener"                         # NOT FOUND (Win 10+)| HomeGroup Listener
        "HomeGroupProvider"                         # NOT FOUND (Win 10+)| HomeGroup Provider
        "lfsvc"                                     # DEFAULT: Manual    | Geolocation Service
        "MapsBroker"                                # DEFAULT: Automatic | Downloaded Maps Manager
        "PcaSvc"                                    # DEFAULT: Automatic | Program Compatibility Assistant (PCA)
        "RemoteAccess"                              # DEFAULT: Disabled  | Routing and Remote Access
        "RemoteRegistry"                            # DEFAULT: Disabled  | Remote Registry
        "RetailDemo"                                # DEFAULT: Manual    | The Retail Demo Service controls device activity while the device is in retail demo mode.
        "TrkWks"                                    # DEFAULT: Automatic | Distributed Link Tracking Client
    )
    # Making the services to run only when needed as 'Manual' | Remove the # to set to Manual
    "ServicesToManual"                           = @(
        "BITS"                           # DEFAULT: Manual    | Background Intelligent Transfer Service
        "BDESVC"                         # DEFAULT: Manual    | BItLocker Drive Encryption Service
        "edgeupdate"                     # DEFAULT: Automatic | Microsoft Edge Update Service
        "edgeupdatem"                    # DEFAULT: Manual    | Microsoft Edge Update Service²
        "FontCache"                      # DEFAULT: Automatic | Windows Font Cache
        #"iphlpsvc"                       # DEFAULT: Automatic | IP Helper Service (IPv6 (6to4, ISATAP, Port Proxy and Teredo) and IP-HTTPS)
        "lmhosts"                        # DEFAULT: Manual    | TCP/IP NetBIOS Helper
        "ndu"                            # DEFAULT: Automatic | Windows Network Data Usage Monitoring Driver (Shows network usage per-process on Task Manager)
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
        # - 3rd Party Services
        "gupdate"                        # DEFAULT: Automatic | Google Update Service
        "gupdatem"                       # DEFAULT: Manual    | Google Update Service²
    )
    # - Content Delivery
    "ContentDeliveryManagerDisableOnZero"        = @(
        "SubscribedContent-310093Enabled"           # "Show me the Windows Welcome Experience after updates and when I sign in highlight whats new and suggested"
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
        "SubscribedContent-314559Enabled"           #
        "SubscribedContent-314563Enabled"           # My People Suggested Apps
        "SubscribedContent-338387Enabled"           # Facts, Tips and Tricks on Lock Screen
        "SubscribedContent-338388Enabled"           # App Suggestions on Start
        "SubscribedContent-338389Enabled"           # Tips, Tricks, and Suggestions Notifications
        "SubscribedContent-338393Enabled"           # Suggested content in Settings
        'SubscribedContent-353694Enabled'           # Suggested content in Settings
        'SubscribedContent-353696Enabled'           # Suggested content in Settings
        "SubscribedContent-353698Enabled"           # Timeline Suggestions
        "SubscribedContentEnabled"                  # Disables Subscribed content
        "SystemPaneSuggestionsEnabled"              #
    )
    "ActivityHistoryDisableOnZero"               = @(
        "EnableActivityFeed"
        "PublishUserActivities"
        "UploadUserActivities"
    )
    # - Optional Features
    "DisableFeatures"                            = @(
        #"FaxServicesClientPackage"             # Windows Fax and Scan
        #"Printing-PrintToPDFServices-Features" # Microsoft Print to PDF
        "IIS-*"                                # Internet Information Services
        "Internet-Explorer-Optional-*"         # Internet Explorer
        "LegacyComponents"                     # Legacy Components
        "MediaPlayback"                        # Media Features (Windows Media Player)
        "MicrosoftWindowsPowerShellV2"         # PowerShell 2.0
        "MicrosoftWindowsPowershellV2Root"     # PowerShell 2.0
        "Printing-XPSServices-Features"        # Microsoft XPS Document Writer
        "WorkFolders-Client"                   # Work Folders Client
    )
    "EnableFeatures"                             = @(
        "NetFx3"                            # NET Framework 3.5
        "NetFx4-AdvSrvs"                    # NET Framework 4
        "NetFx4Extended-ASPNET45"           # NET Framework 4.x + ASPNET 4.x
    )
    # - Debloat
    "apps"                                       = @(
        "Adobe offers",
        "Amazon",
        "Booking",
        "Booking.com",
        "ExpressVPN",
        "Forge of Empires",
        "Free Trials",
        "Planet9 Link",
        "Utomik - Play over 1000 games"
    )
    "Programs"                                   = @(
        # Microsoft Applications
        "Microsoft.549981C3F5F10"                   			# Cortana
        "Microsoft.3DBuilder"                       			# 3D Builder
        "Microsoft.Appconnector"                    			# App Connector
        "*Microsoft.Advertising.Xaml*"
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
        "Microsoft.XboxApp"                                     # Xbox
        "Microsoft.Xbox.TCUI"                                   # Xbox
        #"Microsoft.XboxGameCallableUI"                          # Xbox Game Callable UI ## NON-REMOVABLE = TRUE
        "Microsoft.XboxIdentityProvider"                        # Xbox Identity Provider
        "Microsoft.XboxGameOverlay"                             # Xbox Game Overlay
        "Microsoft.XboxSpeechToTextOverlay"                     # Xbox Text To Speech Overlay
        # 3rd party Apps
        "*ACGMediaPlayer*"
        "*ActiproSoftwareLLC*"
        "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
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
        "*Duolingo-LearnLanguagesforFree*"
        "*EclipseManager*"
        "Evernote.Evernote"                         			# Evernote
        "*ExpressVPN*"                              			# ExpressVPN
        "*Facebook*"                                			# Facebook
        "*Flipboard*"                               			# Flipboard
        "*HiddenCity*"
        "*HiddenCityMysteryofShadows*"
        "*HotspotShieldFreeVPN*"
        "*Hulu*"                                    			# Hulu
        "*Instagram*"                               			# Instagram
        "*LinkedInforWindows*"
        "*McAfee*"                                  			# McAfee
        "5A894077.McAfeeSecurity"                   			# McAfee Security
        "4DF9E0F8.Netflix"                          			# Netflix
        "*Netflix*"
        "*OneCalendar*"
        "*PandoraMediaInc*"
        "*PicsArt-PhotoStudio*"                     			# PhotoStudio
        "*Pinterest*"                               			# Pinterest
        "142F4566A.147190D3DE79"                    			# Pinterest
        "1424566A.147190DF3DE79"                    			# Pinterest
        "*Royal Revolt*"
        "*Speed Test*"
        "SpotifyAB.SpotifyMusic"                    			# Spotify
        "*Sway*"
        "*Twitter*"                                 			# Twitter
        "*TikTok*"                                  			# TikTok
        "*Viber*"
        "5319275A.WhatsAppDesktop"                  			# WhatsApp
        "*Wunderlist*"
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
    )
    "StartLayout" = @"
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
        <taskbar:UWA AppUserModelID="Microsoft.SecHealthUI_8wekyb3d8bbwe!SecHealthUI" />
        <taskbar:UWA AppUserModelID="Microsoft.Windows.SecHealthUI_cw5n1h2txyewy!SecHealthUI" />
        <taskbar:UWA AppUserModelID="windows.immersivecontrolpanel_cw5n1h2txyewy!Microsoft.Windows.ImmersiveControlPanel" />
        <taskbar:UWA AppUserModelID="Microsoft.WindowsStore_8wekyb3d8bbwe" /
        <taskbar:DesktopApp DesktopApplicationID="Microsoft.Windows.SecHealthUI" />
        <taskbar:DesktopApp DesktopApplicationID="Chrome" />
        <taskbar:DesktopApp DesktopApplicationID="Microsoft.Windows.Explorer" />
        </taskbar:TaskbarPinList>
    </defaultlayout:TaskbarLayout>
    </CustomTaskbarLayoutCollection>
</LayoutModificationTemplate>
"@
}
#Clear-Host



function Find-ScheduledTask {
    [CmdletBinding()]
    [OutputType([Bool])]
    param (
        [Parameter(Mandatory = $true)]
        [String] $ScheduledTask
    )

    If (Get-ScheduledTaskInfo -TaskName $ScheduledTask -ErrorAction SilentlyContinue) {
        return $true
    }
    Else {
        $Status = "The $ScheduledTask task was not found."
        Write-Status -Types "?", $TweakType -Status $Status -WriteWarning
        Add-Content -Path $Variables.Log -Value $Status
        return $false
    }
}
Function Get-ADWCleaner {
    [CmdletBinding(
        SupportsShouldProcess
    )]
    param(
        [Switch]$Undo,
        [Switch]$Skip
    )
    Show-ScriptStatus -TitleText "ADWCleaner"

    If ($Skip -or $Undo) {
        Write-Status -Types "@" -Status "Parameter -SkipADW or -Undo detected.. Malwarebytes ADWCleaner will be skipped.." -WriteWarning -ForegroundColorText RED
    }
    else {
        if ($PSCmdlet.ShouldProcess("Download and Run ADWCleaner", "Downloading ADWCleaner $description")) {
            If (!(Test-Path $Variables.adwDestination)) {
                Write-Status -Types "+", "ADWCleaner" -Status "Downloading ADWCleaner" -NoNewLine
                Start-BitsTransfer -Source $Variables.adwLink -Destination $Variables.adwDestination -Dynamic
                Get-Status
            }
            Write-Status -Types "+", "ADWCleaner" -Status "Starting ADWCleaner with ArgumentList /Scan & /Clean"
            Start-Process -FilePath $Variables.adwDestination -ArgumentList "/EULA", "/PreInstalled", "/Clean", "/NoReboot" -Wait -NoNewWindow | Out-Host
            Write-Status -Types "-", "ADWCleaner" -Status "Removing traces of ADWCleaner"
            Start-Process -FilePath $Variables.adwDestination -ArgumentList "/Uninstall", "/NoReboot" -WindowStyle Minimized
        }
    }
}
function Get-CPU {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [switch] $Formatted,
        [Switch] $NameOnly
    )
    try {
        $cpuName = (Get-CimInstance -Class Win32_Processor).Name
        $cores = (Get-CimInstance -class Win32_Processor).NumberOfCores
        $threads = (Get-CimInstance -class Win32_Processor).NumberOfLogicalProcessors
    }
    catch {
        return "Error retrieving CPU information: $($_)"
    }
    if ($NameOnly) {
        return $cpuName
    }
    If ($Formatted) {
        $CPUInfo += [PSCustomObject]@{
            CPU     = $cpuName
            Cores   = $cores
            Threads = $threads
        }
        return $CPUInfo
    }
    else {
        $cpuCoresAndThreads = "($($cores) Cores $($threads) Threads)"
        $CombinedString = "$cpuCoresAndThreads - $cpuName"
        return $CombinedString
    }
}
function Get-DriveInfo {
    $driveInfo = @()
    $physicalDisks = Get-PhysicalDisk | Where-Object { $null -ne $_.MediaType }
    foreach ($disk in $physicalDisks) {
        $model = $disk.FriendlyName
        $driveType = $disk.MediaType
        $sizeGB = [math]::Round($disk.Size / 1GB)
        $healthStatus = $disk.HealthStatus
        $driveInfo += [PSCustomObject]@{
            Status   = $healthStatus
            Model    = $model
            Type     = $driveType
            Capacity = "${sizeGB} GB"
        }
    }
    return $driveInfo
}
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
            Write-Output "$driveInfo"
        }
    }
}
function Get-Error {
    param (
        [string]$errorMessage = $Error[0]
    )

    $lineNumber = $MyInvocation.ScriptLineNumber
    $command = $Error[0].InvocationInfo.MyCommand
    $errorType = $Error[0].CategoryInfo.Reason
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    #$scriptPath = $MyInvocation.MyCommand.Definition
    $userName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

    $errorString = @"


**********************************************************************
$($timestamp) Executed by: $($userName)
Command: $($command)
Error Type: $($errorType)
Offending line number: $($lineNumber)
Error Message: $($errorMessage)
**********************************************************************


"@

    try {
        Add-Content -Path $Variables.Errorlog -Value $errorString -ErrorAction Continue
    }
    catch {
        return "Error writing to log: $($_.Exception.Message)"
    }
}
function Get-GPU {
    [CmdletBinding()]
    [OutputType([String])]
    param ()
    $gpu = Get-CimInstance -Class Win32_VideoController | Select-Object -ExpandProperty Name
    return $gpu.Trim()
}
Function Get-InstalledProgram {
    [CmdletBinding()]
    [OutputType([String])]
    Param(
        [string]$Name
    )
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    $installedPrograms = Get-ChildItem -Path $registryPath
    $matchingPrograms = $installedPrograms | Where-Object {
        ($_.GetValue("DisplayName") -like "*$Name*") -or
        ($_.GetValue("DisplayVersion") -like "*$Name*") -or
        ($_.GetValue("Publisher") -like "*$Name*") -or
        ($_.GetValue("Comments") -like "*$Name*")
    }
    # - Output the matching programs as a list of objects with Name, Version, Publisher, and UninstallString properties
    $matchingPrograms | ForEach-Object {
        [PSCustomObject]@{
            Name            = $_.GetValue("DisplayName")
            UninstallString = $_.GetValue("UninstallString")
            Version         = $_.GetValue("DisplayVersion")
            Publisher       = $_.GetValue("Publisher")
        }
    }
}
function Get-Motherboard {
    [CmdletBinding()]
    [OutputType([String])]
    param ()
    $motherboardModel = Get-CimInstance -Class Win32_BaseBoard | Select-Object -ExpandProperty Product
    $motherboardOEM = Get-CimInstance -Class Win32_BaseBoard | Select-Object -ExpandProperty Manufacturer
    [String]$CombinedString = "$motherboardOEM $motherboardModel"
    return "$CombinedString"
}
Function Get-NetworkStatus {
    [CmdletBinding()]
    param(
        [string]$NetworkStatusType = "IPv4Connectivity"
    )
    #$NetStatus = (Get-NetConnectionProfile).IPv4Connectivity
    $NetStatus = (Get-NetConnectionProfile).$NetworkStatusType
    if ($NetStatus -ne 'Internet') {
        Write-Status -Types "WAITING" -Status "Seems like there's no network connection. Please reconnect." -WriteWarning
        while ($NetStatus -ne 'Internet') {
            Write-Output "Waiting for Internet"
            Start-Sleep -Milliseconds 3500
            $NetStatus = (Get-NetConnectionProfile).$NetworkStatusType
        }
        Test-Connection -ComputerName $Env:COMPUTERNAME -AsJob
        Write-Output "Connected: Moving On"
    }
}
Function Get-Office {
    Show-ScriptStatus -WindowTitle "Office" -TweakType "Office" -TitleCounterText "Office"
    Write-Status -Types "?" -Status "Checking for Office"
    If (Test-Path $Variables.PathToOffice64 ) {
        $Variables.office64 = $true
    }
    Else {
        $Variables.office64 = $false
    }

    <#$Spotify = "Jimbo"
    $Variables.$($Spotify) = "LLS"
    $Variables.Jimbo#>

    If (Test-Path $Variables.PathToOffice86 ) {
        $Variables.Office32 = $true
    }
    Else {
        $Variables.office32 = $false
    }

    If ($Variables.office32 -or $Variables.Office64 -eq $true) {
        $Variables.officecheck = $true
    }

    If ($Variables.officecheck -eq $true) {
        Write-Status -Types "WAITING" -Status "Office Exists" -WriteWarning
    }
    Else {
        $message = "There are no Microsoft Office products on this device."
        Write-Status -Types "?" -Status $Message -WriteWarning
        Add-Content -Path $Variables.Log -Value $message
    }

    If ($Variables.officecheck -eq $true) {
        Remove-Office
    }
}

Function Get-Program {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [switch]$Skip,
        [switch]$Undo
    )

    Show-ScriptStatus -WindowTitle "Apps" -TweakType "Apps" -TitleCounterText "Programs" -TitleText "Application Installation"

    $chrome = @{
        Name              = "Google Chrome"
        Installed         = Test-Path -Path "$Env:PROGRAMFILES\Google\Chrome\Application\chrome.exe"
        DownloadURL       = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
        InstallerLocation = "$NewLoads\googlechromestandaloneenterprise64.msi"
        FileExists        = Test-Path -Path "$NewLoads\googlechromestandaloneenterprise64.msi"
        ArgumentList      = "/passive"
    }
    $vlc = @{
        Name              = "VLC Media Player"
        Installed         = Test-Path -Path "$Env:PROGRAMFILES\VideoLAN\VLC\vlc.exe"
        #DownloadURL         = "https://ftp.osuosl.org/pub/videolan/vlc/3.0.18/win64/vlc-3.0.18-win64.exe"
        DownloadURL       = "https://get.videolan.org/vlc/3.0.18/win64/vlc-3.0.18-win64.exe"
        InstallerLocation = "$NewLoads\vlc-3.0.18-win64.exe"
        FileExists        = Test-Path -Path "$NewLoads\vlc-3.0.18-win64.exe"
        ArgumentList      = "/S /L=1033"
    }
    $zoom = @{
        Name              = "Zoom"
        Installed         = Test-Path -Path "$Env:PROGRAMFILES\Zoom\bin\Zoom.exe"
        DownloadURL       = "https://zoom.us/client/5.15.2.18096/ZoomInstallerFull.msi?archType=x64"
        InstallerLocation = "$NewLoads\ZoomInstallerFull.msi"
        FileExists        = Test-Path -Path "$NewLoads\ZoomInstallerFull.msi"
        ArgumentList      = "/quiet"
    }
    $acrobat = @{
        Name              = "Adobe Acrobat Reader"
        Installed         = Test-Path -Path "${Env:Programfiles(x86)}\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe"
        DownloadURL       = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2200120169/AcroRdrDC2200120169_en_US.exe"
        InstallerLocation = "$newLoads\AcroRdrDCx642200120085_MUI.exe"
        FileExists        = Test-Path -Path "$NewLoads\AcroRdrDCx642200120085_MUI.exe"
        ArgumentList      = "/sPB"
    }
    $HEVC = @{
        Name              = "HEVC/H.265 Codec"
        Installed         = $False
        DownloadURL       = "https://github.com/circlol/newload/raw/main/assets/Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx"
        InstallerLocation = "$NewLoads\Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx"
        FileExists        = Test-Path -Path "$NewLoads \Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx"
    }


    If ($Skip -or $Undo) {
        Write-Status -Types "@" -Status "Parameter -SkipProgams and/or -Undo detected.. Ignoring this section." -WriteWarning -ForegroundColorText RED
    }
    else {
        if ($PSCmdlet.ShouldProcess("Get-Program", "Perform program installation")) {
            foreach ( $program in $chrome, $vlc, $zoom, $acrobat, $hevc ) {
                Write-Section -Text $program.Name
                if ( $program.Installed -eq $false ) {
                    if ( $program.FileExists -eq $false ) {
                        Get-NetworkStatus
                        try {
                            Write-Status -Types "+", $TweakType -Status "Downloading $($program.Name)" -NoNewLine
                            Start-BitsTransfer -Source $program.DownloadURL -Destination $program.InstallerLocation -TransferType Download -Dynamic
                            Get-Status
                        }
                        catch {
                            Get-Error $_
                            continue
                        }
                    }
                    If ($program.Name -eq $hevc.Name) {
                        Write-Status -Types "+", $TweakType -Status "Adding support to $($HEVC.name) codec..." -NoNewLine
                        try {
                            $BackupProgressPreference = $ProgressPreference
                            $ProgressPreference = 'SilentlyContinue'
                            Add-AppPackage -Path $HEVC.InstallerLocation
                            Get-Status
                            $ProgressPreference = $BackupProgressPreference
                        }
                        catch {
                            Get-Error $_
                            continue
                        }
                    }
                    else {
                        Write-Status -Types "+", $TweakType -Status "Installing $($program.Name)" -NoNewLine
                        try {
                            Start-Process -FilePath $program.InstallerLocation -ArgumentList $program.ArgumentList -Wait
                            Get-Status
                        }
                        catch {
                            Get-Error $_
                            continue
                        }
                    }
                    if ($program.Name -eq $Chrome.name) {
                        Write-Status "+", $TweakType -Status "Adding UBlock Origin to Google Chrome"
                        Set-ItemPropertyVerified -Path $Variables.PathToUblockChrome -Name "update_url" -value $Variables.PathToChromeLink -Type STRING
                        Get-Status
                    }
                }
                else {
                    Write-Status -Types "@", $TweakType -Status "$($program.Name) already seems to be installed on this system.. Skipping Installation"
                    if ($program.Name -eq $Chrome.name) {
                        Write-Status "+", $TweakType -Status "Adding UBlock Origin to Google Chrome"
                        Set-ItemPropertyVerified -Path $Variables.PathToUblockChrome -Name "update_url" -value $Variables.PathToChromeLink -Type STRING
                        Get-Status
                    }
                }
            }
        }
    }
}

function Get-RAM {
    [CmdletBinding()]
    [OutputType([String])]
    param ()
    $ram = Get-CimInstance Win32_ComputerSystem | Select-Object -ExpandProperty TotalPhysicalMemory
    $ram = $ram / 1GB
    return "{0:N2} GB" -f $ram
}
function Get-Status {
    If ($? -eq $True) {
        # If no error message is provided, assume success
        $Global:LogEntry.Successful = $true
        Write-Caption -Type Success
        Add-Content -Path $Variables.Log -Value $logEntry
    }
    else {
        # Set the global LogEntry.Successful to false
        $Global:LogEntry.Successful = $false
        $Global:LogEntry.ErrorMessage = $Error[0]
        # Log a failure message
        Write-Caption -Type Failed
        
        Add-Content -Path $Variables.Log -Value $logEntry
        Add-Content -Path $Variables.Log -Value $Error[0]
#        # Handle the error message
#        Get-Error
    }
}
Function Get-SystemInfo {
    [CmdletBinding()]
    [OutputType([String])]
    param()

    Begin{
        # Grab CPU info
        try {
            $cpuName = (Get-CimInstance -Class Win32_Processor).Name
            $cores = (Get-CimInstance -class Win32_Processor).NumberOfCores
            $threads = (Get-CimInstance -class Win32_Processor).NumberOfLogicalProcessors
            $cpuCoresAndThreads = "($($cores) Cores $($threads) Threads)"
            $CPUCombinedString = "$cpuCoresAndThreads - $cpuName"
        }
        catch {
            return "Error retrieving CPU information: $($_)"
        }

        # Grab GPU info
        try {
            $gpu = (Get-CimInstance -Class Win32_VideoController).Name
        }
        catch{
            return "Error retrieving GPU information: $($_)"
        }

        # Grab RAM info
        try {
            $ram = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
            $ram = $ram / 1GB
        }
        catch{
            return "Error retrieving RAM information: $($_)"
        }

        # Grab Motherboard info
        try {
            $motherboardModel = (Get-CimInstance -Class Win32_BaseBoard).Product
            $motherboardOEM = (Get-CimInstance -Class Win32_BaseBoard).Manufacturer
            $MotherboardCombinedString = "$motherboardOEM $motherboardModel"
        }
        catch {
            return "Error retrieving Motherboard information: $($_)"
        }

        # Grab Windows Version
        try {
            $PathToLMCurrentVersion = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
            $osarch = (Get-CimInstance Win32_OperatingSystem).OSArchitecture
            $WinVer = (Get-CimInstance -class Win32_OperatingSystem).Caption -replace 'Microsoft ', ''
            $DisplayVersion = (Get-ItemProperty $PathToLMCurrentVersion).DisplayVersion
            $OldBuildNumber = (Get-ItemProperty $PathToLMCurrentVersion).ReleaseId
            $DisplayedVersionResult = '(' + @{ $true = $DisplayVersion; $false = $OldBuildNumber }[$null -ne $DisplayVersion] + ')'
            $completedWindowsName = "$WinVer $osarch $DisplayedVersionResult"
        }
        catch {
            return "Error retrieving Windows information: $($_)"
        }

        # Grabs drive space
        try {
            $drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Free -ge 0 -and $_.Used -ge 0 }
            foreach ($drive in $drives) {
                $driveLetter = $drive.Name
                $availableStorage = $drive.Free / 1GB
                $totalStorage = ($drive.Free + $drive.Used) / 1GB
                $percentageAvailable = [math]::Round(($availableStorage / $totalStorage) * 100, 1)
                $driveInfo = "$driveLetter`: $([math]::Round($availableStorage, 1))/$([math]::Round($totalStorage, 1)) GB ($percentageAvailable% Available)"
                $CombinedDriveInfo = "$($CombinedDriveInfo)`n$($driveInfo)"
                }
        }
        catch {
            return "Error retrieving disk information: $($_)"
        }

    $CombinedString = "
- CPU: $($CPUCombinedString)
- GPU: $($gpu.Trim())
- RAM: $("{0:N2} GB" -f $ram)
- Motherboard: $($MotherboardCombinedString)
- OS: $($completedWindowsName)
- Disk Info: $($CombinedDriveInfo)
"
    }process{
        return $CombinedString
    }
}


Function New-SystemRestorePoint {
    [CmdletBinding(SupportsShouldProcess)]
    Param()
    $description = "Mother Computers Courtesy Restore Point"
    $restorePointType = "MODIFY_SETTINGS"
    if ($PSCmdlet.ShouldProcess("Create System Restore Point", "Creating a new restore point with description: $description")) {
        Show-ScriptStatus -WindowTitle "Restore Point" -TweakType "Backup" -TitleCounterText "Creating Restore Point"
        # Assure System Restore is enabled
        Write-Status -Types "+" -Status "Enabling System Restore" -NoNewLine
        try {
            Enable-ComputerRestore -Drive "$env:SystemDrive\"
            Get-Status
            Write-Status -Types "+" -Status "Creating System Restore Point: $description" -NoNewLine
            Checkpoint-Computer -Description $description -RestorePointType $restorePointType
            Get-Status
        }
        catch {
            Get-Error $_
            Continue
        }
        Show-ScriptStatus -WindowTitle ""
    }
    else {
        Write-Output "Operation Canceled."
    }
}

Function Optimize-General {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Int]    $Zero = 0,
        [Int]    $One = 1,
        [Int]    $OneTwo = 1,
        [Switch] $Undo
    )

    Show-ScriptStatus -WindowTitle "Optimization" -TweakType "Registry" -TitleCounterText "Optimization" -TitleText "General"

    $EnableStatus = @(
        @{ Symbol = "-"; Status = "Disabling"; }
        @{ Symbol = "+"; Status = "Enabling"; }
    )

    If (($Undo)) {
        Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Undo'."
        $Zero = 1
        $One = 0
        $OneTwo = 2
        $EnableStatus = @(
            @{ Symbol = "<"; Status = "Re-Enabling"; }
            @{ Symbol = "<"; Status = "Re-Disabling"; }
        )
    }

    if ($PSCmdlet.ShouldProcess("Optimize-General", "General tweaks to Windows")) {
        If ($Variables.osVersion -like "*Windows 10*") {
            # code for Windows 10
            Write-Section -Text "Applying Windows 10 Specific Reg Keys"

            ## Changes search box to an icon
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "Switching Search Box to an Icon."
            Set-ItemPropertyVerified -Path $Variables.PathToCUSearch -Name "SearchboxTaskbarMode" -Value $OneTwo -Type DWord

            ## Removes Cortana from the taskbar
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Cortana Button from Taskbar..."
            Set-ItemPropertyVerified -Path $Variables.PathToCUExplorerAdvanced -Name "ShowCortanaButton" -Value $Zero -Type DWord


            ##  Removes 3D Objects from "This PC"
            $PathToHide3DObjects = "$($Variables.PathToRegExplorerLocalMachine)\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status)  3D Objects from This PC.."
            Get-Item $PathToHide3DObjects -ErrorAction SilentlyContinue | Remove-Item -Recurse

            # Expands ribbon in 10 explorer
            Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Expanded Ribbon in Explorer.."
            Set-ItemPropertyVerified -Path "$($Variables.PathToCUExplorer)\Ribbon" -Name "MinimizedStateTabletModeOff" -Type DWORD -Value $Zero

            ## Disabling Feeds Open on Hover
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Feeds Open on Hover..."
            Set-ItemPropertyVerified -Path "$($Variables.PathToRegCurrentVersion)\Feeds" -Name "ShellFeedsTaskbarOpenOnHover" -Value $Zero -Type DWord

            #Disables live feeds in search
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Dynamic Content in Windows Search..."
            Set-ItemPropertyVerified -Path $Variables.PathToCUFeedsDSB -Name "ShowDynamicContent" -Value $Zero -type DWORD
            Set-ItemPropertyVerified -Path $Variables.PathToCUSearchSettings -Name "IsDynamicSearchBoxEnabled" -Value $Zero -Type DWORD
        }
        elseif ($Variables.osVersion -like "*Windows 11*") {
            ## Code for Windows 11
            Write-Section -Text "Applying Windows 11 Specific Reg Keys"
            If ($Variables.BuildNumber -GE $Variables.Win22H2 ) {
                Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) More Icons in the Start Menu.."
                Set-ItemPropertyVerified -Path $Variables.PathToCUExplorerAdvanced -Name Start_Layout -Value $One -Type DWORD -Force
            }

            # Sets explorer to compact mode in 11
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Compact Mode View in Explorer "
            Set-ItemPropertyVerified -Path $Variables.PathToCUExplorerAdvanced -Name UseCompactMode -Value $One -Type DWORD

            # Removes Chats from the taskbar in 11
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Chats from the Taskbar..."
            Set-ItemPropertyVerified -Path $Variables.PathToCUExplorerAdvanced -Name "TaskBarMn" -Value $Zero -Type DWORD

            # Removes Meet Now from the taskbar in 11
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Meet Now from the Taskbar..."
            Set-ItemPropertyVerified -Path "$($Variables.PathToRegCurrentVersion)\Policies\Explorer" -Name "HideSCAMeetNow" -Type DWORD -Value $One

            <# Adds Most Used Apps to Start Menu in 11
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Most Used Apps to Start Menu"
            Set-ItemPropertyVerified #>
        }
        else {
            # code for other operating systems
            # Check Windows version
            return "Don't know what happened. Closing"
            exit
        }

        Write-Section -Text "Explorer Related"

        ## Unpins taskview from Taskbar
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Task View from Taskbar..."
        Set-ItemPropertyVerified -Path $Variables.PathToCUExplorerAdvanced -Name "ShowTaskViewButton" -Value $Zero -Type DWord


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
        Set-ItemPropertyVerified -Path $Variables.PathToCUExplorer -Name "ShowRecent" -Value $Zero -Type DWORD

        # Removes frequent files in explorer quick menu
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Frequent in Explorer..."
        Set-ItemPropertyVerified -Path $Variables.PathToCUExplorer -Name "ShowFrequent" -Value $Zero -Type DWORD

        # Removes drives without any media (usb hubs, wifi adapters, sd card readers, ect.)
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Drives without Media..."
        Set-ItemPropertyVerified -Path $Variables.PathToCUExplorerAdvanced -Name "HideDrivesWithNoMedia" -Type DWord -Value $Zero

        # Launches Explorer to This PC
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting Explorer Launch to This PC.."
        Set-ItemPropertyVerified -Path $Variables.PathToCUExplorerAdvanced -Name "LaunchTo" -Value $One -Type Dword

        # Adds User shortcut to desktop
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) User Files to Desktop..."
        Set-ItemPropertyVerified -Path "$($Variables.PathToCUExplorer)\HideDesktopIcons\NewStartPanel" -Name $Variables.UsersFolder -Value $Zero -Type DWORD

        # Adds This PC shortcut to desktop
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) This PC to Desktop..."
        Set-ItemPropertyVerified -Path "$($Variables.PathToCUExplorer)\HideDesktopIcons\NewStartPanel" -Name $Variables.ThisPC -Value $Zero -Type DWORD

        # Expands details of file operations window
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Expanded File Operation Details by Default.."
        Set-ItemPropertyVerified -Path "$($Variables.PathToCUExplorer)\OperationStatusManager" -Name "EnthusiastMode" -Type DWORD -Value $One

    }
}
Function Optimize-Performance {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Int]    $Zero = 0,
        [Int]    $One = 1,
        [Int]    $OneTwo = 1,
        [Switch] $Undo
    )
    Show-ScriptStatus -TweakType "Performance" -TitleText "Performance" -SectionText "System"
    $EnableStatus = @(
        @{ Symbol = "-"; Status = "Disabling"; }
        @{ Symbol = "+"; Status = "Enabling"; }
    )

    If (($Undo)) {
        Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Undo'."
        $Zero = 1
        $One = 0
        $OneTwo = 2
        $EnableStatus = @(
            @{ Symbol = "<"; Status = "Re-Enabling"; }
            @{ Symbol = "<"; Status = "Re-Disabling"; }
        )
    }

    if ($PSCmdlet.ShouldProcess("Optimize-Performance", "Performance enhancing tweaks")) {
        $ExistingPowerPlans = $((powercfg -L)[3..(powercfg -L).Count])
        # Found on the registry: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\User\Default\PowerSchemes
        $BuiltInPowerPlans = @{
            "Power Saver"            = "a1841308-3541-4fab-bc81-f71556f20b4a"
            "Balanced (recommended)" = "381b4222-f694-41f0-9685-ff5bb260df2e"
            "High Performance"       = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
            "Ultimate Performance"   = "e9a42b02-d5df-448d-aa00-03f14749eb61"
        }
        $UniquePowerPlans = $BuiltInPowerPlans.Clone()

        Write-Caption -Text "Display" -Type None
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Enable Hardware Accelerated GPU Scheduling... (Windows 10 20H1+ - Needs Restart)"
        Set-ItemPropertyVerified -Path $Variables.PathToGraphicsDrives -Name "HwSchMode" -Type DWord -Value 2

        # [@] (2 = Enable Ndu, 4 = Disable Ndu)
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Ndu High RAM Usage..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMNdu -Name "Start" -Type DWord -Value 4
        # Details: https://www.tenforums.com/tutorials/94628-change-split-threshold-svchost-exe-windows-10-a.html
        # Will reduce Processes number considerably on > 4GB of RAM systems

        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting SVCHost to match installed RAM size..."
        $RamInKB = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1KB
        Set-ItemPropertyVerified -Path $Variables.PathToLMControl -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $RamInKB


        Write-Section "Microsoft Edge Tweaks"
        Write-Caption -Text "System and Performance" -Type None

        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Edge Startup boost..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesEdge -Name "StartupBoostEnabled" -Type DWord -Value $Zero

        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) run extensions and apps when Edge is closed..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesEdge -Name "BackgroundModeEnabled" -Type DWord -Value $Zero
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
                    Write-Status -Types "-", $TweakType -Status "Duplicated '$PowerPlanName' power plan found, deleting $PowerPlanGUID ..." -NoNewLine
                    powercfg -Delete $PowerPlanGUID
                    Get-Status
                }
            }
            Catch {
                Write-Status -Types "-", $TweakType -Status "Duplicated '$PowerPlanName' power plan found, deleting $PowerPlanGUID ..." -NoNewLine
                powercfg -Delete $PowerPlanGUID
                Get-Status
            }
        }

        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Monitor Timeout to AC: $($Variables.TimeoutScreenPluggedIn) and DC: $($Variables.TimeoutScreenBattery)..."
        powercfg -Change Monitor-Timeout-AC $Variables.TimeoutScreenPluggedIn
        powercfg -Change Monitor-Timeout-DC $Variables.TimeoutScreenBattery
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Standby Timeout to AC: $($Variables.TimeoutStandByPluggedIn) and DC: $($Variables.TimeoutStandByBattery)..."
        powercfg -Change Standby-Timeout-AC $Variables.TimeoutStandByPluggedIn
        powercfg -Change Standby-Timeout-DC $Variables.TimeoutStandByBattery
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Disk Timeout to AC: $($Variables.TimeoutDiskPluggedIn) and DC: $($Variables.TimeoutDiskBattery)..."
        powercfg -Change Disk-Timeout-AC $Variables.TimeoutDiskPluggedIn
        powercfg -Change Disk-Timeout-DC $Variables.TimeoutDiskBattery
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Hibernate Timeout to AC: $($Variables.TimeoutHibernatePluggedIn) and DC: $($Variables.TimeoutHibernateBattery)..."
        powercfg -Change Hibernate-Timeout-AC $Variables.TimeoutHibernatePluggedIn
        Powercfg -Change Hibernate-Timeout-DC $Variables.TimeoutHibernateBattery
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting Power Plan to High Performance..."
        powercfg -SetActive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Creating the Ultimate Performance hidden Power Plan..."
        powercfg -DuplicateScheme e9a42b02-d5df-448d-aa00-03f14749eb61
        Write-Section "Network & Internet"
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Unlimiting your network bandwidth for all your system..." # Based on this Chris Titus video: https://youtu.be/7u1miYJmJ_4
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesPsched -Name "NonBestEffortLimit" -Type DWord -Value 0
        Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfile -Name "NetworkThrottlingIndex" -Type DWord -Value 0xffffffff
        Write-Section "System & Apps Timeout behaviors"
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reducing Time to services app timeout to 2s to ALL users..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMControl -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000 # Default: 20000 / 5000
        Write-Status -Types "*", $TweakType -Status "Don't clear page file at shutdown (takes more time) to ALL users..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMMemoryManagement -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reducing mouse hover time events to 10ms..."
        Set-ItemPropertyVerified -Path $Variables.PathToCUMouse -Name "MouseHoverTime" -Type String -Value "1000" # Default: 400
        # Details: https://windowsreport.com/how-to-speed-up-windows-11-animations/ and https://www.tenforums.com/tutorials/97842-change-hungapptimeout-value-windows-10-a.html
        ForEach ($DesktopRegistryPath in @($Variables.PathToUsersControlPanelDesktop, $Variables.PathToCUControlPanelDesktop)) {
            <# $DesktopRegistryPath is the path related to all users and current user configuration #>
            If ($DesktopRegistryPath -eq $Variables.PathToUsersControlPanelDesktop) {
                Write-Caption -Text "TO ALL USERS" -Type None
            }
            ElseIf ($DesktopRegistryPath -eq $Variables.PathToCUControlPanelDesktop) {
                Write-Caption -Text "TO CURRENT USER" -Type None
            }
            Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Don't prompt user to end tasks on shutdown..."
            Set-ItemPropertyVerified -Path $DesktopRegistryPath -Name "AutoEndTasks" -Type DWord -Value 1 # Default: Removed or 0

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
        Set-ItemPropertyVerified -Path $Variables.PathToCUGameBar -Name "AllowAutoGameMode" -Type DWord -Value 1
        Set-ItemPropertyVerified -Path $Variables.PathToCUGameBar -Name "AutoGameModeEnabled" -Type DWord -Value 1

        # Details: https://www.reddit.com/r/killerinstinct/comments/4fcdhy/an_excellent_guide_to_optimizing_your_windows_10/
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reserving 100% of CPU to Multimedia/Gaming tasks..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfile -Name "SystemResponsiveness" -Type DWord -Value 0 # Default: 20

        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Dedicate more CPU/GPU usage to Gaming tasks..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfileOnGameTasks -Name "GPU Priority" -Type DWord -Value 8 # Default: 8
        Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfileOnGameTasks -Name "Priority" -Type DWord -Value 6 # Default: 2
        Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfileOnGameTasks -Name "Scheduling Category" -Type String -Value "High" # Default: "Medium"
    }
}
Function Optimize-Privacy {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Int]    $Zero = 0,
        [Int]    $One = 1,
        [Int]    $OneTwo = 1,
        [Switch] $Undo
    )
    Show-ScriptStatus -TweakType "Privacy" -TitleText "Privacy"
    $EnableStatus = @(
        @{ Symbol = "-"; Status = "Disabling"; }
        @{ Symbol = "+"; Status = "Enabling"; }
    )

    If (($Undo)) {
        Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Undo'."
        $Zero = 1
        $One = 0
        $OneTwo = 2
        $EnableStatus = @(
            @{ Symbol = "<"; Status = "Re-Enabling"; }
            @{ Symbol = "<"; Status = "Re-Disabling"; }
        )
    }


    if ($PSCmdlet.ShouldProcess("Optimize-Privacy", "Perform privacy optimizations")) {

        Write-Section -Text "Personalization"
        Write-Caption -Text "Start & Lockscreen"

        # Executes the array above
        Write-Status -Types "?", $TweakType -Status "From Path: [$($Variables.PathToCUContentDeliveryManager)]." -WriteWarning
        ForEach ($Name in $Variables.ContentDeliveryManagerDisableOnZero) {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $Zero"
            Set-ItemPropertyVerified -Path $Variables.PathToCUContentDeliveryManager -Name "$Name" -Type DWord -Value $Zero
        }

        # Disables content suggestions in settings
        Write-Status -Types "-", $TweakType -Status "$($EnableStatus[0].Status) 'Suggested Content in the Settings App'..." -NoNewLine
        Get-Item "$($Variables.PathToCUContentDeliveryManager)\Subscriptions" -ErrorAction SilentlyContinue | Remove-Item -Recurse
        Get-Status
        <#If (Test-Path "$($Variables.PathToCUContentDeliveryManager)\Subscriptions") {
            Remove-Item -Path "$($Variables.PathToCUContentDeliveryManager)\Subscriptions" -Recurse
        }#>

        # Disables content suggestion in start
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Show Suggestions' in Start..." -NoNewLine
        Get-Item "$($Variables.PathToCUContentDeliveryManager)\SuggestedApps" -ErrorAction SilentlyContinue | Remove-Item -Recurse
        Get-Status
        <#If (Test-Path "$($Variables.PathToCUContentDeliveryManager)\SuggestedApps") {
            Remove-Item -Path "$($Variables.PathToCUContentDeliveryManager)\SuggestedApps" -Recurse
        }#>

        Write-Section -Text "Privacy -> Windows Permissions"
        Write-Caption -Text "General"

        # Disables Advertiser ID through permissions and group policy.
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Let apps use my advertising ID..."
        Set-ItemPropertyVerified -Path $Variables.PathToRegAdvertising -Name "Enabled" -Type DWord -Value $Zero
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesAdvertisingInfo -Name "DisabledByGroupPolicy" -Type DWord -Value $One

        # Disables locally relevant content
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'Let websites provide locally relevant content by accessing my language list'..."
        Set-ItemPropertyVerified -Path $Variables.PathToCUUP -Name "HttpAcceptLanguageOptOut" -Type DWord -Value $One

        Write-Caption -Text "Speech"
        # Removes consent for online speech recognition services.
        # [@] (0 = Decline, 1 = Accept)
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Online Speech Recognition..."
        Set-ItemPropertyVerified -Path $Variables.PathToCUOnlineSpeech -Name "HasAccepted" -Type DWord -Value $Zero

        Write-Caption -Text "Inking & Typing Personalization"
        # Disables personalization of inking and typing data (Keystrokes)
        Set-ItemPropertyVerified -Path "$($Variables.PathToCUInputPersonalization)\TrainedDataStore" -Name "HarvestContacts" -Type DWord -Value $Zero
        Set-ItemPropertyVerified -Path $Variables.PathToCUInputPersonalization -Name "RestrictImplicitInkCollection" -Type DWord -Value $One
        Set-ItemPropertyVerified -Path $Variables.PathToCUInputPersonalization -Name "RestrictImplicitTextCollection" -Type DWord -Value $One
        Set-ItemPropertyVerified -Path $Variables.PathToCUPersonalization -Name "AcceptedPrivacyPolicy" -Type DWord -Value $Zero

        Write-Caption -Text "Diagnostics & Feedback"
        #Disables Telemetry
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) telemetry..."
        # [@] (0 = Security (Enterprise only), 1 = Basic Telemetry, 2 = Enhanced Telemetry, 3 = Full Telemetry)
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesTelemetry -Name "AllowTelemetry" -Type DWord -Value $Zero
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesTelemetry2 -Name "AllowTelemetry" -Type DWord -Value $Zero
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesTelemetry -Name "AllowDeviceNameInTelemetry" -Type DWord -Value $Zero
        # Disables Microsofts collection of inking and typing data
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) send inking and typing data to Microsoft..."
        Set-ItemPropertyVerified -Path $Variables.PathToCUInputTIPC -Name "Enabled" -Type DWord -Value $Zero
        # Disables Microsoft's tailored experiences.
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Tailored Experiences..."
        Set-ItemPropertyVerified -Path $Variables.PathToPrivacy -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Type DWord -Value $Zero
        # Disables transcript of diagnostic data for collection
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) View diagnostic data..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMEventKey -Name "EnableEventTranscript" -Type DWord -Value $Zero
        # Sets feedback frequency to 0
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) feedback frequency..."
        If ((Test-Path "$($Variables.PathToCUSiufRules)\PeriodInNanoSeconds")) {
            Remove-ItemProperty -Path $Variables.PathToCUSiufRules -Name "PeriodInNanoSeconds"
        }
        Set-ItemPropertyVerified -Path $Variables.PathToCUSiufRules -Name "NumberOfSIUFInPeriod" -Type DWord -Value $Zero

        Write-Caption -Text "Activity History"
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Activity History..."
        Write-Status -Types "?", $TweakType -Status "From Path: [$($Variables.PathToLMActivityHistory)]" -WriteWarning
        ForEach ($Name in $Variables.ActivityHistoryDisableOnZero) {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $Zero"
            Set-ItemPropertyVerified -Path $Variables.PathToLMActivityHistory -Name $Name -Type DWord -Value $Zero
        }
        # Disables Suggested ways of getting the most out of windows (Microsoft account spam)
        Write-Status -Types "-" , $TweakType -Status "$($EnableStatus[1].Status) 'Suggest ways i can finish setting up my device to get the most out of windows.')"
        Set-ItemPropertyVerified -Path $Variables.PathToCUUserProfileEngagemment -Name "ScoobeSystemSettingEnabled" -Value $Zero -Type DWord

        ### Privacy
        Write-Section -Text "Privacy"

        If (Test-Path "$($Variables.PathToCUContentDeliveryManager)\Subscription" ) {
            Write-Status -Types "-" -Status "Removing $($Variables.PathToCUContentDeliveryManager)\Subscription" -NoNewLine
            Remove-Item "$($Variables.PathToCUContentDeliveryManager)\Subscription" -Recurse
            Get-Status
        }
        #Get-Item "$($Variables.PathToCUContentDeliveryManager)\SuggestedApps" | Remove-Item -Recurse
        If (Test-Path -Path "$($Variables.PathToCUContentDeliveryManager)\SuggestedApps") {
            Write-Status -Types "-" -Status "Removing $($Variables.PathToCUContentDeliveryManager)\SuggestedApps" -NoNewLine
            Remove-Item -Path "$($Variables.PathToCUContentDeliveryManager)\SuggestedApps" -Recurse
            Get-Status
        }

        # Disables app launch tracking
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) App Launch Tracking..."
        Set-ItemPropertyVerified -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI -Name "DisableMFUTracking" -Value $One -Type DWORD

        If ($vari -eq '2') { Remove-Item -Path HKCU:\Software\Policies\Microsoft\Windows\EdgeUI }

        # Sets windows feeback notifciations to never show
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Windows Feedback Notifications..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesTelemetry -Name "DoNotShowFeedbackNotifications" -Type DWORD -Value $One

        # Disables location tracking
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Location Tracking..."
        Set-ItemPropertyVerified -Path $Variables.RegCAM -Name "Value" -Type String -Value "Deny"
        Set-ItemPropertyVerified -Path $Variables.PathToLFSVC -Name "Status" -Type DWORD -Value $Zero

        # Disables map updates (Windows Maps is removed)
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Automatic Map Updates..."
        Set-ItemPropertyVerified -Path:HKLM:\SYSTEM\Maps -Name "AutoUpdateEnabled" -Type DWORD -Value $Zero

        # AutoConnect to Hotspots disabled
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) AutoConnect to Sense Hotspots..."
        Set-ItemPropertyVerified -Path "$($Variables.PathToLMPoliciesToWifi)\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type DWORD -Value $Zero

        # Disables reporting hotspots to microsoft
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Hotspot Reporting to Microsoft..."
        Set-ItemPropertyVerified -Path "$($Variables.PathToLMPoliciesToWifi)\AllowWiFiHotSpotReporting" -Name "Value" -Type DWORD -Value $Zero

        # Disables cloud content from search (OneDrive, Office, Dropbox, ect.)
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Cloud Content from Windows Search..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesCloudContent -Name "DisableWindowsConsumerFeatures" -Type DWORD -Value $One

        # Disables tailored experience w users diagnostic data.
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Tailored Experience w/ Diagnostic Data..."
        Set-ItemPropertyVerified -Path $Variables.PathToPrivacy -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value $Zero -Type DWORD

        # Disables HomeGroup
        Write-Status -Types $EnableStatus[1].Symbol, "$TweakType" -Status "Stopping and disabling Home Groups services.."
        If (!(Get-Service -Name HomeGroupListener )) { } else {
            Stop-Service "HomeGroupListener" -ErrorAction SilentlyContinue
            Set-Service "HomeGroupListener" -StartupType Disabled
        }
        If (!(Get-Service -Name HomeGroupListener )) { } else {
            Stop-Service "HomeGroupProvider" -ErrorAction SilentlyContinue
            Set-Service "HomeGroupProvider" -StartupType Disabled
        }

        # Disables SysMain
        If ((Get-Service -Name SysMain).Status -eq 'Stopped') { } else {
            Write-Host ' Stopping and disabling Superfetch service'
            Stop-Service "SysMain"
            Set-Service "SysMain" -StartupType Disabled
        }

        # Disables volume lowering during calls
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Volume Adjustment During Calls..."
        Set-ItemPropertyVerified -Path:HKCU:\Software\Microsoft\MultiMedia\Audio -Name "UserDuckingPreference" -Value 3 -Type DWORD

        # Groups SVChost processes
        $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
        Write-Status -Types $EnableStatus[1].Symbol, "$TweakType" -Status "Grouping svchost.exe Processes"
        Set-ItemPropertyVerified -Path:HKLM:\SYSTEM\CurrentControlSet\Control -Name "SvcHostSplitThresholdInKB" -Type DWORD -Value $ram

        # Stack size increased for greater performance
        Write-Status -Types $EnableStatus[1].Symbol, "$TweakType" -Status "Increasing Stack Size to 30"
        Set-ItemPropertyVerified -Path:HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters -Name "IRPStackSize" -Type DWORD -Value 30

        # Sets DNS settings to Google with CloudFlare as backup
        If (Get-Command Set-DnsClientDohServerAddress -ErrorAction SilentlyContinue ) {
            ## Imported text from  win10-debloat-tools on github
            # Adapted from: https://techcommunity.microsoft.com/t5/networking-blog/windows-insiders-gain-new-dns-over-https-controls/ba-p/2494644
            Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting up the DNS over HTTPS for Google and Cloudflare (ipv4 and ipv6)..."
            Set-DnsClientDohServerAddress -ServerAddress ("1.1.1.1", "1.0.0.1", "2606:4700:4700::1111", "2606:4700:4700::1001") -AutoUpgrade $true -AllowFallbackToUdp $true
            Set-DnsClientDohServerAddress -ServerAddress ("8.8.8.8", "8.8.4.4", "2001:4860:4860::8888", "2001:4860:4860::8844") -AutoUpgrade $true -AllowFallbackToUdp $true
            Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting up the DNS from Cloudflare and Google (ipv4 and ipv6)..."
            #Get-DnsClientServerAddress # To look up the current config.           # Cloudflare, Google,         Cloudflare,              Google
            Set-DNSClientServerAddress -InterfaceAlias "Ethernet*" -ServerAddresses ("1.1.1.1", "8.8.8.8", "2606:4700:4700::1111", "2001:4860:4860::8888")
            Set-DNSClientServerAddress -InterfaceAlias    "Wi-Fi*" -ServerAddresses ("1.1.1.1", "8.8.8.8", "2606:4700:4700::1111", "2001:4860:4860::8888")
        }
        else {
            Write-Status -Types "?", $TweakType -Status "Failed to set up DNS - DNSClient is not Installed..." -WriteWarning
        }

        Write-Section -Text "Ease of Access"
        Write-Caption -Text "Keyboard"
        # Disables Sticky Keys
        Write-Status -Types "-", $TweakType -Status "$($EnableStatus[0].Status) Sticky Keys..."
        Set-ItemPropertyVerified -Path "$($Variables.PathToCUAccessibility)\StickyKeys" -Name "Flags" -Value "506" -Type STRING
        Set-ItemPropertyVerified -Path "$($Variables.PathToCUAccessibility)\Keyboard Response" -Name "Flags" -Value "122" -Type STRING
        Set-ItemPropertyVerified -Path "$($Variables.PathToCUAccessibility)\ToggleKeys" -Name "Flags" -Value "58" -Type STRING

        If ($Undo) {
            Remove-ItemProperty -Path $Variables.PathToLMPoliciesTelemetry -Name AllowTelemetry -Force
            Remove-ItemProperty -Path $Variables.PathToLMPoliciesTelemetry2 -Name "AllowTelemetry" -Force
            Remove-ItemProperty -Path $Variables.PathToCUPersonalization -Name "AcceptedPrivacyPolicy" -Force
            Remove-ItemProperty -Path $Variables.PathToCUInputPersonalization -Name "RestrictImplicitTextCollection" -Force
            Remove-ItemProperty -Path $Variables.PathToCUInputPersonalization -Name "RestrictImplicitInkCollection" -Force
            Set-Service "DiagTrack" -StartupType Automatic
            Set-Service "dmwappushservice" -StartupType Automatic
            Set-Service "SysMain" -StartupType Automatic
        }

        Write-Section -Text "Privacy -> Apps Permissions"
        Write-Caption -Text "Notifications"
        Set-ItemPropertyVerified -Path $Variables.PathToLMConsentStoreUN -Name "Value" -Value "Deny" -Type String

        Write-Caption -Text "App Diagnostics"
        Set-ItemPropertyVerified -Path $Variables.PathToCUConsentStoreAD -Name "Value" -Value "Deny" -Type String
        Set-ItemPropertyVerified -Path $Variables.PathToLMConsentStoreAD -Name "Value" -Value "Deny" -Type String

        Write-Caption -Text "Account Info Access"
        Set-ItemPropertyVerified -Path $Variables.PathToCUConsentStoreUAI -Name "Value" -Value "Deny" -Type String
        Set-ItemPropertyVerified -Path $Variables.PathToLMConsentStoreUAI -Name "Value" -Value "Deny" -Type String

        Write-Caption -Text "Voice Activation"
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Voice Activation"
        Set-ItemPropertyVerified -Path $Variables.PathToVoiceActivation -Name "AgentActivationEnabled" -Value $Zero -Type DWord

        Write-Caption -Text "Background Apps"
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Background Apps"
        Set-ItemPropertyVerified -Path $Variables.PathToBackgroundAppAccess -Name "GlobalUserDisabled" -Value $One -Type DWord
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Background Apps Global"
        Set-ItemPropertyVerified -Path $Variables.PathToCUSearch -Name "BackgroundAppGlobalToggle" -Value $Zero -Type DWord

        Write-Caption -Text "Other Devices"
        Write-Status -Types "-", $TweakType -Status "Denying device access..."
        # Disable sharing information with unpaired devices
        Set-ItemPropertyVerified -Path "$($Variables.PathToCUDeviceAccessGlobal)\LooselyCoupled" -Name "Value" -Value "Deny" -Type String
        ForEach ($key in (Get-ChildItem $Variables.PathToCUDeviceAccessGlobal)) {
            If ($key.PSChildName -EQ "LooselyCoupled") { continue }
            Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Setting $($key.PSChildName) value to 'Deny' ..."
            Set-ItemPropertyVerified -Path "$("$($Variables.PathToCUDeviceAccessGlobal)\" + $key.PSChildName)" -Name "Value" -Value "Deny"
        }

        Write-Caption -Text "Background Apps"
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Background Apps..."
        Set-ItemPropertyVerified -Path $Variables.PathToBackgroundAppAccess -Name "GlobalUserDisabled" -Type DWord -Value 0
        Set-ItemPropertyVerified -Path $Variables.PathToCUSearch -Name "BackgroundAppGlobalToggle" -Type DWord -Value 1

        Write-Caption -Text "Troubleshooting"
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Automatic Recommended Troubleshooting, then notify me..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMWindowsTroubleshoot -Name "UserPreference" -Type DWord -Value 3

        Write-Section -Text "$($EnableStatus[0].Status) More Telemetry Features..."

        Write-Status -Types "?", $TweakType -Status "From Path: [$PathToCUPoliciesCloudContent]." -WriteWarning
        ForEach ($Name in $Variables.CloudContentDisableOnOne) {
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) $($Name): $One"
            Set-ItemPropertyVerified -Path $Variables.PathToCUPoliciesCloudContent -Name "$Name" -Type DWord -Value $One
        }
        Set-ItemPropertyVerified -Path $Variables.PathToCUPoliciesCloudContent -Name "ConfigureWindowsSpotlight" -Type DWord -Value 2
        Set-ItemPropertyVerified -Path $Variables.PathToCUPoliciesCloudContent -Name "IncludeEnterpriseSpotlight" -Type DWord -Value $Zero

        # Disabling app suggestions
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Apps Suggestions..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesCloudContent -Name "DisableThirdPartySuggestions" -Type DWord -Value $One
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesCloudContent -Name "DisableWindowsConsumerFeatures" -Type DWord -Value $One


        # Reference: https://forums.guru3d.com/threads/windows-10-registry-tweak-for-disabling-drivers-auto-update-controversy.418033/
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) automatic driver updates..."
        # [@] (0 = Yes, do this automatically, 1 = No, let me choose what to do, Always install the best, 2 = [...] Install driver software from Windows Update, 3 = [...] Never install driver software from Windows Update
        Set-ItemPropertyVerified -Path $Variables.PathToLMDeviceMetaData -Name "PreventDeviceMetadataFromNetwork" -Type DWord -Value $One
        # [@] (0 = Enhanced icons enabled, 1 = Enhanced icons disabled)
        Set-ItemPropertyVerified -Path $Variables.PathToLMDriverSearching -Name "SearchOrderConfig" -Type DWord -Value $Zero


        ## Performance Tweaks and More Telemetry
        Set-ItemPropertyVerified -Path $Variables.PathToLMControl -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
        Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name "MenuShowDelay" -Type DWord -Value 1
        Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name "WaitToKillAppTimeout" -Type DWord -Value 5000
        Remove-ItemProperty -Path $Variables.PathToCUControlPanelDesktop -Name "HungAppTimeout"
        # Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name "HungAppTimeout" -Type DWord -Value 4000 # Note: This caused flickering
        Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name "AutoEndTasks" -Type DWord -Value 1
        Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name "LowLevelHooksTimeout" -Type DWord -Value 1000
        Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000
        Set-ItemPropertyVerified -Path $Variables.PathToLMMemoryManagement -Name "ClearPageFileAtShutdown" -Type DWord -Value 0
        Set-ItemPropertyVerified -Path $Variables.PathToCUMouse -Name "MouseHoverTime" -Type DWord -Value 10

        # Network Tweaks
        Set-ItemPropertyVerified -Path $Variables.PathToLMLanmanServer -Name "IRPStackSize" -Type DWord -Value 20

        # Gaming Tweaks
        Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfileOnGameTasks -Name "GPU Priority" -Type DWord -Value 8
        Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfileOnGameTasks -Name "Priority" -Type DWord -Value 6
        Set-ItemPropertyVerified -Path $Variables.PathToLMMultimediaSystemProfileOnGameTasks -Name "Scheduling Category" -Type String -Value "High"

        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesSQMClient -Name "CEIPEnable" -Type DWord -Value $Zero
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesAppCompact -Name "AITEnable" -Type DWord -Value $Zero
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesAppCompact -Name "DisableUAR" -Type DWord -Value $One

        # Details: https://docs.microsoft.com/pt-br/windows-server/remote/remote-desktop-services/rds-vdi-recommendations-2004#windows-system-startup-event-traces-autologgers
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) some startup event traces (AutoLoggers)..."
        Set-ItemPropertyVerified -Path "$($Variables.PathToLMAutoLogger)\AutoLogger-Diagtrack-Listener" -Name "Start" -Type DWord -Value $Zero
        Set-ItemPropertyVerified -Path "$($Variables.PathToLMAutoLogger)\SQMLogger" -Name "Start" -Type DWord -Value $Zero

        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'WiFi Sense: HotSpot Sharing'..."
        Set-ItemPropertyVerified -Path "$($Variables.PathToLMPoliciesToWifi)\AllowWiFiHotSpotReporting" -Name "value" -Type DWord -Value $Zero

        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) 'WiFi Sense: Shared HotSpot Auto-Connect'..."
        Set-ItemPropertyVerified -Path "$($Variables.PathToLMPoliciesToWifi)\AllowAutoConnectToWiFiSenseHotspots" -Name "value" -Type DWord -Value $Zero

        Write-Caption -Text "Deleting useless registry keys..." -Type None
        ForEach ($Key in $Variables.KeysToDelete) {
            $KeyExist = Test-Path $key
            If ($KeyExist -eq $true) {
                Write-Status -Types "-", $TweakType -Status "Removing Key: [$Key]"
                Remove-Item $Key -Recurse
            }
        }
    }
}
Function Optimize-Security {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Int]    $Zero = 0,
        [Int]    $One = 1,
        [Int]    $OneTwo = 1,
        [Switch] $Undo
    )
    Show-ScriptStatus -TweakType "Security" -TitleText "Security"
    $EnableStatus = @(
        @{ Symbol = "-"; Status = "Disabling"; } # 0 = Disabled
        @{ Symbol = "+"; Status = "Enabling"; } # 1 = Enabled
    )

    If (($Undo)) {
        Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Undo'."
        $Zero = 1
        $One = 0
        $OneTwo = 2
        $EnableStatus = @(
            # Reversed
            @{ Symbol = "+"; Status = "Enabling"; } # 0 = Disabled
            @{ Symbol = "-"; Status = "Disabling"; } # 1 = Enabled
        )
    }
    
    if ($PSCmdlet.ShouldProcess("Optimize-Security", "Application of various patches, tighten Security")) {
        Write-Section "Security Patch"
        Write-Status -Types $EnableStatus[1], $TweakType -Status "Applying Security Vulnerability Patch CVE-2023-36884 - Office and Windows HTML Remote Code Execution Vulnerability"
        $SecurityPath = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BLOCK_CROSS_PROTOCOL_FILE_NAVIGATION"
        Set-ItemPropertyVerified -Path $SecurityPath -Name "Excel.exe" -Type DWORD -Value $One
        Set-ItemPropertyVerified -Path $SecurityPath -Name "Graph.exe" -Type DWORD -Value $One
        Set-ItemPropertyVerified -Path $SecurityPath -Name "MSAccess.exe" -Type DWORD -Value $One
        Set-ItemPropertyVerified -Path $SecurityPath -Name "MSPub.exe" -Type DWORD -Value $One
        Set-ItemPropertyVerified -Path $SecurityPath -Name "Powerpnt.exe" -Type DWORD -Value $One
        Set-ItemPropertyVerified -Path $SecurityPath -Name "Visio.exe" -Type DWORD -Value $One
        Set-ItemPropertyVerified -Path $SecurityPath -Name "WinProj.exe" -Type DWORD -Value $One
        Set-ItemPropertyVerified -Path $SecurityPath -Name "WinWord.exe" -Type DWORD -Value $One
        Set-ItemPropertyVerified -Path $SecurityPath -Name "Wordpad.exe" -Type DWORD -Value $One

        Write-Section "Windows Firewall"
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$(EnableStatus[1].Status) default firewall profiles..."
        Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True

        Write-Section "Windows Defender"
        try { 
            If ($Undo){
                Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) detection for potentially unwanted applications and block them..." -NoNewLine
                Set-MpPreference -PUAProtection Enabled -Force
                Get-Status
                Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Microsoft Defender Exploit Guard network protection..." -NoNewLine
                Set-MpPreference -EnableNetworkProtection Disabled -Force
                Get-Status
            }else{
                Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) detection for potentially unwanted applications and block them..." -NoNewLine
                Set-MpPreference -PUAProtection Enabled -Force
                Get-Status
                Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Microsoft Defender Exploit Guard network protection..." -NoNewLine
                Set-MpPreference -EnableNetworkProtection Enabled -Force
                Get-Status
            }
        }catch {
            Write-Caption $_ -Type Failed
            continue
        }

        Write-Section "SmartScreen"
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) 'SmartScreen' for Microsoft Edge..."
        Set-ItemPropertyVerified -Path "$($Variables.PathToLMPoliciesEdge)\PhishingFilter" -Name "EnabledV9" -Type DWord -Value $One

        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) 'SmartScreen' for Store Apps..."
        Set-ItemPropertyVerified -Path $Variables.PathToCUAppHost-Name "EnableWebContentEvaluation" -Type DWord -Value $One

        Write-Section "Old SMB Protocol"
        try { 
            Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) SMB 1.0 protocol..." -NoNewLine
            Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force
            Get-Status
        }catch {
            Write-Caption $_ -Type Failed
            continue
        }

        Write-Section "Old .NET cryptography"
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) .NET strong cryptography..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMOldDotNet -Name "SchUseStrongCrypto" -Type DWord -Value $One
        Set-ItemPropertyVerified -Path $Variables.PathToLMWowNodeOldDotNet -Name "SchUseStrongCrypto" -Type DWord -Value $One

        Write-Section "Autoplay and Autorun (Removable Devices)"
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Autoplay..."
        Set-ItemPropertyVerified -Path "$($Variables.PathToCUExplorer)\AutoplayHandlers" -Name "DisableAutoplay" -Type DWord -Value $One

        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Autorun for all Drives..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesExplorer -Name "NoDriveTypeAutoRun" -Type DWord -Value 255

        Write-Section "Windows Explorer"
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Show file extensions in Explorer..."
        Set-ItemPropertyVerified -Path "$($Variables.PathToCUExplorerAdvanced)" -Name "HideFileExt" -Type DWord -Value $Zero

        Write-Section "User Account Control (UAC)"
        If (!$Undo){
            Write-Status -Types "+", $TweakType -Status "Raising UAC level..."
            Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesSystem -Name "ConsentPromptBehaviorAdmin" -Type DWord -Value 5
            Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesSystem -Name "PromptOnSecureDesktop" -Type DWord -Value 1
        }

        Write-Section "Windows Update"
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) offer Malicious Software Removal Tool via Windows Update..."
        Set-ItemPropertyVerified -Path $Variables.PathToLMPoliciesMRT -Name "DontOfferThroughWUAU" -Type DWord -Value $Zero
    }
}


Function Optimize-Service {
    [CmdletBinding()]
    param (
        [Parameter()]
        [Switch]$Undo
    )
    Show-ScriptStatus -TweakType "Services" -TitleText "Services"
    ## Obsolete code
    If ($Undo) {
        Write-Status -Types "*", "Services" -Status "Reverting the tweaks is set to '$Undo'."
        Set-ServiceStartup -State 'Manual' -Services $Variables.ServicesToDisabled -Filter $Variables.EnableServicesOnSSD
    }
    Else {
        Set-ServiceStartup -State 'Disabled' -Services $Variables.ServicesToDisabled -Filter $Variables.EnableServicesOnSSD
    }
    ##

    Write-Section "Enabling services from Windows"
    If ($Variables.IsSystemDriveSSD -or $Undo) {
        Set-ServiceStartup -State 'Automatic' -Services $Variables.EnableServicesOnSSD
    }
    Set-ServiceStartup -State 'Manual' -Services $Variables.ServicesToManual
}
function Optimize-SSD {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter()]
        [Switch]$Undo
    )
    if ($PSCmdlet.ShouldProcess("Get-Program", "Perform program installation")) {
        # SSD life improvement
        Write-Section "SSD Optimization"
        If ($Undo) {
            Write-Status -Types "+" -Status "Enabling last access timestamps updates on files" -NoNewLine
            fsutil behavior set DisableLastAccess 0
        }else {
            Write-Status -Types "+" -Status "Disabling last access timestamps updates on files" -NoNewLine
            fsutil behavior set DisableLastAccess 1
        }
        Get-Status
    }
}
Function Optimize-TaskScheduler {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Switch]$Undo
    )
    Show-ScriptStatus -TweakType "TaskScheduler" -TitleText "Task Scheduler"
    if ($PSCmdlet.ShouldProcess("Get-Program", "Perform program installation")) {
        If ($Undo) {
            Write-Status -Types "*", $TweakType -Status "Reverting the tweaks is set to '$Undo'."
            $CustomMessage = { "Resetting the $ScheduledTask task as 'Ready' ..." }
            Set-ScheduledTaskState -Ready -ScheduledTask $Variables.DisableScheduledTasks -CustomMessage $CustomMessage
        }
        Else {
            Set-ScheduledTaskState -Disabled -ScheduledTask $Variables.DisableScheduledTasks
        }
        
        Write-Section -Text "Enabling Scheduled Tasks from Windows"
        Set-ScheduledTaskState -Ready -ScheduledTask $Variables.EnableScheduledTasks
    }
}
    Function Optimize-WindowsOptional {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Switch]$Undo
    )
    Show-ScriptStatus -TweakType "OptionalFeatures" -TitleText "Optional Features"
    if ($PSCmdlet.ShouldProcess("Get-Program", "Perform program installation")) {
        If ($Undo) {
            Write-Status -Types "*", "OptionalFeature" -Status "Reverting the tweaks is set to '$Undo'."
            $CustomMessage = { "Re-Installing the $OptionalFeature optional feature..." }
            Set-OptionalFeatureState -Enabled -OptionalFeatures $Variables.DisableFeatures -CustomMessage $CustomMessage
        }
        Else {
            Set-OptionalFeatureState -Disabled -OptionalFeatures $Variables.DisableFeatures
        }
        
        Write-Section -Text "Install Optional Features from Windows"
        Set-OptionalFeatureState -Enabled -OptionalFeatures $Variables.EnableFeatures
        
        
        Write-Section -Text "Removing Unnecessary Printers"
        $printers = "Microsoft XPS Document Writer", "Fax", "OneNote"
        foreach ($printer in $printers) {
            $PrinterExists = Get-Printer -Name $Printer -ErrorAction SilentlyContinue
            If ($PrinterExists) {
                try {
                    Write-Status -Types "-", "Printer" -Status "Attempting removal of $printer..." -NoNewLine
                    Remove-Printer -Name $printer -ErrorAction Stop
                    Get-Status
                }
                catch {
                    Get-Error $_
                    Write-Status -Types "?", "Printer" -Status "Failed to remove $printer :`n$($_)" -WriteWarning
                }
            }
        }
    }
}

function Remove-InstalledProgram {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [parameter(Mandatory = $True)]
        $Name
    )

    $uninstall32 = Get-ChildItem "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" |
        ForEach-Object { Get-ItemProperty $_.PSPath } |
        Where-Object { $_.DisplayName -like "*$Name*" } |
        Select-Object UninstallString

    $uninstall64 = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" |
        ForEach-Object { Get-ItemProperty $_.PSPath } |
        Where-Object { $_.DisplayName -like "*$Name*" } |

        Select-Object UninstallString
        if ($uninstall64) {
            if ($PSCmdlet.ShouldProcess("Uninstalling program: $Name")) {
                $uninstall64 = $uninstall64.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
                $uninstall64 = $uninstall64.Trim()
                #Write-Output "Uninstalling $Name..."

                Write-Status -Types "-", "x64" -Status "Uninstalling $Name..." -NoNewLine

                try {
                    $process = Start-Process "msiexec.exe" -ArgumentList "/X $uninstall64 /qb" -Wait -PassThru
                    $exitCode = $process.ExitCode
                    if ($exitCode -eq 0) {
                        $Global:LogEntry.Successful = $True
                        Write-Output "Uninstall of $Name succeeded with exit code $exitCode."
                        Add-Content -Path $Variables.Log -Value $logEntry
                    } else {
                        $Global:LogEntry.Successful = $false
                        $status = "Uninstall of $Name failed with exit code $exitCode."
                        Write-Output $status
                        Add-Content -Path $Variables.Log -Value $logEntry
                        Add-Content -Path $Variables.Log -Value $status
                    }
                }
                catch {
                    $status = "Uninstall of $Name failed with error: $_"
                    Write-Output $status
                    Add-Content -Path $Variables.Log -Value $status
                }
            }
        }


        if ($uninstall32) {
            if ($PSCmdlet.ShouldProcess("Uninstalling program: $Name")) {
                $uninstall32 = $uninstall32.UninstallString -Replace "msiexec.exe","" -Replace "/I","" -Replace "/X",""
                $uninstall32 = $uninstall32.Trim()
                
                #Write-Output "Uninstalling $Name..."
                Write-Status -Types "-", "x86" -Status "Uninstalling $Name..." -NoNewLine
                
                try {
                    $process = Start-Process "msiexec.exe" -ArgumentList "/X $uninstall32 /qb" -Wait -PassThru
                    if ($exitCode -eq 0) {
                        $Global:LogEntry.Successful = $True
                        Write-Output "Uninstall of $Name succeeded with exit code $exitCode."
                        Add-Content -Path $Variables.Log -Value $logEntry
                    } else {
                        $Global:LogEntry.Successful = $false
                        $status = "Uninstall of $Name failed with exit code $exitCode."
                        Write-Output $status
                        Add-Content -Path $Variables.Log -Value $logEntry
                        Add-Content -Path $Variables.Log -Value $status
                    }
                }
                catch {
                    $status = "Uninstall of $Name failed with error: $_"
                    Write-Output $status
                    Add-Content -Path $Variables.Log -Value $status
                }
            }
        }   
}



Function Remove-Office {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param()

    $confirmationMessage = "Office was found on this system. Do you want to remove it?"
    $actionDescription = "Remove Office"
    if ($PSCmdlet.ShouldProcess($actionDescription, $confirmationMessage)) {
        $msgBoxInput = Show-Question -Buttons YesNo -Message "Office was found on this system. Should I remove it?" -Icon Warning
        switch ($msgBoxInput) {
            'Yes' {
                $actionDescription = "Downloading Microsoft Support and Recovery Assistant (SaRA)..."
                try {
                    Write-Status "+", $TweakType -Status "Downloading Microsoft Support and Recovery Assistant (SaRA)..." -NoNewLine
                    Get-NetworkStatus
                    Start-BitsTransfer -Source $Variables.SaRAURL -Destination $Variables.SaRA -TransferType Download -Dynamic | Out-Host
                    Get-Status
                    Write-Status "+", $TweakType -Status "Expanding SaRA" -NoNewLine
                    Expand-Archive -Path $Variables.SaRA -DestinationPath $Variables.Sexp -Force
                    Get-Status
                }
                catch {
                    Get-Error $_
                }

                $SaRAcmdexe = (Get-ChildItem $Variables.Sexp -Include SaRAcmd.exe -Recurse).FullName
                $actionDescription = "Starting OfficeScrubScenario via Microsoft Support and Recovery Assistant (SaRA)..."
                try {
                    Write-Status "+", $TweakType -Status $actionDescription -NoNewLine
                    Start-Process $SaRAcmdexe -ArgumentList "-S OfficeScrubScenario -AcceptEula -OfficeVersion All"
                    Get-Status
                }
                catch {
                    Get-Error $_
                }
            }
            'No' {
                Write-Status -Types "?" -Status "Skipping Office Removal" -WriteWarning
                Add-Content -Path $Variables.Log -Value $logEntry
            }
        }
    }
}
Function Remove-PinnedStartMenu {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param()

    $confirmationMessage = "This action will remove pinned items from the Start menu. Do you want to proceed?"
    $actionDescription = "Remove Pinned Start Menu Items"
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
    if ($PSCmdlet.ShouldProcess($actionDescription, $confirmationMessage)) {
        $layoutFile="C:\Windows\StartMenuLayout.xml"
            #Delete layout file if it already exists
            Get-Item $LayoutFile -ErrorAction SilentlyContinue | Remove-Item

            #Creates the blank layout file
            $START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII

            #Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
            $regAliases = @("HKLM", "HKCU")# | % {
            foreach ($regAlias in $regAliases) {
                $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
                $keyPath = $basePath + "\Explorer"
                Set-ItemPropertyVerified -Path $keyPath -Name "LockedStartLayout" -Value 1 -Type DWORD
                Set-ItemPropertyVerified -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile -Type ExpandString
            }

            #Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
            Restart-Explorer

            Start-Sleep -s 5
            # CTRL + ESCAPE
            $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
            Start-Sleep -s 5

            #Enable the ability to pin items again by disabling "LockedStartLayout"
            foreach ($regAlias in $regAliases) {
                $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
                $keyPath = $basePath + "\Explorer"
                Set-ItemPropertyVerified -Path $keyPath -Name "LockedStartLayout" -Value 0 -Type DWORD
            }

            #Restart Explorer and delete the layout file
            Restart-Explorer
            # Uncomment the next line to make clean start menu default for all new users
            Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive
            Remove-Item $layoutFile
    }
}
Function Remove-UWPAppx {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Array] $AppxPackages
    )
    $TweakType = "UWP"
    $ProgressPreference = 'SilentlyContinue'
    ForEach ($AppxPackage in $AppxPackages) {
        $appxPackageToRemove = Get-AppxPackage -AllUsers -Name $AppxPackage
        if ($appxPackageToRemove) {
            $actionDescription = "Removing $AppxPackage"
            if ($PSCmdlet.ShouldProcess($actionDescription, "Do you want to remove the app $AppxPackage?")) {
                $appxPackageToRemove | ForEach-Object -Process {
                    Write-Status -Types "-", $TweakType -Status "Trying to remove $AppxPackage" -NoNewLine
                    Remove-AppxPackage $_.PackageFullName -ErrorAction Continue | Out-Null
                    Get-Status
                    If ($?) {
                        $Variables.Removed++
                        $Variables.PackagesRemoved += "$appxPackageToRemove.PackageFullName`n"
                    }
                    elseif (!($?)) {
                        $Variabless.Failed++
                    }
                    Write-Status -Types "-", $TweakType -Status "Trying to remove provisioned $AppxPackage" -NoNewLine
                    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $AppxPackage | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null
                    Get-Status
                    If ($?) {
                        $Variables.Removed++
                        $Variables.PackagesRemoved += "Provisioned Appx $($appxPackageToRemove.PackageFullName)`n"
                    }
                    elseif (!($?)) {
                        $Variables.Failed++
                    }
                }
            }
        }
        else { $Variables.NotFound++ }
    }
    $ProgressPreference = "Continue"
}
Function Restart-Explorer {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param()
    # Checks is explorer is running
    $confirmationMessage = "This action will restart Windows Explorer. Do you wish to continue?"
    $actionDescription = "Restarts Windows Explorer."
    if ($PSCmdlet.ShouldProcess($actionDescription, $confirmationMessage)) {
        $ExplorerActive = Get-Process -Name explorer
        if ($ExplorerActive) {
            try {
                taskkill /f /im explorer.exe
            }
            catch {
                Write-Warning "Failed to stop Explorer process: $_"
                Get-Error $_
                Continue
            }
        }
        try {
            Start-Process explorer -Wait
        }
        catch {
            Write-Error "Failed to start Explorer process: $_"
            Get-Error $_
            Continue
        }
    }
}
Function Request-PCRestart {
    Param()
    Write-Status -Types "WAITING" -Status "User action needed - You may have to ALT + TAB " -WriteWarning
    $restartMessage = "For changes to apply please restart your computer. Ready?"
    switch (Show-Question -Chime -Buttons YesNoCancel -Title "New Loads Completed" -Icon Warning -Message $restartMessage) {
        'Yes' {
            Write-Host "You choose to Restart now"
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
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param (
        [Switch]$Undo,
        [Switch]$NoBranding
    )
    $Page = "Model"
    If ($Undo){
        $Branding = @{
            store = ""
            phone = ""
            hours = ""
            url   = ""
            model = ""
        }
    }else {
        $Branding = @{
            store = "Mother Computers"
            phone = "(250) 479-8561"
            hours = "Mon-Sat  9 AM - 5 PM | Sunday: Closed"
            url   = "https://www.mothercomputers.com"
            model = "Mother Computers - (250) 479-8561"
        }
    }
    if ($PSCmdlet.ShouldProcess('Set-Branding', "Mother Computers Branding")) {
    
        Show-ScriptStatus -WindowTitle "Branding" -TweakType "Branding" -TitleText "Branding" -TitleCounterText "Mother Branding"
        If (!$NoBranding) {
            # - Adds Mother Computers support info to About.
            Write-Status -Types "+", $TweakType -Status "Adding Mother Computers to Support Page"
            Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name "Manufacturer" -Type String -Value $Branding.store
            Write-Status -Types "+", $TweakType -Status "Adding Mothers Number to Support Page"
            Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name "SupportPhone" -Type String -Value $Branding.phone
            Write-Status -Types "+", $TweakType -Status "Adding Store Hours to Support Page"
            Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name "SupportHours" -Type String -Value $Branding.hours
            Write-Status -Types "+", $TweakType -Status "Adding Store URL to Support Page"
            Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name "SupportURL" -Type String -Value $Branding.website
            Write-Status -Types "+", $TweakType -Status "Adding Store Number to Settings Page"
            Set-ItemPropertyVerified -Path $Variables.PathToOEMInfo -Name $page -Type String -Value $Branding.Model
        }
        else {
            Write-Status -Types "@" -Status "Parameter -NoBranding detected.. Skipping Mother Computers branding" -WriteWarning -ForegroundColorText RED
        }
    }
    else {
        Write-Host "$actionDescription operation canceled."
    }
}
Function Set-ItemPropertyVerified {
    Param(
        [Alias("V")]
        [Parameter(Mandatory = $true)]
        $Value,

        [Alias("N")]
        [Parameter(Mandatory = $true)]
        $Name,

        [Alias("T")]
        [Parameter(Mandatory = $true)]
        [ValidateSet("String", "ExpandString", "Binary", "DWord", "MultiString", "QWord", "Unknown")]
        $Type,

        [Alias("P")]
        [Parameter(Mandatory = $true)]
        $Path,

        [Alias("F")]
        [Parameter(Mandatory = $False)]
        [Switch]$Force,

        [Parameter(Mandatory = $False)]
        [Switch]$Passthru
    )

    $keyExists = Test-Path -Path $Path
    if (!$keyExists) {
        New-Item -Path $Path -Force | Out-Null
        $Global:CreatedKeys++
    }

    $currentValue = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue
    if ($null -eq $currentValue -or $currentValue.$Name -ne $Value) {
        try {
            Write-Status -Types "+" -Status "$Name set to $Value in $Path" -NoNewLine

            $params = @{
                Path          = $Path
                Name          = $Name
                Value         = $Value
                Type          = $Type
                ErrorAction   = 'Stop'
                Passthru      = $Passthru
                WarningAction = $warningPreference
            }

            if ($Force) {
                $params['Force'] = $true
            }
            Set-ItemProperty @params

            if ($? -eq $True) {
                Get-Status
                $Global:ModifiedRegistryKeys++
            }
            else {
                Get-Status
                $Global:FailedRegistryKeys++
            }
        }
        catch {
            Get-Error $_
            Continue
        }
    }
    else {
        Write-Status -Types "@" -Status "Key already set to the desired value. Skipping"
    }
}
Function Set-OptionalFeatureState {
    param (
        [ScriptBlock] $CustomMessage,
        [Switch] $Enabled,
        [Switch] $Disabled,
        #[Array] $Filter,
        #[Parameter(Mandatory = $true)]
        [Array] $OptionalFeatures
    )

    $SecurityFilterOnEnable = @("IIS-*")
    $TweakType = "OptionalFeature"

    $OptionalFeatures | ForEach-Object {
        $feature = Get-WindowsOptionalFeature -Online -FeatureName $_
        if ($feature) {
            if ($_.DisplayName -in $Filter) {
                Write-Status -Types "@", $TweakType -Status "The $_ ($($feature.DisplayName)) will be skipped as set on Filter..."
                return
            }

            if (($_.DisplayName -in $SecurityFilterOnEnable) -and $Enabled) {
                Write-Status -Types "@", $TweakType -Status "Skipping $_ ($($feature.DisplayName)) to avoid a security vulnerability..." -WriteWarning
                return
            }

            if (!$CustomMessage) {
                if ($Disabled) {
                    Write-Status -Types "-", $TweakType -Status $actionDescription -NoNewLine
                    try {
                        $feature | Where-Object State -Like "Enabled" | Disable-WindowsOptionalFeature -Online -NoRestart -WhatIf:$WhatIf
                        Get-Status
                    }
                    catch {
                        Get-Error $_
                        continue
                    }
                }
                elseif ($Enabled) {
                    Write-Status -Types "+", $TweakType -Status $actionDescription -NoNewLine
                    try {
                        $feature | Where-Object State -Like "Disabled*" | Enable-WindowsOptionalFeature -Online -NoRestart -WhatIf:$WhatIf
                        Get-Status
                    }
                    catch {
                        Get-Error $_
                        continue
                    }
                }
                else {
                    Write-Status -Types "?", $TweakType -Status "No parameter received (valid params: -Disabled or -Enabled)"
                }
            }
            else {
                $customMessageText = $CustomMessage.Invoke($_)
                Write-Status -Types "@", $TweakType -Status $customMessageText
            }
        }
        else {
            $Status = "The $_ optional feature was not found."
            Write-Status -Types "?", $TweakType -Status $Status -WriteWarning
            Add-Content -Path $Variables.Log -Value $Status
        }
    }
}
function Set-ScheduledTaskState {
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
                $action = "Disable"
            }
            ElseIf ($Ready) {
                $action = "Enable"
            }
            Else {
                Write-Status -Types "?", $TweakType -Status "No parameter received (valid params: -Disabled or -Ready)" -WriteWarning
                $action = $null
            }

            If ($action) {
                Write-Status -Types $action.Substring(0, 1), $TweakType -Status "$action the $ScheduledTask task..." -NoNewLine
                Try {
                    If ($action -eq "Disable") {
                        Get-ScheduledTask -TaskName (Split-Path -Path $ScheduledTask -Leaf) | Where-Object State -Like "R*" | Disable-ScheduledTask | Out-Null  # R* = Ready/Running
                        Get-Status
                    }
                    ElseIf ($action -eq "Enable") {
                        Get-ScheduledTask -TaskName (Split-Path -Path $ScheduledTask -Leaf) | Where-Object State -Like "Disabled" | Enable-ScheduledTask | Out-Null
                        Get-Status
                    }
                }
                catch {
                    Get-Error $_
                    Continue
                }
            }
        }
    }
}
function Set-ServiceStartup {
    [CmdletBinding(SupportsShouldProcess)]
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
            If (!( Get-Service $Service -ErrorAction SilentlyContinue )) {
                $Status = "The $Service service was not found."
                Write-Status -Types "?", $TweakType -Status $Status -WriteWarning
                Add-Content -Path $Variables.Log -Value $Status
                Continue
            }

            If (($Service -in $SecurityFilterOnEnable) -and (($State -eq 'Automatic') -or ($State -eq 'Manual'))) {
                $Status = "Skipping $Service ($((Get-Service $Service).DisplayName)) to avoid a security vulnerability..."
                Write-Status -Types "!", $TweakType -Status $Status -WriteWarning
                Add-Content -Path $Variables.Log -Value $Status
                Continue
            }

            If ($Service -in $Filter) {
                $Status = "The $Service ($((Get-Service $Service).DisplayName)) will be skipped as set on Filter..."
                Write-Status -Types "!", $TweakType -Status $Status -WriteWarning
                Add-Content -Path $Variables.Log -Value $Status
                Continue
            }

            Try {
                $target = "$Service ($(( Get-Service $Service).DisplayName )) as '$State' on Startup"
                Write-Status -Types "@", $TweakType -Status "Setting $target" -NoNewLine
                If ($WhatIf) {
                    Get-Service -Name "$Service" | Set-Service -StartupType $State -WhatIf
                    Get-Status
                }
                Else {
                    Get-Service -Name "$Service" | Set-Service -StartupType $State
                    Get-Status
                }
            }
            catch {
                Get-Error $_
                Continue
            }
        }
    }
}
Function Set-StartMenu {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Switch]$Skip
    )
    Show-ScriptStatus -WindowTitle "Start Menu" -TweakType "StartMenu" -TitleCounterText "Start Menu Layout" -TitleText "StartMenu"
    if ($PSCmdlet.ShouldProcess("Set-StartMenu", "Applies a Start Menu Layout")) {
        If (!$Skip){
            If ($Variables.osVersion -like "*Windows 10*") {
                Write-Section -Text "Clearing pinned start menu items for Windows 10"
                Write-Status -Types "@", $TweakType -Status "Clearing Windows 10 start pins"
                $layoutFile = "C:\Windows\StartMenuLayout.xml"
                # Delete layout file if it already exists
                # Creates the blank layout file
                If (Test-Path $layoutFile) { Remove-Item $layoutFile }
                $Varaibles.START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII

                $regAliases = @("HKLM", "HKCU")
                #Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
                foreach ($regAlias in $regAliases) {
                    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
                    $keyPath = $basePath + "\Explorer"
                    Set-ItemPropertyVerified -Path $keyPath -Name "LockedStartLayout" -Value 1 -Type DWORD
                    Set-ItemPropertyVerified -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile -Type ExpandString
                }

                #Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
                Stop-Process -name explorer

                Start-Sleep -s 5
                $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
                Start-Sleep -s 5

                #Enable the ability to pin items again by disabling "LockedStartLayout"
                foreach ($regAlias in $regAliases) {
                    $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
                    $keyPath = $basePath + "\Explorer"
                    Set-ItemPropertyVerified -Path $keyPath -Name "LockedStartLayout" -Value 0 -Type DWORD
                }


                #Restart Explorer and delete the layout file
                Stop-Process -name explorer
                # Uncomment the next line to make clean start menu default for all new users
                Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\
                Remove-Item $layoutFile
            }
            elseif ($Variables.osVersion -like "*Windows 11*") {
                Write-Section -Text "Applying start menu layout for Windows 11"
                Write-Status -Types "+", $TweakType -Status "Attempting application"
                $StartBinFiles = Get-ChildItem -Path "$newloads" -Filter "start*.bin" -file
                If (!(Test-Path -Path "$newloads\start.bin")){
                    Start-BitsTransfer -Source $Variables.StartBinURL -Destination $Newloads -Dynamic
                }
                If (!(Test-Path -Path "$newloads\start1.bin")){
                    Start-BitsTransfer -Source $Variables.StartBin2URL -Destination $Newloads -Dynamic
                }
                $StartBinFiles = Get-ChildItem -Path $newloads -Filter "start*.bin" -file
                $TotalBinFiles = ($StartBinFiles).Count * 2
                $progress = 0

                Foreach ($StartBinFile in $StartBinFiles) {
                    $progress++
                    Write-Status -Types "+", $TweakType -Status "Copying $($StartBinFile.Name) for new users ($progress/$TotalBinFiles)" -NoNewLine
                    xcopy $StartBinFile.FullName $Variables.StartBinDefault /y
                    Get-Status
                    $progress++
                    Write-Status -Types "+", $TweakType -Status "Copying $($StartBinFile.Name) to current user ($progress)/$TotalBinFiles)" -NoNewLine
                    xcopy $StartBinFile.FullName $Variables.StartBinCurrent /y
                    Get-Status
                }
            }
        }
    }
}
Function Set-Taskbar {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Switch]$Undo
    )
    
    if ($PSCmdlet.ShouldProcess("Set-Taskbar", "Applies a taskbar layout")) {
        If ($Undo){
            Write-Output "Skipping Set-Taskbar"
        }else{
            Write-Status -Types "+" -Status "Applying Taskbar Layout" -NoNewLine
            If (Test-Path $Variables.layoutFile) {
                Remove-Item $Variables.layoutFile -Verbose | Out-Null
            }
            $Variables.StartLayout | Out-File $Variables.layoutFile -Encoding ASCII
            Get-Status
            Restart-Explorer
            Start-Sleep -Seconds 4
        }
    }
}
function Set-Wallpaper {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Switch]$Undo
    )
    Show-ScriptStatus -WindowTitle "Visual" -TweakType "Visuals" -TitleCounterText "Visuals"

    if ($PSCmdlet.ShouldProcess("Get-Program", "Perform program installation")) {
        If ($Undo){
            Start-Process "C:\Windows\Resources\Themes\aero.theme"
        }else {
            $WallpaperPathExists = Test-Path $Variables.wallpaperPath
            If (!$WallpaperPathExists) {
                $WallpaperURL = "https://raw.githubusercontent.com/circlol/newload/main/assets/mother.jpg"
                Write-Status "@", $TweakType -Status "Downloading Wallpaper" -NoNewLine
                Start-BitsTransfer -Source $WallpaperURL -Destination $Variables.WallpaperDestination -Dynamic
                Get-Status
            }
            Write-Status -Types "+", $TweakType -Status "Applying Wallpaper"
            Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine
            Write-Host ": Wallpaper might not Apply UNTIL System is Rebooted`n"
            If (!(Test-Path $Variables.WallpaperDestination)) {
                Write-Status -Types "+", $TweakType -Status "Copying Wallpaper to Destination" -NoNewLine
                Copy-Item -Path $Variables.wallpaperPath -Destination $Variables.WallpaperDestination -Force -Confirm:$False
                Get-Status
            }
            Write-Status -Types "+", $TweakType -Status "Setting WallpaperStyle to 'Stretch'"
            Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name WallpaperStyle -Value '2' -Type String
            Write-Status -Types "+", $TweakType -Status "Setting Wallpaper to Destination"
            Set-ItemPropertyVerified -Path $Variables.PathToCUControlPanelDesktop -Name Wallpaper -Value $Variables.WallpaperDestination -Type String
            Write-Status -Types "+", $TweakType -Status "Setting System to use Light Mode"
            Set-ItemPropertyVerified -Path $Variables.PathToRegPersonalize -Name "SystemUsesLightTheme" -Value 1 -Type DWord
            Write-Status -Types "+", $TweakType -Status "Setting Apps to use Light Mode"
            Set-ItemPropertyVerified -Path $Variables.PathToRegPersonalize -Name "AppsUseLightTheme" -Value 1 -Type DWord
            Write-Status -Types "+", $TweakType -Status "Updating Wallpaper" -NoNewLine
            Start-Process "RUNDLL32.EXE" "user32.dll, UpdatePerUserSystemParameters"
            Get-Status
        }
    }
}
Function Send-EmailLog {

    Show-ScriptStatus -WindowTitle "Email Log" #-TweakType "Email" -TitleCounterText "Email Log"
    # - Current Date and Time
    $CurrentDate = Get-Date
    $EndTime = Get-Date
    $CurrentDateFormatted = $CurrentDate.ToString("dd MMMM yyyy h:mm:ss tt")
    $FormattedStartTime = $StartTime.ToString("h:mm:ss tt")
    $FormattedEndTime = $EndTime.ToString("h:mm:ss tt")
    $ElapsedTime = $EndTime - $StartTime
    $FormattedElapsedTime = "{0:mm} minutes {0:ss} seconds" -f $ElapsedTime
    $PowershellTable = $PSVersionTable | Out-String
    $ListOfInstalledApplications = (Get-InstalledProgram "*").Name | Sort-Object
    $ListOfInstalledPackages = (Get-appxpackage -User $Env:USERNAME).Name | Sort-Object
    # - Gathers some information about host
    $SystemSpecs = Get-SystemInfo
    $IP = $(Resolve-DnsName -Name myip.opendns.com -Server 208.67.222.220).IPAddress
    $WallpaperApplied = if ($Variables.CurrentWallpaper -eq $Variables.Wallpaper) { "YES" } else { "NO" }
    # - Checks if all the programs got installed
    $ChromeYN = if (Get-InstalledProgram "Google Chrome") { "YES" } else { "NO" }
    $VLCYN = if (Get-InstalledProgram "VLC") { "YES" } else { "NO" }
    $ZoomYN = if (Get-InstalledProgram "Zoom") { "YES" } else { "NO" }
    $AdobeYN = if (Get-InstalledProgram "Acrobat") { "YES" } else { "NO" }


    # - Joins log files to send as attachments
    $LogFiles = @()
    if (Test-Path -Path $Variables.log) {
        $LogFiles += $Variables.log
    }
    if (Test-Path -Path $Variables.errorlog) {
        $LogFiles += $Variables.errorlog
    }

    # - Email Settings
    $smtp = 'smtp.shaw.ca'
    $To = '<newloads@shaw.ca>'
    $From = 'New Loads Log <newloadslogs@shaw.ca>'
    $Sub = "New Loads Log"
    $EmailBody = "
    <####################################>
    <#                                  #>
    <#          NEW LOADS LOG           #>
    <#                                  #>
    <####################################>


$ip\$env:computername\$env:USERNAME

- System Information:

$SystemSpecs


- Script Information:

- Program Version: $($Variables.ProgramVersion)
- Date: $CurrentDateFormatted
- Start Time: $FormattedStartTime
- End Time: $FormattedEndTime
- Elapsed Time: $FormattedElapsedTime

- Summary:
- Applications Installed: $appsyns
- Chrome: $ChromeYN
- VLC: $VLCYN
- Adobe: $AdobeYN
- Zoom: $ZoomYN
- Wallpaper Applied: $WallpaperApplied
- Windows 11 Start Layout Applied: $StartMenuLayout
- Registry Keys Modified: $ModifiedRegistryKeys
- Failed Registry Keys: $FailedRegistryKeys


- Powershell Table:
$PowershellTable


- Packages Removed During Debloat: $($Variables.Removed)
- List of Packages Removed:
$($Variables.PackagesRemoved)


- List of Installed Win32 Applications:
$ListOfInstalledApplications


- List of Installed Appx Packages:
$ListOfInstalledPackages

"


# - Sends the mail
Send-MailMessage -From $From -To $To -Subject $Sub -Body $EmailBody -Attachments $LogFiles -DN OnSuccess, OnFailure -SmtpServer $smtp
}
Function Show-ScriptLogo {
    $WindowTitle = "New Loads - Initialization" ; $host.UI.RawUI.WindowTitle = $WindowTitle
    Write-Host "`n`n`n"
    Write-Host "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀" -NoNewLine -ForegroundColor $Variables.ForegroundColor -BackgroundColor Blue
    Write-Host "`n`n"
    Write-Host "$($Variables.Logo)`n`n" -ForegroundColor $Variables.LogoColor -BackgroundColor Black -NoNewline
    Write-Host "                               Created by " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "Papi" -ForegroundColor Red -BackgroundColor Black -NoNewLine
    Write-Host "      Last Update: " -NoNewLine -ForegroundColor White -BackgroundColor Black
    Write-Host "$($Variables.ProgramVersion) - $($Variables.ReleaseDate)" -ForegroundColor Green -BackgroundColor Black
    Write-Host "`n`n  Notice: " -NoNewLine -ForegroundColor RED -BackgroundColor Black
    Write-Host "For best functionality, it is strongly suggested to update windows before running New Loads.`n" -ForegroundColor Yellow -BackgroundColor Black
    if ($Variables.specifiedParameters.Count -ne 0) { Write-Host "    Specified Parameters: " -ForegroundColor $Variables.LogoColor -NoNewLine ; Write-Host "$parametersString" }
    Write-Host "`n`n"
    Write-Host "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀" -ForegroundColor Blue -BackgroundColor $Variables.LogoColor
    Write-Host "`n`n"
    $WindowTitle = "New Loads" ; $host.UI.RawUI.WindowTitle = $WindowTitle
}
Function Show-ScriptStatus {
    param(
        [Switch]$AddCounter,
        [String]$SectionText,
        [String]$TitleText,
        [String]$TitleCounterText,
        [String]$TweakType,
        [String]$WindowTitle
    )
    If ($WindowTitle) {
        $host.UI.RawUI.WindowTitle = "New Loads - $WindowTitle"
    }
    If ($TweakType) {
        Set-Variable -Name 'TweakType' -Value $TweakType -Scope Global -Force
    }
    If ($TitleCounterText) {
        Write-TitleCounter -Counter $Variables.Counter -MaxLength $Variables.MaxLength -Text $TitleCounterText
    }
    If ($TitleText) {
        Write-Title -Text $TitleText
    }
    If ($SectionText) {
        Write-Section -Text "Section: $SectionText"
    }
    If ($AddCounter) {
        $Global:Variables.Counter++
    }
}
function Show-Question {
    param (
        [string]$Message,
        [string]$Title = "New Loads",
        [System.Windows.Forms.MessageBoxButtons]$Buttons = [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]$Icon = [System.Windows.Forms.MessageBoxIcon]::Information,
        [switch]$Chime = $false
    )
    If ($Chime) { Start-Chime }
    [System.Windows.Forms.MessageBox]::Show($Message, $Title, $Buttons, $Icon)
}

Function Start-BitlockerDecryption {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Switch]$Skip
    )

    Show-ScriptStatus -WindowTitle "Bitlocker" -TweakType "Bitlocker" -TitleCounterText "Bitlocker Decryption"
    If ($Skip) {
        Write-Status -Types "@" -Status "Parameter -Skip detected.. Skipping Bitlocker Decryption." -WriteWarning -ForegroundColorText RED
    }
    else {
        if ($PSCmdlet.ShouldProcess("Start-BitlockerDecryption", "Starts the decryption process for Bitlocker.")) {
            # Checks if Bitlocker is active on the host
            $bitlockerVolume = Get-BitLockerVolume -MountPoint "C:" -WarningAction SilentlyContinue
            If ($bitlockerVolume -and $bitlockerVolume.ProtectionStatus -eq "On") {
                # Starts Bitlocker Decryption
                $messagebld = "Bitlocker was detected turned on. Do you want to start the decryption process?"
                Show-Question -Buttons YesNo -Title "New Loads" -Icon Warning -Message $messagebld
                Write-Status -Types "@" -Status "Alert: Bitlocker is enabled. Starting the decryption process" -Type Warning
                Disable-BitLocker -MountPoint C:\
                Get-Status
            }
            else {
                $message = "Bitlocker is not enabled on this machine"
                Write-Status -Types "?" -Status $message
                Add-Content -Path $Variables.Log -Value $message
            }
        }
    }
}
Function Start-Bootup {
    param()
    Show-ScriptStatus -WindowTitle "Checking Requirements"

    # Checks OS version to make sure Windows is atleast v20H2 otherwise it'll display a message and close
    If ($Variables.BuildNumber -LE $Variables.MinimumBuildNumber) {
        Write-Host $Variables.errorMessage1 -ForegroundColor Yellow
        Read-Host -Prompt "Press enter to close New Loads"
        Exit
    }


    # Checks to make sure New Loads is run as admin otherwise it'll display a message and close
    If (!([bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544'))) {
        Write-Host $Variables.errorMessage2 -ForegroundColor Yellow
        do {
            $SelfElevate = Read-Host -Prompt "Would you like to run New Loads as an Administrator? (Y/N) "
            switch ($SelfElevate.ToUpper()) {
                "Y" {
                    $wtExists = Get-Command wt
                    If ($wtExists) {
                        Start-Process wt -verb runas -ArgumentList "new-tab powershell -c ""irm run.newloads.ca | iex"""
                    }
                    else { Start-Process powershell -verb runas -ArgumentList "-command ""irm run.newloads.ca | iex""" }
                    Write-Output "Exiting"
                    Stop-Process $pid
                }
                "N" { exit }
                default { Write-Host "Invalid input. Please enter Y or N." }
            }
        } while ($true)
    }
    Show-ScriptLogo
    Update-Time
    New-Variable -Name Time -Value (Get-Date -UFormat %Y%m%d) -Scope Global
    If ($Time -GT $Variables.MaxTime -or $Time -LT $Variables.MinTime) {
        Clear-Host
        Write-Status -Types ":(", "::ERROR::" -Status "There was an uncorrectable error.." -ForegroundColorText RED
        Read-Host -Prompt "Press enter to close New Loads"
        Exit
    }

    try {
        Get-Item $Variables.Log -ErrorAction SilentlyContinue | Remove-Item
    }
    catch {
        return "An error occurred while removing the files: $_"
        Continue
    }
}
function Start-Chime {
    param(
        $File = "C:\Windows\Media\Alarm06.wav"
    )
    if (Test-Path $File) {
        try {
            $soundPlayer = New-Object System.Media.SoundPlayer
            $soundPlayer.SoundLocation = $File
            $soundPlayer.Play()
            $soundPlayer.Dispose()
        }
        catch { Write-Error "An error occurred while playing the sound: $_.Exception.Message" }
    }
    else { Write-Error "The sound file doesn't exist at the specified path." }
}
Function Start-Cleanup {
[CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Switch]$Skip,
        [Switch]$Undo
    )

    Show-ScriptStatus -WindowTitle "Cleanup" -TweakType "Cleanup" -TitleCounterText "Cleanup" -TitleText "Cleanup"
    If ($Undo -or $Skip) {
        Write-Status -Types "@" -Status "Parameter -Undo or -Skip was detected.. Skipping this section." -WriteWarning -ForegroundColorText Red
    }
    else {
        if ($PSCmdlet.ShouldProcess("Get-Program", "Perform program installation")) {
            # - Starts Explorer if it isn't already running
            If (!(Get-Process -Name Explorer)) { Restart-Explorer }
            # Removes layout file if it exists
            Get-Item $Variables.layoutFile | Remove-Item
            # - Launches Chrome to initiate UBlock Origin
            Write-Status -Types "+", $TweakType -Status "Launching Google Chrome"
            Start-Process Chrome -WarningAction SilentlyContinue
            
            # - Clears Temp Folder
            Write-Status -Types "-", $TweakType -Status "Cleaning Temp Folder"
            Remove-Item "$env:temp\*.*" -Force -Recurse -Exclude "New Loads"
            
            # - Removes installed program shortcuts from Public/User Desktop
            foreach ($shortcut in $Variables.shortcuts) {
                $ShortcutExist = Test-Path $shortcut
                If ($ShortcutExist) {
                    Write-Status -Types "-", $TweakType -Status "Removing $shortcut"
                    Remove-Item -Path "$shortcut" -Force | Out-Null
                }
            }
        }
    }
}
Function Start-Debloat {
    param(
        [Switch] $Undo
    )
    Show-ScriptStatus -WindowTitle "Debloat" -TweakType "Debloat" -TitleCounterText "Debloat" -TitleText "Win32"
    If (!$Undo) {

        <# TODO - Fix Debloat Remove Win32 apps
        Write-Section -Text "TraditiFixon Win32 Applications"
        $Win32apps = @(
            "Avast"
            "ExpressVPN"
            "McAfee"
            "Norton"
            "WildTangent"
        )
        foreach ($app in $Win32apps) { Remove-InstalledProgram "$app" -ErrorAction SilentlyContinue }
        #>
        #Remove-InstalledProgram -Name "*WildTangent*" -ErrorAction SilentlyContinue
        #Remove-InstalledProgram -Name "*Norton*"-ErrorAction SilentlyContinue
        #Remove-InstalledProgram -Name "*McAfee*"-ErrorAction SilentlyContinue
        #Remove-InstalledProgram -Name "*ExpressVPN*"-ErrorAction SilentlyContinue
        #Remove-InstalledProgram -Name "*Avast*"-ErrorAction SilentlyContinue



        Write-Section -Text "Start Menu Ads (.url, .lnk)"
        ForEach ($app in $apps) {
            try {
                if (Test-Path -Path "$commonapps\$app.url") {
                    # - Checks common start menu .urls
                    Write-Status -Types "-", "$TweakType", "$TweakTypeLocal" -Status "Removing $app.url" -NoNewLine
                    Remove-Item -Path "$commonapps\$app.url" -Force
                    Get-Status
                }
                if (Test-Path -Path "$commonapps\$app.lnk") {
                    # - Checks common start menu .lnks
                    Write-Status -Types "-", "$TweakType", "$TweakTypeLocal" -Status "Removing $app.lnk" -NoNewLine
                    Remove-Item -Path "$commonapps\$app.lnk" -Force
                    Get-Status
                }
            }
            catch {
                Write-Status -Types "!", "$TweakType", "$TweakTypeLocal" -Status "An error occurred while removing $app`: $_"
            }
        }

        Write-Section -Text "UWP Apps"
        $TotalItems = $Variables.Programs.Count
        $CurrentItem = 0
        $PercentComplete = 0
        ForEach ($Program in $Variables.Programs) {
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
        Write-Host "Packages Removed: " -NoNewline -ForegroundColor Gray
        Write-Host $Variables.Removed -ForegroundColor Green
        If ($Failed) { Write-Host "Failed: " -NoNewline -ForegroundColor Gray
        Write-Host $Variables.Failed -ForegroundColor Red
        }
        Write-Host "Packages Scanned For: " -NoNewline -ForegroundColor Gray
        Write-Host "$($Variables.NotFound)`n" -ForegroundColor Yellow
    }
    elseif ($Undo) {
        Write-Status -Types "+", "Appx" -Status "Reinstalling Default Apps from manifest"
        Get-AppxPackage -allusers | ForEach-Object { Add-AppxPackage -register "$($_.InstallLocation)\appxmanifest.xml" -DisableDevelopmentMode } | Out-Host
    }
}

function Update-Time {
    param (
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
                Start-Service -Name W32Time -ErrorAction SilentlyContinue
                Get-Status
            }
            catch {
                Get-Error $_
                continue
            }
        }


        Write-Status -Types "F5" -Status "Syncing Time"
        If ((Get-Service W32Time).StartType -eq "Disabled"){
            Set-Service W32Time -StartupType Manual
        }
        If ((Get-Service W32Time).Status -ne "Running"){
            Start-Service 
        }
        try {
            $resyncOutput = w32tm /resync
            if ($resyncOutput -like "*The computer did not resync because the required time change was too big.*") {
                w32tm /resync /force
            }
        }
        catch {
            w32tm /resync /force
        }


        $resyncOutput = w32tm /resync /force
        if ($resyncOutput -like "*The computer did not resync because the required time change was too big.*") {
            Write-Status -Types "@" -Status "Time change is too big. Setting time manually." -WriteWarning
            #New-Variable -Name currentDateTime -Value (Get-Date) -Force -Scope Global
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



Function Write-Break {
    Write-Host "`n`n[" -NoNewline -ForegroundColor $Variables.ForegroundColor -Backgroundcolor $Variables.BackgroundColor
    Write-Host "================================================================================================" -NoNewLine -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host "]`n" -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
}
Function Write-Caption {
    [CmdletBinding()]
    param (
        [ValidateSet("Failed", "Success", "Warning", "none")]
        [String] $Type = "none",
        [String] $Text = "No Text"
    )
    If ($Text -ne "No Text") { $OverrideText = $Text }

    switch ($Type) {
        "Failed" {
            $foreg = "DarkRed"
            $foreg1 = "Red"
            $symbol = "X"
            $text = "Failed"
        }
        "Success" {
            $foreg = "DarkGreen"
            $foreg1 = "Green"
            $symbol = "√"
            $text = "Success"
        }
        "Warning" {
            $foreg = "DarkYellow"
            $foreg1 = "Yellow"
            $symbol = "!"
            $text = "Warning"
        }"None" {
            $foreg = "white"
            $foreg1 = "Gray"
            $symbol = ""
            $text = ""
        }
    }
    If ($OverrideText) { $Text = $OverrideText }
    Write-Host "  " -NoNewline #-ForegroundColor $foreg
    Write-Host $Symbol -NoNewline -ForegroundColor $foreg1
    Write-Host "$Text" -ForegroundColor $foreg
}
Function Write-HostReminder {
    [CmdletBinding()]
    param (
        [String] $Text = "Example text"
    )
    Write-Host "[" -BackgroundColor $Variables.BackgroundColor -ForegroundColor $Variables.ForegroundColor -NoNewline
    Write-Host " REMINDER " -BackgroundColor Red -ForegroundColor White -NoNewLine
    Write-Host "]" -BackgroundColor $Variables.BackgroundColor -ForegroundColor $Variables.ForegroundColor -NoNewline
    Write-Host ": $text`n"
}
Function Write-Section {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )
    Write-Host "`n<" -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "=================" -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host "] " -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host "[" -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "=================" -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host ">" -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
}
Function Write-Status1 {
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
    If ($WriteWarning -eq $True -And $ForegroundColorText -eq "White") {
        $ForegroundColorText = "Yellow"
    }
    # Prints date in line, converts to Month Day Year Hour Minute Period
    $Time = Get-Date
    $FormattedTime = $Time.ToString("h:mm:ss tt")
    Write-Host "$FormattedTime " -NoNewline -ForegroundColor DarkGray -BackgroundColor $Variables.BackgroundColor

    ForEach ($Type in $Types) {
        Write-Host "$Type " -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    }

    If ($WriteWarning) {
        Write-Host "::Warning:: -> $Status" -ForegroundColor $ForegroundColorText -BackgroundColor $Variables.BackgroundColor -NoNewline:$NoNewLine
    }
    Else {
        Write-Host "-> $Status" -ForegroundColor $ForegroundColorText -BackgroundColor $Variables.BackgroundColor -NoNewline:$NoNewLine
    }
}
Function Write-Status {
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

    If ($WriteWarning -eq $True -And $ForegroundColorText -eq "White") {
        $ForegroundColorText = "Yellow"
    }

    # Prints date in line, converts to Month Day Year Hour Minute Period
    $Time = Get-Date
    $FormattedTime = $Time.ToString("h:mm:ss tt")

    $LogEntry = [PSCustomObject]@{
        Time       = "$FormattedTime"
        Successful = ""
        Types      = $Types -join ', '
        Status     = $Status
    }
    $Global:LogEntry = $LogEntry
    # Output the log entry to the console
    Write-Host "$FormattedTime " -NoNewline -ForegroundColor DarkGray -BackgroundColor $Variables.BackgroundColor

    ForEach ($Type in $Types) {
        Write-Host "$Type " -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    }

    If ($WriteWarning) {
        Write-Host "::Warning:: -> $Status" -ForegroundColor $ForegroundColorText -BackgroundColor $Variables.BackgroundColor -NoNewline:$NoNewLine
    }
    Else {
        Write-Host "-> $Status" -ForegroundColor $ForegroundColorText -BackgroundColor $Variables.BackgroundColor -NoNewline:$NoNewLine
    }
}
Function Write-Title {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )
    Write-Host "`n<" -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "===========================" -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host "] " -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "$Text " -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host "[" -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "===========================" -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host ">" -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    #$TitleToLogFormat = "`n`n   $Text`n`n"
    #Add-Content -Path $Variables.Log -Value $TitleToLogFormat
}
Function Write-TitleCounter {
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param (
        [String] $Text = "No Text",
        [Int]    $Counter = 0,
        [Int] 	 $MaxLength
    )
    Write-Host "`n`n" -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙" -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host "    (" -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host " $($Counter)/$($Variables.MaxLength) " -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host ") " -NoNewline -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "|" -NoNewline -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    Write-Host " $Text " -ForegroundColor $Variables.ForegroundColor -BackgroundColor $Variables.BackgroundColor
    Write-Host "∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙" -ForegroundColor White -BackgroundColor $Variables.BackgroundColor
    #$TitleCounterLogFormat = "`n`n∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙`n`n    ($Counter)/$($Variables.MaxLength)) | $Text`n`n∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙∙`n"
    # Writes to Log
    #Add-Content -Path $Variables.Log -Value "$TitleCounterLogFormat"
}

# Initiation #

####################################################################################

If (!$Undo){
    Start-Bootup
    New-Variable -Name "StartTime" -Value (Get-Date -DisplayHint Time) -Scope Global
    Get-Program
    $Variables.Counter++
    Set-StartMenu
    Set-Taskbar
    $Variables.Counter++
    Set-Wallpaper
    $Variables.Counter++
    Set-Branding
    $Variables.Counter++
    Start-Debloat
    Get-AdwCleaner
    $Variables.Counter++
    Get-Office
    $Variables.Counter++
    Start-BitlockerDecryption
    $Variables.Counter++
    Optimize-General
    Optimize-Performance
    Optimize-SSD
    Optimize-Privacy
    Optimize-Security
    Optimize-Service
    Optimize-TaskScheduler
    Optimize-WindowsOptional
    $Variables.Counter++
    New-SystemRestorePoint
    $Variables.Counter++
    Start-Cleanup
    Send-EmailLog
    Request-PCRestart
}elseif ($WhatIfPreference -eq $True) {
    Start-Bootup
    New-Variable -Name "StartTime" -Value (Get-Date -DisplayHint Time) -Scope Global
    Get-Program -WhatIf
    $Variables.Counter++
    Set-StartMenu -WhatIf
    Set-Taskbar -WhatIf
    $Variables.Counter++
    Set-Wallpaper -WhatIf
    $Variables.Counter++
    Set-Branding -WhatIf
    $Variables.Counter++
    Start-Debloat -WhatIf
    Get-AdwCleaner -WhatIf
    $Variables.Counter++
    Start-BitlockerDecryption -WhatIf
    $Variables.Counter++
    Optimize-General -WhatIf
    Optimize-Performance -WhatIf
    Optimize-SSD -WhatIf
    Optimize-Privacy -WhatIf
    Optimize-Security -WhatIf
    Optimize-Service -WhatIf
    Optimize-TaskScheduler -WhatIf
    Optimize-WindowsOptional -WhatIf
    $Variables.Counter++
    Start-Cleanup -WhatIf
}elseif ($Undo) {
    Start-Bootup
    New-Variable -Name "StartTime" -Value (Get-Date -DisplayHint Time) -Scope Global
    Get-Program -Skip
    $Variables.Counter++
    Set-StartMenu -Skip
    Set-Taskbar -Undo
    $Variables.Counter++
    Set-Wallpaper -Undo
    $Variables.Counter++
    Set-Branding -Undo
    $Variables.Counter++
    Start-Debloat -Undo
    Get-AdwCleaner -Undo
    $Variables.Counter++
    Start-BitlockerDecryption -Skip
    $Variables.Counter++
    Optimize-General -Undo
    Optimize-Performance -Undo
    Optimize-SSD -Undo
    Optimize-Privacy -Undo
    Optimize-Security -Undo
    Optimize-Service -Undo
    Optimize-TaskScheduler -Undo
    Optimize-WindowsOptional -Undo
    $Variables.Counter++
    Start-Cleanup -Undo
    Send-EmailLog
    Request-PCRestart
}
####################################################################################



# SIG # Begin signature block
# MIIFiQYJKoZIhvcNAQcCoIIFejCCBXYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUBJfvk8GtzVKtlMQxYOdHjdCu
# ZamgggMkMIIDIDCCAgigAwIBAgIQU3x04/OYsb1NqZt3cgzIXTANBgkqhkiG9w0B
# AQsFADAaMRgwFgYDVQQDDA9jaXJjbG9sQHNoYXcuY2EwHhcNMjMwODE1MDQxMTQz
# WhcNMjQwODE1MDQzMTQzWjAaMRgwFgYDVQQDDA9jaXJjbG9sQHNoYXcuY2EwggEi
# MA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvOOSeehF7db8BeRjJkV2L6aaD
# pGPa8HAlGyOAafa5/wrSWxMS3XA9XB54ynPwT3xPQxKUp8H3bzpfkAgKx6Nn89vp
# eNsFIr+ktx5ePqkvug9ajI66nsrMXz7iaouwX+tC4QDyBHU2F+jK990TwOEph7WV
# aWK70DwkxaQso9/mC8WlbExdsSnCaQbf2azu7uriZbO/hqgiFrGlIbbRFQ26jfoI
# 0DVYGuNBO3/9o3lUBydN6mpizmoVhexgKnty1cBIQWDIZTL/xR122hi6CAJtKYcf
# 8Ej4nJUCRrP2/bxA0Yw8+93rtdyKU91NH/pYV8v61sYqOxMUbsTZRWZW5EAVAgMB
# AAGjYjBgMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzAaBgNV
# HREEEzARgg9jaXJjbG9sQHNoYXcuY2EwHQYDVR0OBBYEFPZu88L4rNaihEgxWlXG
# dNlu490eMA0GCSqGSIb3DQEBCwUAA4IBAQApAtc37CUZZhvpyDXLS3Zi0al6FrfX
# gq1ABwMubo7WCVcrSGo6InHIpgn/oTFuxM/QswH6yCpv6xLOHFbLWpF7ujjRm58o
# IJze+nGpXldW+pgORLpTSj8hxPkC9JopX7YDpPcn9/JJVKXHN7jDD8YvlOSMPR13
# gLt2Oh8nb1tME7aZGepgHyR4aTIp+3dYJ3o1hEMa9YyUFg7SF2hjJFbr3decmKYs
# ofCYIdxFPWh4JvTNwPUxz+XUOgwaMheE3xInEvERwqW69Oh0f+9Ttgbn8tsT0LaD
# 6o9+GPRQFeH2fxK5D76K/AdvELI2mHCh7cC4CUWthYLgAYIJ+lvbAbdbMYIBzzCC
# AcsCAQEwLjAaMRgwFgYDVQQDDA9jaXJjbG9sQHNoYXcuY2ECEFN8dOPzmLG9Tamb
# d3IMyF0wCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJ
# KoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQB
# gjcCARUwIwYJKoZIhvcNAQkEMRYEFMCxT4UIbxOicL9qm/0KzQef4+2OMA0GCSqG
# SIb3DQEBAQUABIIBAJcqGPaN97JqTD6jPobHPHA7kDBSx2Yw1BOp5QeqgixyXlXV
# YlvILCcpuIVfirMckCSoxcNtp41PQ/09wdz2oAzdD0MqwZBuxXv1l12sJNAxDr6Y
# QVVxAPQw7N77MtEaL/2uUBbqegkJUryDuuNCGXOTwx95cfG9G7bT8V3FWP8xAfQI
# zEbcbx7yCTea3aEj5f4scoVLN03ziGIk8eW+eNlE3low2YXtyiQIszP6WSnGk+7o
# aAWPbKdY8wPxzv9SlbwaDYNiKO6m1p/3BV2+qn8BpHTozxslweDJ443Y46g+KtuO
# WEK4lEBDhhRQmqi+atOgB5/tMB143gy87PWj364=
# SIG # End signature block
