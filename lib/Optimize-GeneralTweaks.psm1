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
    Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'." -Warning
    $Zero = 1
    $One = 0
    $OneTwo = 2
    $EnableStatus = @(
        @{ Symbol = "<"; Status = "Re-Enabling"; }
        @{ Symbol = "<"; Status = "Re-Disabling"; }
    )
}

$TweakType = "Registry"
Write-Host "`n" ; Write-TitleCounter -Counter '9' -MaxLength $MaxLength -Text "Optimization"
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

    $PathToHide3DObjects = "$PathToRegExplorerLocalMachine\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
    ##  Hides 3D Objects from "This PC"
    If (Test-Path -Path $PathToHide3DObjects) {
        Write-Status -Types "-","$TweakType" -Status "Removing 3D Objects from This PC.."
        Remove-Item -Path $PathToHide3DObjects -Recurse
    }

    Write-Status -Types "+","$TweakType" -Status "Expanding Explorer Ribbon.."
    Set-ItemPropertyVerified -Path $PathToRegExplorer\Ribbon -Name "MinimizedStateTabletModeOff" -Type DWORD -Value $Zero

    ## Disabling Feeds Open on Hover
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Feeds Open on Hover..."
    Set-ItemPropertyVerified -Path $PathToRegCurrentVersion\Feeds -Name "ShellFeedsTaskbarOpenOnHover" -Value $Zero -Type DWord

    #Disables live feeds in search
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Dynamic Content in Windows Search..."
    Set-ItemPropertyVerified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB" -Name "ShowDynamicContent" -Value $Zero -type DWORD -Force
    Set-ItemPropertyVerified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsDynamicSearchBoxEnabled" -Value $Zero -Type DWORD -Force
}elseif ($osVersion -like "*11*") {
    ## Code for Windows 11
    Write-Section -Text "Applying Windows 11 Specific Reg Keys"
    If ($BuildNumber -GE $22H2) {
        Write-Status -Types "+","$TweakType" -Status "Setting Start Layout to More Icons.."
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "Switching Start Menu to Show More Icons..."
        Set-ItemProperty -Path $PathToRegExplorerAdv -Name Start_Layout -Value $One -Type DWORD -Force
    }

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Compact Mode View in Explorer "
    Set-ItemPropertyVerified -Path $PathToRegExplorerAdv -Name UseCompactMode -Value $One -Type DWORD

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Chats from the Taskbar..."
    Set-ItemPropertyVerified -Path $PathToRegExplorerAdv -Name "TaskBarMn" -Value $Zero -Type DWORD

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Meet Now from the Taskbar..."
    Set-ItemPropertyVerified -Path $PathToRegCurrentVersion\Policies\Explorer -Name "HideSCAMeetNow" -Type DWORD -Value $One
}else {
    # code for other operating systems
    # Check Windows version
    Throw{"
    Don't know what happened. Closing" ; exit}
}

    Write-Section -Text "Explorer Related"

    ### Explorer related
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Recents in Explorer..."
    Set-ItemPropertyVerified -Path $PathToRegExplorer -Name "ShowRecent" -Value $Zero -Type DWORD

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Frequent in Explorer..."
    Set-ItemPropertyVerified -Path $PathToRegExplorer -Name "ShowFrequent" -Value $Zero -Type DWORD

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Snap Assist Flyout..."
    Set-ItemPropertyVerified -Path $PathToRegExplorerAdv -Name "EnableSnapAssistFlyout" -Value $One -Type DWORD

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Show Drives without Media..."
    Set-ItemPropertyVerified -Path "$PathToRegExplorerAdv" -Name "HideDrivesWithNoMedia" -Type DWord -Value $Zero

    Write-Status -Types "+","$TweakType" -Status "Setting Explorer Launch to This PC.."
    Set-ItemPropertyVerified -Path $PathToRegExplorerAdv -Name "LaunchTo" -Value $OneTwo

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) User Files to Desktop..."
    Set-ItemPropertyVerified -Path $PathToRegExplorer\HideDesktopIcons\NewStartPanel -Name $UsersFolder -Value $Zero -Type DWORD

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) This PC to Desktop..."
    Set-ItemPropertyVerified -Path $PathToRegExplorer\HideDesktopIcons\NewStartPanel -Name $ThisPC -Value $Zero -Type DWORD

    Write-Status -Types "+","$TweakType" -Status "Expanding File Operation Details by Default.."
    Set-ItemPropertyVerified -Path "$PathToRegExplorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWORD -Value $One
}