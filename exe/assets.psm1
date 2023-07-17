

Function Import-Variables() {
    # -> Main Script Variables
    New-Variable -Name "NewLoads" -Value ".\" -Scope Global -Force
    New-Variable -Name "MaxLength" -Value '11' -Scope Global -Force
    New-Variable -Name "ErrorLog" -Value ".\ErrorLog.txt" -Option ReadOnly -Scope Global -Force
    New-Variable -Name "Log" -Value ".\Log.txt" -Scope Global -Force
    New-Variable -Name "temp" -Value "$env:temp" -Scope Global -Force
    New-Variable -Name "Win11" -Value "22000" -Scope Global -Force
    New-Variable -Name "22H2" -Value "22621" -Scope Global -Force
    New-Variable -Name "BuildNumber" -Value [System.Environment]::OSVersion.Version.Build -Scope Global -Force
    New-Variable -Name "NetStatus" -Value (Get-NetConnectionProfile).IPv4Connectivity -Scope Global -Force
    New-Variable -Name "Connected" -Value "Internet" -Scope Global -Force
    #New-Variable -Name "HVECCodec" -Value ".\assets\Microsoft.HEVCVideoExtension_2.0.51121.0_x64__8wekyb3d8bbwe.appx" -Scope Global    
    New-Variable -Name "HVECCodec" -Value  "Assets\Microsoft.HEVCVideoExtension_2.0.60091.0_x64__8wekyb3d8bbwe.Appx" -Scope Global -Force
    New-Variable -Name "DriverSelectorPath" -Value ".\~ extra\Driver Grabber.exe" -Scope Global -Force
    New-Variable -Name "WindowsUpdatesPath" -Value ".\~ extra\Windows Updates.exe" -Scope Global -Force
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
    New-Variable -Name "adwDestination" -Value ".\bin\adwcleaner.exe" -Force -Scope Global
    
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
    New-Variable -Name "WallpaperDestination" -Value "$Env:Appdata\Microsoft\Windows\Themes\mother.jpg" -Scope Global -Force
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
        "Microsoft.549981C3F5F10"                   # Cortana
        "Microsoft.3DBuilder"                       # 3D Builder
        "Microsoft.Appconnector"                    # App Connector
        "Microsoft.BingFinance"                     # Finance
        "Microsoft.BingFoodAndDrink"                # Food And Drink
        "Microsoft.BingHealthAndFitness"            # Health And Fitness
        "Microsoft.BingNews"                        # News
        "Microsoft.BingSports"                      # Sports
        "Microsoft.BingTranslator"                  # Translator
        "Microsoft.BingTravel"                      # Travel
        "Microsoft.BingWeather"                     # Weather
        "Microsoft.CommsPhone"                      # Your Phone
        "Microsoft.ConnectivityStore"               # Connectivity Store
        "Microsoft.Messaging"                       # Messaging
        "Microsoft.Microsoft3DViewer"               # 3D Viewer
        "Microsoft.MicrosoftOfficeHub"              # Office
        "Microsoft.MicrosoftPowerBIForWindows"      # Power Automate
        "Microsoft.MicrosoftSolitaireCollection"    # MS Solitaire
        "Microsoft.MinecraftEducationEdition"       # Minecraft Education Edition for Windows 10
        "Microsoft.MinecraftUWP"                    # Minecraft
        "Microsoft.MixedReality.Portal"             # Mixed Reality Portal
        "Microsoft.Office.Hub"                      # Office Hub
        "Microsoft.Office.Lens"                     # Office Lens
        "Microsoft.Office.OneNote"                  # Office One Note
        "Microsoft.Office.Sway"                     # Office Sway
        "Microsoft.OneConnect"                      # OneConnect
        "Microsoft.People"                          # People
        "Microsoft.SkypeApp"                        # Skype (Who still uses Skype? Use Discord)
        "MicrosoftTeams"                            # Teams / Preview
        "Microsoft.Todos"                           # To Do
        "Microsoft.Wallet"                          # Wallet
        "Microsoft.Whiteboard"                      # Microsoft Whiteboard
        "Microsoft.WindowsPhone"                    # Your Phone Alternate
        "Microsoft.WindowsReadingList"              # Reading List
        #"Microsoft.WindowsSoundRecorder"            # Sound Recorder
        "Microsoft.ZuneMusic"                       # Groove Music / (New) Windows Media Player
        "Microsoft.ZuneVideo"                       # Movies & TV
        # 3rd party Apps
        "*AdobePhotoshopExpress*"                   # Adobe Photoshop Express
        "AdobeSystemsIncorporated.AdobeLightroom"   # Adobe Lightroom
        "AdobeSystemsIncorporated.AdobeCreativeCloudExpress"    # Adobe Creative Cloud Express
        "AdobeSystemsIncorporated.AdobeExpress"    # Adobe Creative Cloud Express
        "*Amazon.com.Amazon*"                       # Amazon
        "AmazonVideo.PrimeVideo"                    # Amazon Prime Video
        "57540AMZNMobileLLC.AmazonAlexa"            # Amazon Alexa
        "*BubbleWitch3Saga*"                        # Bubble Witch 3 Saga
        "*CandyCrush*"                              # Candy Crush
        "Clipchamp.Clipchamp"                       # Clip Champ
        "*DisneyMagicKingdoms*"                     # Disney Magic Kingdom
        "Disney.37853FC22B2CE"                      # Disney Plus
        "*Disney*"                                  # Disney Plus
        "*Dolby*"                                   # Dolby Products (Like Atmos)
        "*DropboxOEM*"                              # Dropbox
        "Evernote.Evernote"                         # Evernote
        "*ExpressVPN*"                              # ExpressVPN
        "*Facebook*"                                # Facebook
        "*Flipboard*"                               # Flipboard
        "*Hulu*"                                    # Hulu
        "*Instagram*"                               # Instagram
        "*McAfee*"                                  # McAfee
        "5A894077.McAfeeSecurity"                   # McAfee Security
        "4DF9E0F8.Netflix"                          # Netflix
        "*PicsArt-PhotoStudio*"                     # PhotoStudio
        "*Pinterest*"                               # Pinterest
        "142F4566A.147190D3DE79"                    # Pinterest
        "1424566A.147190DF3DE79"                    # Pinterest
        "SpotifyAB.SpotifyMusic"                    # Spotify
        "*Twitter*"                                 # Twitter
        "*TikTok*"                                  # TikTok
        "5319275A.WhatsAppDesktop"                  # WhatsApp
        # Acer OEM Bloat
        "AcerIncorporated.AcerRegistration"         # Acer Registration
        "AcerIncorporated.QuickAccess"              # Acer Quick Access
        "AcerIncorporated.UserExperienceImprovementProgram"              # Acer User Experience Improvement Program
        #"AcerIncorporated.AcerCareCenterS"         # Acer Care Center
        "AcerIncorporated.AcerCollectionS"          # Acer Collections 
        # HP Bloat
        "AD2F1837.HPPrivacySettings"                # HP Privacy Settings
        "AD2F1837.HPInc.EnergyStar"                 # Energy Star
        "AD2F1837.HPAudioCenter"                    # HP Audio Center
        # Common HP & Acer Bloat
        "CyberLinkCorp.ac.PowerDirectorforacerDesktop"          # CyberLink Power Director for Acer
        "CorelCorporation.PaintShopPro"                         # Coral Paint Shop Pro
        "26720RandomSaladGamesLLC.HeartsDeluxe"                 # Hearts Deluxe
        "26720RandomSaladGamesLLC.SimpleSolitaire"              # Simple Solitaire
        "26720RandomSaladGamesLLC.SimpleMahjong"                # Simple Mahjong
        "26720RandomSaladGamesLLC.Spades"                       # Spades
    ) -Scope Global -Force -Option ReadOnly
}
Function Write-Break(){
    Write-Host "`n`n[" -NoNewline -ForegroundColor $ForegroundColor -Backgroundcolor $BackgroundColor
    Write-Host "================================================================================================" -NoNewLine -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "]`n" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}
Function Write-Caption() {
    [CmdletBinding()]
    param (
        [String] $Text = "No Text"
    )

    Write-Host "==" -NoNewline -ForegroundColor White -BackgroundColor $BackgroundColor
    Write-Host "> " -NoNewline -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}
Function Write-CaptionFailed() {
    [CmdletBinding()]
    param (
        [String] $Text = "Failed"
    )
    Write-Host "==" -ForegroundColor Red -BackgroundColor $BackgroundColor -NoNewline
    Write-Host "> " -NoNewline -ForegroundColor DarkRed -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}
Function Write-CaptionSucceed() {
    [CmdletBinding()]
    param (
        [String] $Text = "Success"
    )
    Write-Host "==" -NoNewline -ForegroundColor Green -BackgroundColor $BackgroundColor
    Write-Host "> " -NoNewline -ForegroundColor DarkGreen -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}
Function Write-CaptionWarning() {
    [CmdletBinding()]
    param (
        [String] $Text = "Warning"
        )
        Write-Host "==" -NoNewline -ForegroundColor Yellow -BackgroundColor $BackgroundColor
        Write-Host "> " -NoNewline -ForegroundColor DarkYellow -BackgroundColor $BackgroundColor
    Write-Host "$Text" -ForegroundColor White -BackgroundColor $BackgroundColor
}
Function Write-HostReminder() {
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
Function Write-Title() {
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
    Write-Host "<" -ForegroundColor $ForegroundColor -BackgroundColor $BackgroundColor
}
Function Write-TitleCounter() {
    [CmdletBinding()]
    [OutputType([System.Int32])]
    param (
        [String] $Text = "No Text",
        [Int]    $Counter = 0,
        [Int] 	 $MaxLength
    )
    #$Counter += 1
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
Function Get-Assets() {
    Try {
        # Checks if $folders exist, creates them if no
        $folders = @("bin", "assets", "lib", "lib\scripts")
        $folders | ForEach-Object {
            if (!(Test-Path ".\$_" -PathType Container -ErrorAction SilentlyContinue)) {
                Write-Status -Types "+" -Status "Creating $_ Folder."
                New-Item -ItemType Directory -Path ".\$_" -Force | Out-Null
            }
        }
        # tmp.txt is used to export 
        If (Test-Path ".\tmp.txt") {
            Write-Status -Types "-" -Status "Removing a previously runs tmp.txt."
            Remove-Item ".\tmp.txt" -Force -ErrorAction SilentlyContinue
        }
        If (Test-Path .\ErrorLog.txt) {
            Write-Status -Types "-" -Status "Removing a previous runs ErrorLog.txt."
            Remove-Item -Path ".\ErrorLog.txt" -Force -ErrorAction SilentlyContinue
        }
    }
    Catch {
        Write-Error "An error occurred while creating folders or removing files: $_"
    }
Write-Section -Text "Scanning Exisitng Files"

    # Creates an array for missing files
    $Items = [System.Collections.ArrayList]::new()

    # Checks if each file exists on the computer #
    ForEach ($file in $files) {
        If (Test-Path ".\$file" -PathType Leaf -ErrorAction SilentlyContinue) {
            Write-CaptionSucceed -Text "$file validated"
        }
        else {
            Write-CaptionFailed -Text "$file failed to validate."
            $Items += $file
        }
    }

    # Validates files - Downloads missing files from github #
    If (!($Items)) {
        Write-Section -Text "All packages successfully validated."
    }
    else {
        $ItemsFile = ".\tmp.txt"
        $Items | Out-File $ItemsFile -Encoding ASCII 
        (Get-Content $ItemsFile).replace('\', '/') | Set-Content $ItemsFile
        $urls = Get-Content $ItemsFile
        Get-NetworkStatus
        Write-Section -Text "Downloading Missing Files"
        ForEach ($url in $urls) {
                $link = $NewLoadsURLMain + $url
                Write-Status -Types "+","Modules" -Status "Attempting to Download $url" -NoNewLine
                Start-BitsTransfer -Dynamic -Source "$link" -Destination ".\$url" -TransferType Download -Confirm:$False -OutVariable bitsTransfers
                Check
        }
        While ((Get-BitsTransfer | Where-Object {$_.JobState -eq "Transferring"})) {
            ""
            Write-Verbose "Waiting for downloads to complete..."
            Start-Sleep -Seconds 1
        }
        $status = Get-BitsTransfer | Where-Object {$_.JobState -eq "Error"}
        If ($status) {
            Write-Error "An error occurred while downloading files : $status"
        }
        ""
        Write-Status -Types "-" -Status "Removing $ItemsFile"
        Remove-Item $ItemsFile -Force -ErrorAction SilentlyContinue
        }
        
}
<#############################

#  cmdlet examples

# Examples of cmdlet; Use-Command
    # Use-Command 'Write-Host Text'
    # Use-Command "Write-Host 'Test Test'"
    # Use-Command -Command 'Write-Host "TEST TEST"'
    $Text = "This text is a test"
    # Use-Command -Command "Write-Host `"$Text`""

# Examples of cmdlet; Set-Script Status
    # Set-ScriptStatus -WindowTitle "Debloat" -TweakType "Debloat" -Title $True -Counter 4 -TitleText "Debloat"
    # Set-ScriptStatus -WindowTitle "Debloat" -TweakType "Debloat" -Title $True -Counter 4 -TitleText "Debloat" -Section $True -SectionText "Checking Win32 Apps" 
    # Set-ScriptStatus -WindowTitle "Debloat" -TweakType "Debloat" -Section $True -SectionText "Checking Win32 Apps" 
    # Set-ScriptStatus -WindowTitle "Debloat" -TweakType "Debloat"

    Write-Break 
    Write-Caption -Text "This is a Test Message"
    Write-CaptionFailed -Text "This is a Test Message"
    Write-CaptionSucceed -Text "This is a Test Message"
    Write-CaptionWarning -Text "This is a Test Message"
    Write-Section -Text "This is a Test Message"
    Write-Status -Types "+" , "Test" -Status "This is a Test Message"
    Write-Title -Text "This is a Test Message"
    Write-TitleCounter -Counter "4" -MaxLength "15" -Text "This is a Test Message"


############################

Command Graveyard

Function Start-NewLoads() {
    $WindowTitle = "New Loads Utility" 
    $host.UI.RawUI.WindowTitle = $WindowTitle
    $wc = New-Object System.Net.WebClient
    Get-NetworkStatus
    $Script = $wc.DownloadString($NewLoadsURL)
    Invoke-Expression $Script

}





##############################>

# SIG # Begin signature block
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU2sbwkQCsRsnpzhdnIWCl9kv7
# j/OgggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFMD2WFdPFjB1CC+8OPVuXFyqeVSyMA0GCSqGSIb3DQEB
# AQUABIIBALjQHn7MUq3KK76bOzmvl/RV1b8L0mmeq2AvR1tR5Zg9YyGhVQ5FBGRj
# pvbJE6cvf3FOkyuLtw5bgq1A1wqKj/Mi1DW0uQ0ptVRf0IJx0gTQzpWpUMEOJ+rA
# 4OCoGEgjv9g4Wh7Htfuv8z7Ppnui3W5JQu0hU/XE8ZjMgIt9/zjQ5CgsIStupg1R
# 2IeyiWCsnRoOokQhQc+B9w0sdMr7r9LGLQxBhAhnLvojcomzDwCVqLTRLfMZY3Ej
# G8u/qeKgi8shCKx0OHJlnpu8ZmgI4rMUGZwi6tAHyH77wGkkVmww6pQlYQ7qZa25
# OuDBvubHPQvbas4sB6Mg6dJeEUteTtE=
# SIG # End signature block
