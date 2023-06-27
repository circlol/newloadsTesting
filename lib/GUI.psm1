<# 
.NAME
    newloads
#>
Function GUI{
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$form                            = New-Object system.Windows.Forms.Form
$form.ClientSize                 = New-Object System.Drawing.Point(640,686)
$form.text                       = "New Loads by Mike Ivison"
$form.TopMost                    = $true
$form.BackColor                  = [System.Drawing.ColorTranslator]::FromHtml("#c0b9d1")

$RunScript_Button                = New-Object system.Windows.Forms.PictureBox
$RunScript_Button.width          = 118
$RunScript_Button.height         = 121
$RunScript_Button.visible        = $true
$RunScript_Button.location       = New-Object System.Drawing.Point(483,501)
$RunScript_Button.imageLocation  = "https://raw.githubusercontent.com/circlol/newload/main/assets/Branding.png"
$RunScript_Button.SizeMode       = [System.Windows.Forms.PictureBoxSizeMode]::zoom

$UndoScript_Button               = New-Object system.Windows.Forms.Button
$UndoScript_Button.text          = "Undo Script Changes"
$UndoScript_Button.width         = 268
$UndoScript_Button.height        = 35
$UndoScript_Button.visible       = $false
$UndoScript_Button.enabled       = $true
$UndoScript_Button.location      = New-Object System.Drawing.Point(346,459)
$UndoScript_Button.Font          = New-Object System.Drawing.Font('Microsoft Sans Serif',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$UndoScript_Button.ForeColor     = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$UndoScript_Button.BackColor     = [System.Drawing.ColorTranslator]::FromHtml("#f8e71c")

$Exit_Button                     = New-Object system.Windows.Forms.Button
$Exit_Button.text                = "Exit"
$Exit_Button.width               = 124
$Exit_Button.height              = 30
$Exit_Button.location            = New-Object System.Drawing.Point(346,528)
$Exit_Button.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Exit_Button.ForeColor           = [System.Drawing.ColorTranslator]::FromHtml("#f3e7e7")
$Exit_Button.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#3b3b3b")

$NVIDIA_Button                   = New-Object system.Windows.Forms.Button
$NVIDIA_Button.text              = "NVIDIA"
$NVIDIA_Button.width             = 125
$NVIDIA_Button.height            = 35
$NVIDIA_Button.location          = New-Object System.Drawing.Point(166,167)
$NVIDIA_Button.Font              = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$NVIDIA_Button.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$NVIDIA_Button.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#7ed321")

$AMD_Button                      = New-Object system.Windows.Forms.Button
$AMD_Button.text                 = "AMD"
$AMD_Button.width                = 125
$AMD_Button.height               = 35
$AMD_Button.location             = New-Object System.Drawing.Point(37,167)
$AMD_Button.Font                 = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$AMD_Button.ForeColor            = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$AMD_Button.BackColor            = [System.Drawing.ColorTranslator]::FromHtml("#d0021b")

$DriverWebsites_Label            = New-Object system.Windows.Forms.Label
$DriverWebsites_Label.text       = "Driver Websites"
$DriverWebsites_Label.AutoSize   = $true
$DriverWebsites_Label.width      = 25
$DriverWebsites_Label.height     = 34
$DriverWebsites_Label.location   = New-Object System.Drawing.Point(107,137)
$DriverWebsites_Label.Font       = New-Object System.Drawing.Font('Microsoft JhengHei UI',15,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$DriverWebsites_Label.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml("#e5eae8")

$ASUS_Button                     = New-Object system.Windows.Forms.Button
$ASUS_Button.text                = "ASUS"
$ASUS_Button.width               = 71
$ASUS_Button.height              = 35
$ASUS_Button.location            = New-Object System.Drawing.Point(37,206)
$ASUS_Button.Font                = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$ASUS_Button.ForeColor           = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$ASUS_Button.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$MSI_Button                      = New-Object system.Windows.Forms.Button
$MSI_Button.text                 = "MSI"
$MSI_Button.width                = 74
$MSI_Button.height               = 35
$MSI_Button.location             = New-Object System.Drawing.Point(218,206)
$MSI_Button.Font                 = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$MSI_Button.ForeColor            = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$MSI_Button.BackColor            = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$OpenWindowsActivation_Button    = New-Object system.Windows.Forms.Button
$OpenWindowsActivation_Button.text  = "slui3 - Enter Product Key"
$OpenWindowsActivation_Button.width  = 268
$OpenWindowsActivation_Button.height  = 35
$OpenWindowsActivation_Button.location  = New-Object System.Drawing.Point(346,58)
$OpenWindowsActivation_Button.Font  = New-Object System.Drawing.Font('Microsoft PhagsPa',11,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$OpenWindowsActivation_Button.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$OpenWindowsActivation_Button.BackColor  = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$InstalledApps_Button            = New-Object system.Windows.Forms.Button
$InstalledApps_Button.text       = "Installed Apps"
$InstalledApps_Button.width      = 131.5
$InstalledApps_Button.height     = 35
$InstalledApps_Button.location   = New-Object System.Drawing.Point(346,179)
$InstalledApps_Button.Font       = New-Object System.Drawing.Font('Microsoft PhagsPa',11,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$InstalledApps_Button.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$InstalledApps_Button.BackColor  = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$RunUpdates_Button               = New-Object system.Windows.Forms.Button
$RunUpdates_Button.text          = "Run Windows Updates in Script"
$RunUpdates_Button.width         = 268
$RunUpdates_Button.height        = 35
$RunUpdates_Button.location      = New-Object System.Drawing.Point(346,99)
$RunUpdates_Button.Font          = New-Object System.Drawing.Font('Microsoft PhagsPa',11,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$RunUpdates_Button.ForeColor     = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$RunUpdates_Button.BackColor     = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$7Themes_Button                  = New-Object system.Windows.Forms.Button
$7Themes_Button.text             = "Win 7 Themes Page"
$7Themes_Button.width            = 268
$7Themes_Button.height           = 35
$7Themes_Button.location         = New-Object System.Drawing.Point(346,219)
$7Themes_Button.Font             = New-Object System.Drawing.Font('Microsoft PhagsPa',11,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$7Themes_Button.ForeColor        = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$7Themes_Button.BackColor        = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$Branding_Button                 = New-Object system.Windows.Forms.Button
$Branding_Button.text            = "Mother Computers Branding"
$Branding_Button.width           = 268
$Branding_Button.height          = 35
$Branding_Button.location        = New-Object System.Drawing.Point(32,288)
$Branding_Button.Font            = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Branding_Button.ForeColor       = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$Branding_Button.BackColor       = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$Intel_Button                    = New-Object system.Windows.Forms.Button
$Intel_Button.text               = "Intel"
$Intel_Button.width              = 102
$Intel_Button.height             = 35
$Intel_Button.location           = New-Object System.Drawing.Point(112,206)
$Intel_Button.Font               = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Intel_Button.ForeColor          = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$Intel_Button.BackColor          = [System.Drawing.ColorTranslator]::FromHtml("#4a90e2")

$SetLightMode_Button             = New-Object system.Windows.Forms.Button
$SetLightMode_Button.text        = "Light Mode"
$SetLightMode_Button.width       = 131
$SetLightMode_Button.height      = 35
$SetLightMode_Button.location    = New-Object System.Drawing.Point(483,299)
$SetLightMode_Button.Font        = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$SetLightMode_Button.ForeColor   = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$SetLightMode_Button.BackColor   = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$SetDarkMode_Button              = New-Object system.Windows.Forms.Button
$SetDarkMode_Button.text         = "Dark Mode"
$SetDarkMode_Button.width        = 131.5
$SetDarkMode_Button.height       = 35
$SetDarkMode_Button.location     = New-Object System.Drawing.Point(346,299)
$SetDarkMode_Button.Font         = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$SetDarkMode_Button.ForeColor    = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$SetDarkMode_Button.BackColor    = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$Reboot_Button                   = New-Object system.Windows.Forms.Button
$Reboot_Button.text              = "REBOOT"
$Reboot_Button.width             = 122
$Reboot_Button.height            = 26
$Reboot_Button.location          = New-Object System.Drawing.Point(346,498)
$Reboot_Button.Font              = New-Object System.Drawing.Font('Microsoft PhagsPa',11,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Reboot_Button.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$Reboot_Button.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#ff0000")

$DeviceManager_Button            = New-Object system.Windows.Forms.Button
$DeviceManager_Button.text       = "Device Manager"
$DeviceManager_Button.width      = 268
$DeviceManager_Button.height     = 35
$DeviceManager_Button.location   = New-Object System.Drawing.Point(346,139)
$DeviceManager_Button.Font       = New-Object System.Drawing.Font('Microsoft PhagsPa',11,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$DeviceManager_Button.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$DeviceManager_Button.BackColor  = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$7Sound_Button                   = New-Object system.Windows.Forms.Button
$7Sound_Button.text              = "Win 7 Sound Panel"
$7Sound_Button.width             = 268
$7Sound_Button.height            = 35
$7Sound_Button.location          = New-Object System.Drawing.Point(346,259)
$7Sound_Button.Font              = New-Object System.Drawing.Font('Microsoft PhagsPa',11,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$7Sound_Button.ForeColor         = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$7Sound_Button.BackColor         = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$DriverWebsitesIcon              = New-Object system.Windows.Forms.PictureBox
$DriverWebsitesIcon.width        = 60
$DriverWebsitesIcon.height       = 30
$DriverWebsitesIcon.location     = New-Object System.Drawing.Point(53,131)
$DriverWebsitesIcon.imageLocation  = "https://github.com/circlol/newload/raw/main/assets/diskette.png"
$DriverWebsitesIcon.SizeMode     = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$QuickLinks_Label                = New-Object system.Windows.Forms.Label
$QuickLinks_Label.text           = "Quick Links"
$QuickLinks_Label.AutoSize       = $true
$QuickLinks_Label.width          = 128
$QuickLinks_Label.height         = 38
$QuickLinks_Label.location       = New-Object System.Drawing.Point(444,21)
$QuickLinks_Label.Font           = New-Object System.Drawing.Font('Microsoft JhengHei UI',15,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$QuickLinks_Label.ForeColor      = [System.Drawing.ColorTranslator]::FromHtml("#e5eae8")

$QuickLinks_Logo                 = New-Object system.Windows.Forms.PictureBox
$QuickLinks_Logo.width           = 41
$QuickLinks_Logo.height          = 35
$QuickLinks_Logo.location        = New-Object System.Drawing.Point(400,12)
$QuickLinks_Logo.imageLocation   = "https://github.com/circlol/newload/raw/main/assets/microsoft.png"
$QuickLinks_Logo.SizeMode        = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$InstallApps_Button              = New-Object system.Windows.Forms.Button
$InstallApps_Button.text         = "Install Apps (Chrome,VLC, Ado..)"
$InstallApps_Button.width        = 268
$InstallApps_Button.height       = 35
$InstallApps_Button.location     = New-Object System.Drawing.Point(32,328)
$InstallApps_Button.Font         = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$InstallApps_Button.ForeColor    = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$InstallApps_Button.BackColor    = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$Debloat_Button                  = New-Object system.Windows.Forms.Button
$Debloat_Button.text             = "Run Debloater"
$Debloat_Button.width            = 268
$Debloat_Button.height           = 35
$Debloat_Button.location         = New-Object System.Drawing.Point(32,368)
$Debloat_Button.Font             = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Debloat_Button.ForeColor        = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$Debloat_Button.BackColor        = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$ScriptFunctions_Label           = New-Object system.Windows.Forms.Label
$ScriptFunctions_Label.text      = "Script Functions"
$ScriptFunctions_Label.AutoSize  = $true
$ScriptFunctions_Label.width     = 25
$ScriptFunctions_Label.height    = 34
$ScriptFunctions_Label.location  = New-Object System.Drawing.Point(107,259)
$ScriptFunctions_Label.Font      = New-Object System.Drawing.Font('Microsoft JhengHei UI',15,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$ScriptFunctions_Label.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml("#e5eae8")

$StartMenu_Buttton               = New-Object system.Windows.Forms.Button
$StartMenu_Buttton.text          = "Apply Taskbar & Start Menu Layout"
$StartMenu_Buttton.width         = 268
$StartMenu_Buttton.height        = 35
$StartMenu_Buttton.location      = New-Object System.Drawing.Point(32,448)
$StartMenu_Buttton.Font          = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$StartMenu_Buttton.ForeColor     = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$StartMenu_Buttton.BackColor     = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$UninstallOneDrive_Button        = New-Object system.Windows.Forms.Button
$UninstallOneDrive_Button.text   = "Uninstall OneDrive"
$UninstallOneDrive_Button.width  = 268
$UninstallOneDrive_Button.height  = 35
$UninstallOneDrive_Button.location  = New-Object System.Drawing.Point(32,488)
$UninstallOneDrive_Button.Font   = New-Object System.Drawing.Font('Microsoft PhagsPa',11,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$UninstallOneDrive_Button.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$UninstallOneDrive_Button.BackColor  = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$ScriptFunctions_Logo            = New-Object system.Windows.Forms.PictureBox
$ScriptFunctions_Logo.width      = 30
$ScriptFunctions_Logo.height     = 30
$ScriptFunctions_Logo.location   = New-Object System.Drawing.Point(68,251)
$ScriptFunctions_Logo.imageLocation  = "https://github.com/circlol/newload/raw/main/assets/toolbox.png"
$ScriptFunctions_Logo.SizeMode   = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$MicrosoftStoreUpdates_Button    = New-Object system.Windows.Forms.Button
$MicrosoftStoreUpdates_Button.text  = "Run Store Updates"
$MicrosoftStoreUpdates_Button.width  = 268
$MicrosoftStoreUpdates_Button.height  = 35
$MicrosoftStoreUpdates_Button.location  = New-Object System.Drawing.Point(346,339)
$MicrosoftStoreUpdates_Button.Font  = New-Object System.Drawing.Font('Microsoft PhagsPa',11,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$MicrosoftStoreUpdates_Button.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$MicrosoftStoreUpdates_Button.BackColor  = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$ActivateWindows_Button          = New-Object system.Windows.Forms.Button
$ActivateWindows_Button.text     = "Activate Windows - Permanent"
$ActivateWindows_Button.width    = 268
$ActivateWindows_Button.height   = 35
$ActivateWindows_Button.location  = New-Object System.Drawing.Point(346,379)
$ActivateWindows_Button.Font     = New-Object System.Drawing.Font('Microsoft PhagsPa',11,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$ActivateWindows_Button.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$ActivateWindows_Button.BackColor  = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$ProgramsFeatures_Button         = New-Object system.Windows.Forms.Button
$ProgramsFeatures_Button.text    = "Programs & Features"
$ProgramsFeatures_Button.width   = 131
$ProgramsFeatures_Button.height  = 35
$ProgramsFeatures_Button.location  = New-Object System.Drawing.Point(483,179)
$ProgramsFeatures_Button.Font    = New-Object System.Drawing.Font('Microsoft PhagsPa',9,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$ProgramsFeatures_Button.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$ProgramsFeatures_Button.BackColor  = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$ReinstallOneDrive_Button        = New-Object system.Windows.Forms.Button
$ReinstallOneDrive_Button.text   = "Reinstall OneDrive"
$ReinstallOneDrive_Button.width  = 268
$ReinstallOneDrive_Button.height  = 35
$ReinstallOneDrive_Button.location  = New-Object System.Drawing.Point(32,528)
$ReinstallOneDrive_Button.Font   = New-Object System.Drawing.Font('Microsoft PhagsPa',11,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$ReinstallOneDrive_Button.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$ReinstallOneDrive_Button.BackColor  = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$ReinstallDefaultApps_Button     = New-Object system.Windows.Forms.Button
$ReinstallDefaultApps_Button.text  = "Reinstall Default Apps"
$ReinstallDefaultApps_Button.width  = 268
$ReinstallDefaultApps_Button.height  = 35
$ReinstallDefaultApps_Button.location  = New-Object System.Drawing.Point(32,408)
$ReinstallDefaultApps_Button.Font  = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$ReinstallDefaultApps_Button.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$ReinstallDefaultApps_Button.BackColor  = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$RestartExplorer_Button          = New-Object system.Windows.Forms.PictureBox
$RestartExplorer_Button.width    = 32
$RestartExplorer_Button.height   = 32
$RestartExplorer_Button.location  = New-Object System.Drawing.Point(11,639)
$RestartExplorer_Button.imageLocation  = "https://filestore.community.support.microsoft.com/api/images/097670f5-ede5-4260-86c9-1189c9e8aa2b"
$RestartExplorer_Button.SizeMode  = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$CPU_Textbox                     = New-Object system.Windows.Forms.TextBox
$CPU_Textbox.multiline           = $false
$CPU_Textbox.width               = 255
$CPU_Textbox.height              = 20
$CPU_Textbox.location            = New-Object System.Drawing.Point(36,23)
$CPU_Textbox.Font                = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$CPU_Textbox.ForeColor           = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$CPU_Textbox.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$CPU_Label                       = New-Object system.Windows.Forms.Label
$CPU_Label.text                  = "CPU"
$CPU_Label.AutoSize              = $true
$CPU_Label.width                 = 25
$CPU_Label.height                = 34
$CPU_Label.location              = New-Object System.Drawing.Point(36,7)
$CPU_Label.Font                  = New-Object System.Drawing.Font('Microsoft JhengHei UI',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$CPU_Label.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Motherboard_TextBox             = New-Object system.Windows.Forms.TextBox
$Motherboard_TextBox.multiline   = $false
$Motherboard_TextBox.width       = 255
$Motherboard_TextBox.height      = 20
$Motherboard_TextBox.location    = New-Object System.Drawing.Point(36,65)
$Motherboard_TextBox.Font        = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Motherboard_TextBox.ForeColor   = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$Motherboard_TextBox.BackColor   = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$Motherboard_Label               = New-Object system.Windows.Forms.Label
$Motherboard_Label.text          = "Motherboard"
$Motherboard_Label.AutoSize      = $true
$Motherboard_Label.width         = 25
$Motherboard_Label.height        = 34
$Motherboard_Label.location      = New-Object System.Drawing.Point(37,52)
$Motherboard_Label.Font          = New-Object System.Drawing.Font('Microsoft JhengHei UI',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Motherboard_Label.ForeColor     = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$WallpaperApply_Button           = New-Object system.Windows.Forms.PictureBox
$WallpaperApply_Button.width     = 27
$WallpaperApply_Button.height    = 27
$WallpaperApply_Button.location  = New-Object System.Drawing.Point(11,606)
$WallpaperApply_Button.imageLocation  = "https://raw.githubusercontent.com/circlol/newload/main/assets/wallpaper.ico"
$WallpaperApply_Button.SizeMode  = [System.Windows.Forms.PictureBoxSizeMode]::zoom
$SetWallpaperToolTip             = New-Object system.Windows.Forms.ToolTip
$SetWallpaperToolTip.ToolTipTitle  = "Set Wallpaper"
$SetWallpaperToolTip.isBalloon   = $true

$ClickMeBitch                    = New-Object system.Windows.Forms.ToolTip
$ClickMeBitch.ToolTipTitle       = "Click Me! I DARE YOU"
$ClickMeBitch.isBalloon          = $true

$RemoveOneDrive_Checkbox         = New-Object system.Windows.Forms.CheckBox
$RemoveOneDrive_Checkbox.text    = "Remove OneDrive"
$RemoveOneDrive_Checkbox.AutoSize = $true
$RemoveOneDrive_Checkbox.Visible = $False
$RemoveOneDrive_Checkbox.width   = 95
$RemoveOneDrive_Checkbox.height  = 20
$RemoveOneDrive_Checkbox.location = New-Object System.Drawing.Point(67,582)
$RemoveOneDrive_Checkbox.Font    = New-Object System.Drawing.Font('Microsoft Sans Serif',12,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$RemoveOneDrive_Checkbox.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$DriverSelector_Button           = New-Object system.Windows.Forms.Button
$DriverSelector_Button.text      = "Driver Selector"
$DriverSelector_Button.width     = 268
$DriverSelector_Button.height    = 35
$DriverSelector_Button.location  = New-Object System.Drawing.Point(346,419)
$DriverSelector_Button.Font      = New-Object System.Drawing.Font('Microsoft PhagsPa',11,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$DriverSelector_Button.ForeColor  = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$DriverSelector_Button.BackColor  = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$GPU_Textbox                     = New-Object system.Windows.Forms.TextBox
$GPU_Textbox.multiline           = $false
$GPU_Textbox.width               = 255
$GPU_Textbox.height              = 20
$GPU_Textbox.location            = New-Object System.Drawing.Point(36,108)
$GPU_Textbox.Font                = New-Object System.Drawing.Font('Microsoft PhagsPa',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$GPU_Textbox.ForeColor           = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")
$GPU_Textbox.BackColor           = [System.Drawing.ColorTranslator]::FromHtml("#6b6767")

$GPU_Label                       = New-Object system.Windows.Forms.Label
$GPU_Label.text                  = "Graphics Card"
$GPU_Label.AutoSize              = $true
$GPU_Label.width                 = 25
$GPU_Label.height                = 34
$GPU_Label.location              = New-Object System.Drawing.Point(36,93)
$GPU_Label.Font                  = New-Object System.Drawing.Font('Microsoft JhengHei UI',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$GPU_Label.ForeColor             = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$Branding_Checkbox               = New-Object system.Windows.Forms.CheckBox
$Branding_Checkbox.text          = "Branding"
$Branding_Checkbox.AutoSize      = $true
$Branding_Checkbox.width         = 95
$Branding_Checkbox.height        = 20
$Branding_Checkbox.enabled       = $true
$Branding_Checkbox.Checked       = $True
$Branding_Checkbox.location      = New-Object System.Drawing.Point(67,609)
$Branding_Checkbox.Font          = New-Object System.Drawing.Font('Microsoft Sans Serif',12,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
$Branding_Checkbox.ForeColor     = [System.Drawing.ColorTranslator]::FromHtml("#ffffff")

$ProgressBar                     = New-Object system.Windows.Forms.ProgressBar
$ProgressBar.width               = 567
$ProgressBar.height              = 29
$ProgressBar.Visible             = $false
$ProgressBar.location            = New-Object System.Drawing.Point(58,642)

$ClickMeBitch.SetToolTip($Reboot_Button,'Click me and see what happens + 10 Malware')
$ExplorerTooltip.SetToolTip($RestartExplorer_Button,'If Explorer is not running this button will start it.   If Explorer is already started it will open to the current folder.')
$SetWallpaper.ToolTip.SetToolTip($WallpaperApply_Button,'Sets Wallpaper to Mother Computers')
$form.controls.AddRange(@($RunScript_Button,$UndoScript_Button,$Exit_Button,$NVIDIA_Button,$AMD_Button,$DriverWebsites_Label,$ASUS_Button,$MSI_Button,$OpenWindowsActivation_Button,$InstalledApps_Button,$RunUpdates_Button,$7Themes_Button,$Branding_Button,$Intel_Button,$SetLightMode_Button,$SetDarkMode_Button,$Reboot_Button,$DeviceManager_Button,$7Sound_Button,$DriverWebsitesIcon,$QuickLinks_Label,$QuickLinks_Logo,$InstallApps_Button,$Debloat_Button,$ScriptFunctions_Label,$StartMenu_Buttton,$UninstallOneDrive_Button,$ScriptFunctions_Logo,$MicrosoftStoreUpdates_Button,$ActivateWindows_Button,$ProgramsFeatures_Button,$ReinstallOneDrive_Button,$ReinstallDefaultApps_Button,$RestartExplorer_Button,$CPU_Textbox,$CPU_Label,$Motherboard_TextBox,$Motherboard_Label,$WallpaperApply_Button,$RemoveOneDrive_Checkbox,$DriverSelector_Button,$GPU_Textbox,$GPU_Label,$Branding_Checkbox,$ProgressBar))


$RunScript_Button.Add_Click{
    Start-Transcript -Path $Log
    $StartTime = Get-Date -DisplayHint Time
    $Counter = 0
    Set-ScriptStatus -Counter $Counter++ -WindowTitle "Apps" -TweakType "Apps" -Title $True -TitleText "Programs" -Section $True -SectionText "Application Installation" 
    Programs
    If ($Branding_Checkbox.checked -eq $true){
        Set-ScriptStatus -Counter $Counter++ -WindowTitle "Visual" -TweakType "Visuals" -Title $True -TitleText "Visuals"
        Visuals
        Set-ScriptStatus -Counter $Counter++ -WindowTitle "Branding" -TweakType "Branding" -Section $True -SectionText "Branding" -Title $True -TitleText "Mother Computers Branding"
        Branding
    }
    Set-ScriptStatus -Counter $Counter++ -WindowTitle "Start Menu" -TweakType "StartMenu" -Title $True -TitleText "Start Menu Layout" -Section $True -SectionText "Applying Taskbar Layout" 
    StartMenu
    Set-ScriptStatus -Counter $Counter++ -WindowTitle "Debloat" -TweakType "Debloat" -Title $True -TitleText "Debloat" -Section $True -SectionText "Checking for Win32 Pre-Installed Bloat" 
    Debloat
    #Remove-OneDrive
    Set-ScriptStatus -Section $True -SectionText "ADWCleaner"
    AdwCleaner
    Set-ScriptStatus -Counter $Counter++ -WindowTitle "Office" -TweakType "Office" -Title $True -TitleText "Office Removal" 
    Get-Office
    Set-ScriptStatus -Counter $Counter++ -WindowTitle "Optimization" -TweakType "Registry" -Title $True -TitleText "Optimization"
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
    Set-ScriptStatus -Counter $Counter++ -WindowTitle "Bitlocker" -TweakType "Bitlocker" -Title $True -TitleText "Bitlocker Decryption" 
    BitlockerDecryption
    Set-ScriptStatus -Counter $Counter++ -WindowTitle "Restore Point" -TweakType "Backup" -Title $True -TitleText "Creating Restore Point" 
    CreateRestorePoint
    Set-ScriptStatus -Counter $Counter++ -WindowTitle "Email Log" -TweakType "Email" -Title $True -TitleText "Email Log"
    EmailLog
    Set-ScriptStatus -Counter $Counter++ -WindowTitle "Cleanup" -TweakType "Cleanup" -Title $True -TitleText "Cleanup" -Section $True -SectionText "Cleaning Up" 
    Cleanup
    Write-Status -Types "WAITING" -Status "User action needed - You may have to ALT + TAB "
    Request-PCRestart
}
$UndoScript_Button.add_click{
    # More to Come
}
$Exit_Button.add_click{
    $stream.Dispose()
    $Form.Dispose()
    Exit
}
$7Sound_Button.add_click{
    Write-Status -Types "+" -Status "Launching Win7 Sound Panel"
    Start-Process mmsys.cpl
}
$ActivateWindows_Button.add_click{
    $ErrorActionPreference = "Stop"
    # Enable TLSv1.2 for compatibility with older clients
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    
    $DownloadURL = 'https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version/MAS_AIO.cmd'
    $DownloadURL2 = 'https://gitlab.com/massgrave/microsoft-activation-scripts/-/raw/master/MAS/All-In-One-Version/MAS_AIO.cmd'
    
    $rand = Get-Random -Maximum 1000
    $isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
    $FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\MAS_$rand.cmd" } else { "$env:TEMP\MAS_$rand.cmd" }
    
    try {
        $response = Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing
    }
    catch {
        $response = Invoke-WebRequest -Uri $DownloadURL2 -UseBasicParsing
    }
    
    $ScriptArgs = "$args "
    $prefix = "@REM $rand `r`n"
    $content = $prefix + $response
    Set-Content -Path $FilePath -Value $content
    
    Start-Process $FilePath $ScriptArgs -Wait
    
    $FilePaths = @("$env:TEMP\MAS*.cmd", "$env:SystemRoot\Temp\MAS*.cmd")
    foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }    
}
$AMD_Button.add_click{
    Write-Status -Types "@" -Status "Launching AMD Support Page"
    Start-Process "https://www.amd.com/en/support"
}
$ASUS_Button.add_click{
    Write-Status -Types "@" -Status "Launching ASUS Support Page"
    Start-Process "https://www.asus.com/ca-en/support/download-center"
}
$Debloat_Button.add_click{
    Write-Status -Types "@" -Status "Starting Debloat"
    Debloat
}
$DeviceManager_Button.Add_Click{
    Write-Status -Types "@" -Status "Launching Device Manager"
    Start-Process devmgmt.msc
}
$DriverSelector_Button.Add_Click{
    ## 
}
$Intel_Button.add_click{
    Write-Status -Types "@" -Status "Launching Intel Support Page"
    Start-Process "https://www.intel.com/content/www/us/en/download-center/home.html"
}
$InstallApps_Button.add_click{
    Write-Status -Types "@" -Status "Installing Applications"
    Programs
}
$InstalledApps_Button.add_click{
    Write-Status -Types "@" -Status "Launching Installed Apps"
    Start-Process ms-settings:appsfeatures
}
$MicrosoftStoreUpdates_Button.add_click{
    Write-Status -Types "+" -Status "Sending Update signal to Microsoft Store"
    $namespaceName = "root\cimv2\mdm\dmmap"
    $className = "MDM_EnterpriseModernAppManagement_AppManagement01"
    $wmiObj = Get-WmiObject -Namespace $namespaceName -Class $className
    $result = $wmiObj.UpdateScanMethod()
    $result
}
$MSI_Button.add_click{
    Write-Status -Types "@" -Status "Launching MSI Support Page"
    Start-Process "https://www.msi.com/support/download"
}
$NVIDIA_Button.add_click{
    Write-Status -Types "@" -Status "Launching NVIDIA Support Page"
    Start-Process "https://www.nvidia.com/Download/index.aspx?lang=en-us"
}
$OpenWindowsActivation_Button.add_click{
    Write-Status -Types "@" -Status "Launching Windows Activation"
    Start-Process slui3
}
$ProgramsFeatures_Button.add_click{
    Write-Status -Types "@" -Status "Launching Programs and Features"
    Start-Process appwiz.cpl
}
$ReinstallOneDrive_Button.add_click{

}
$ReinstallDefaultApps_Button.add_click{
    Write-Status -Types "+", "Bloat" -Status "Reinstalling Default Appxmanifest.xml Packages..."
    Get-AppxPackage -allusers | ForEach-Object {Add-AppxPackage -register "$($_.InstallLocation)\appxmanifest.xml" -DisableDevelopmentMode -Verbose -ErrorAction SilentlyContinue} | Out-Host
}
$RestartExplorer_Button.add_click{
    Restart-Explorer
}
$Reboot_Button.add_click{
    Restart-Computer
}
$RunUpdates_Button.add_click{
    If (Test-Path ".\~Useful Extras\Windows Updates.exe"){
        Write-Status -Types "@" -Status "Running Windows Updates"
        Start-Process $PSScriptRoot..\"~Useful Extras\Windows Updates.exe" | Out-Host
    }
}
$SetLightMode_Button.add_click{
    Write-Status "+","Visual" -Status "Setting System to Light Mode"
    Set-ItemProperty -Path "$PathToRegPersonalize" -Name "SystemUsesLightTheme" -Value 1
    Set-ItemProperty -Path "$PathToRegPersonalize" -Name "AppsUseLightTheme" -Value 1
}
$SetDarkMode_Button.add_click{
    Write-Status "+","Visual" -Status "Setting System to Dark Mode"
    Set-ItemProperty -Path "$PathToRegPersonalize" -Name "SystemUsesLightTheme" -Value 0
    Set-ItemProperty -Path "$PathToRegPersonalize" -Name "AppsUseLightTheme" -Value 0
}
$StartMenu_Buttton.add_click{
    Write-Status -Types "+" -Status "Applying Start Menu & Taskbar Layout"
    StartMenu
}
$WallpaperApply_Button.add_click{
    Write-Status -Types "+" -Status "Applying Visuals"
    Visuals
}
$UninstallOneDrive_Button.add_click{

}









[void]$form.ShowDialog()
}
# SIG # Begin signature block
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6wLfmgOJ6+VVVaOy9fSNnsgc
# XEagggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFGwpDazwxCm4GQQs23fPyBui/dFPMA0GCSqGSIb3DQEB
# AQUABIIBAEzUqG4UJo74+x1jKizy5eV+T/B9SO3bCTf2vDHpJMp+1hEFeRx/DJFX
# tc71+hCCeHTpQL6RR9QnaTCxy2Q5MHZ1iFH2HrqdyR0RQUi+GEV/8z9T/5NV0MGF
# zl3X0kIziurW1YEr0qrtdXuxKkup+XgGIa1grNM8JBO/4hew7idHiDZjgoxMNhQB
# UgUHfKONrqgq7hiVb70AzyAFZdWaXHGGz6cH0A0kA6fu1nFZFRAG+nwLrzTNA3pV
# hTezL84+o7j9pzlmmrC3ckfCy1Od4zd0LCA3CJMQREdbPEHRxiHgxnfi3X3/s8Gk
# OeNfN50Ifrg5NW6xFB1du7K1pyoR6uY=
# SIG # End signature block
