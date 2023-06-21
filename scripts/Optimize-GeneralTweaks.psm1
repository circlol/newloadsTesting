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

#$TweakType = "Registry"
#Write-Host "`n" ; Write-TitleCounter -Counter '8' -MaxLength $MaxLength -Text "Optimization"

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
        Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status)  3D Objects from This PC.."
        Remove-Item -Path $PathToHide3DObjects -Recurse
    }

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Expanded Ribbon in Explorer.."
    Set-ItemPropertyVerified -Path $PathToRegExplorer\Ribbon -Name "MinimizedStateTabletModeOff" -Type DWORD -Value $Zero

    ## Disabling Feeds Open on Hover
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Feeds Open on Hover..."
    Set-ItemPropertyVerified -Path $PathToRegCurrentVersion\Feeds -Name "ShellFeedsTaskbarOpenOnHover" -Value $Zero -Type DWord

    #Disables live feeds in search
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Dynamic Content in Windows Search..."
    Set-ItemPropertyVerified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds\DSB" -Name "ShowDynamicContent" -Value $Zero -type DWORD
    Set-ItemPropertyVerified -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsDynamicSearchBoxEnabled" -Value $Zero -Type DWORD
}elseif ($osVersion -like "*11*") {
    ## Code for Windows 11
    Write-Section -Text "Applying Windows 11 Specific Reg Keys"
    If ($BuildNumber -GE $22H2) {
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) More Icons in the Start Menu.."
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
    Throw{"Don't know what happened. Closing"}
}

    Write-Section -Text "Explorer Related"

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
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Recents in Explorer..."
    Set-ItemPropertyVerified -Path $PathToRegExplorer -Name "ShowRecent" -Value $Zero -Type DWORD

    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Show Frequent in Explorer..."
    Set-ItemPropertyVerified -Path $PathToRegExplorer -Name "ShowFrequent" -Value $Zero -Type DWORD

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) Show Drives without Media..."
    Set-ItemPropertyVerified -Path "$PathToRegExplorerAdv" -Name "HideDrivesWithNoMedia" -Type DWord -Value $Zero

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting Explorer Launch to This PC.."
    Set-ItemPropertyVerified -Path $PathToRegExplorerAdv -Name "LaunchTo" -Value $One -Type Dword

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) User Files to Desktop..."
    Set-ItemPropertyVerified -Path $PathToRegExplorer\HideDesktopIcons\NewStartPanel -Name $UsersFolder -Value $Zero -Type DWORD

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "$($EnableStatus[1].Status) This PC to Desktop..."
    Set-ItemPropertyVerified -Path $PathToRegExplorer\HideDesktopIcons\NewStartPanel -Name $ThisPC -Value $Zero -Type DWORD

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Expanding File Operation Details by Default.."
    Set-ItemPropertyVerified -Path "$PathToRegExplorer\OperationStatusManager" -Name "EnthusiastMode" -Type DWORD -Value $One


}
# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUceBpCU2UZLdKf2v4cUPFtomD
# EGmgggMQMIIDDDCCAfSgAwIBAgIQOtpMekE2BIRJ/swv2v8NGDANBgkqhkiG9w0B
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
# CQQxFgQUPLkK32qhuJwEGev7tM2gVnFkLT0wDQYJKoZIhvcNAQEBBQAEggEAX/e0
# JS/b7xP1oXQ7AjUsMItu34HewE7um4hieIQpbeYxTDBJf7WHbeiJD5+7MbuarG2h
# fvpE47chGjOVh6tnkG9bfJLbzyt09dAE1/aSiwzDqYdRJaeyedFTFPFBvmom5Mq/
# BnQD5/ebRs0Uwc2cYKri4CpTzG/z7SngLQB0f74W5HeDW+4ijwhT/Qf7Vujg0DQ3
# rqB69oiOsYmBXRmNEJDcq/HYL/pWe9eFOiFEgvnaua3QyJGoLkDS+LpS/T65/sYk
# 4VBJAxcL6ngNIpXaCIpBWBgHka5rQ+nWzFtWtRI79Mh1X+1v1wrgapZh02jpkQbt
# 7xE8usMnuijIpe9G+g==
# SIG # End signature block
