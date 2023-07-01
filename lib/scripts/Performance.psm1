Function Optimize-Performance{
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
    Write-Status -Types "<", $TweakType -Status "Reverting the tweaks is set to '$Revert'." -WriteWarning
    $Zero = 1
    $One = 0
    $OneTwo = 2
    $EnableStatus = @(
        @{ Symbol = "<"; Status = "Re-Enabling"; }
        @{ Symbol = "<"; Status = "Re-Disabling"; }
    )
}

    $ExistingPowerPlans = $((powercfg -L)[3..(powercfg -L).Count])
    # Found on the registry: HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\User\Default\PowerSchemes
    $BuiltInPowerPlans = @{
    "Power Saver"            = "a1841308-3541-4fab-bc81-f71556f20b4a"
    "Balanced (recommended)" = "381b4222-f694-41f0-9685-ff5bb260df2e"
    "High Performance"       = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
    "Ultimate Performance"   = "e9a42b02-d5df-448d-aa00-03f14749eb61"
    }
    $UniquePowerPlans = $BuiltInPowerPlans.Clone()

    Write-Title "Performance Tweaks"
    Write-Section "System"
    Write-Caption "Display"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Enable Hardware Accelerated GPU Scheduling... (Windows 10 20H1+ - Needs Restart)"
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Type DWord -Value 2
    #Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Remote Assistance..."
    #Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type DWord -Value $Zero

    # [@] (2 = Enable Ndu, 4 = Disable Ndu)
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Ndu High RAM Usage..."
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\ControlSet001\Services\Ndu" -Name "Start" -Type DWord -Value 4
    # Details: https://www.tenforums.com/tutorials/94628-change-split-threshold-svchost-exe-windows-10-a.html
    # Will reduce Processes number considerably on > 4GB of RAM systems

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting SVCHost to match installed RAM size..."
    $RamInKB = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1KB
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $RamInKB

    #Write-Status -Types "*", $TweakType -Status "Enabling Windows Store apps Automatic Updates..."
    #If ((Get-Item "$PathToLMPoliciesWindowsStore" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue).GetValueNames() -like "AutoDownload") {
        #Remove-ItemProperty -Path "$PathToLMPoliciesWindowsStore" -Name "AutoDownload" # [@] (2 = Disable, 4 = Enable)
    #}


    Write-Section "Microsoft Edge Tweaks"
    Write-Caption "System and Performance"
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) Edge Startup boost..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesEdge" -Name "StartupBoostEnabled" -Type DWord -Value $Zero
    Write-Status -Types $EnableStatus[0].Symbol, $TweakType -Status "$($EnableStatus[0].Status) run extensions and apps when Edge is closed..."
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesEdge" -Name "BackgroundModeEnabled" -Type DWord -Value $Zero

    Write-Section -Text "Power Plan Tweaks"
    Write-Status -Types "@", $TweakType -Status "Cleaning up duplicated Power plans..."
    ForEach ($PowerCfgString in $ExistingPowerPlans) {
        $PowerPlanGUID = $PowerCfgString.Split(':')[1].Split('(')[0].Trim()
        $PowerPlanName = $PowerCfgString.Split('(')[-1].Replace(')', '').Trim()
        If (($PowerPlanGUID -in $BuiltInPowerPlans.Values)) {
            Write-Status -Types "@", $TweakType -Status "The '$PowerPlanName' power plan` is built-in, skipping $PowerPlanGUID ..." -WriteWarning
            Continue
        }
        Try {
            If (($PowerPlanName -notin $UniquePowerPlans.Keys) -and ($PowerPlanGUID -notin $UniquePowerPlans.Values)) {
                $UniquePowerPlans.Add($PowerPlanName, $PowerPlanGUID)
            }
            Else {
                Write-Status -Types "-", $TweakType -Status "Duplicated '$PowerPlanName' power plan found, deleting $PowerPlanGUID ..."
                powercfg -Delete $PowerPlanGUID
            }
        }
        Catch {
            Write-Status -Types "-", $TweakType -Status "Duplicated '$PowerPlanName' power plan found, deleting $PowerPlanGUID ..."
            powercfg -Delete $PowerPlanGUID
        }
    }

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Monitor Timeout to AC: $TimeoutScreenPluggedIn and DC: $TimeoutScreenBattery..."
    powercfg -Change Monitor-Timeout-AC $TimeoutScreenPluggedIn
    powercfg -Change Monitor-Timeout-DC $TimeoutScreenBattery

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Standby Timeout to AC: $TimeoutStandByPluggedIn and DC: $TimeoutStandByBattery..."
    powercfg -Change Standby-Timeout-AC $TimeoutStandByPluggedIn
    powercfg -Change Standby-Timeout-DC $TimeoutStandByBattery

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Disk Timeout to AC: $TimeoutDiskPluggedIn and DC: $TimeoutDiskBattery..."
    powercfg -Change Disk-Timeout-AC $TimeoutDiskPluggedIn
    powercfg -Change Disk-Timeout-DC $TimeoutDiskBattery

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting the Hibernate Timeout to AC: $TimeoutHibernatePluggedIn and DC: $TimeoutHibernateBattery..."
    powercfg -Change Hibernate-Timeout-AC $TimeoutHibernatePluggedIn
    Powercfg -Change Hibernate-Timeout-DC $TimeoutHibernateBattery    

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Setting Power Plan to High Performance..."
    powercfg -SetActive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c


    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Creating the Ultimate Performance hidden Power Plan..."
    powercfg -DuplicateScheme e9a42b02-d5df-448d-aa00-03f14749eb61


    Write-Section "Network & Internet"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Unlimiting your network bandwidth for all your system..." # Based on this Chris Titus video: https://youtu.be/7u1miYJmJ_4
    Set-ItemPropertyVerified -Path "$PathToLMPoliciesPsched" -Name "NonBestEffortLimit" -Type DWord -Value 0
    Set-ItemPropertyVerified -Path "$PathToLMMultimediaSystemProfile" -Name "NetworkThrottlingIndex" -Type DWord -Value 0xffffffff


    Write-Section "System & Apps Timeout behaviors"
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reducing Time to services app timeout to 2s to ALL users..."
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -Type DWord -Value 2000 # Default: 20000 / 5000
    Write-Status -Types "*", $TweakType -Status "Don't clear page file at shutdown (takes more time) to ALL users..."
    Set-ItemPropertyVerified -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "ClearPageFileAtShutdown" -Type DWord -Value 0 # Default: 0
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reducing mouse hover time events to 10ms..."
    Set-ItemPropertyVerified -Path "HKCU:\Control Panel\Mouse" -Name "MouseHoverTime" -Type String -Value "1000" # Default: 400


    # Details: https://windowsreport.com/how-to-speed-up-windows-11-animations/ and https://www.tenforums.com/tutorials/97842-change-hungapptimeout-value-windows-10-a.html
    ForEach ($DesktopRegistryPath in @($PathToUsersControlPanelDesktop, $PathToCUControlPanelDesktop)) {
        <# $DesktopRegistryPath is the path related to all users and current user configuration #>
        If ($DesktopRegistryPath -eq $PathToUsersControlPanelDesktop) {
            Write-Caption "TO ALL USERS"
        } ElseIf ($DesktopRegistryPath -eq $PathToCUControlPanelDesktop) {
            Write-Caption "TO CURRENT USER"
        }
        Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Don't prompt user to end tasks on shutdown..."
        Set-ItemPropertyVerified -Path "$DesktopRegistryPath" -Name "AutoEndTasks" -Type DWord -Value 1 # Default: Removed or 0

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
    Set-ItemPropertyVerified -Path "$PathToCUGameBar" -Name "AllowAutoGameMode" -Type DWord -Value 1
    Set-ItemPropertyVerified -Path "$PathToCUGameBar" -Name "AutoGameModeEnabled" -Type DWord -Value 1

    # Details: https://www.reddit.com/r/killerinstinct/comments/4fcdhy/an_excellent_guide_to_optimizing_your_windows_10/
    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Reserving 100% of CPU to Multimedia/Gaming tasks..."
    Set-ItemPropertyVerified -Path "$PathToLMMultimediaSystemProfile" -Name "SystemResponsiveness" -Type DWord -Value 0 # Default: 20

    Write-Status -Types $EnableStatus[1].Symbol, $TweakType -Status "Dedicate more CPU/GPU usage to Gaming tasks..."
    Set-ItemPropertyVerified -Path "$PathToLMMultimediaSystemProfileOnGameTasks" -Name "GPU Priority" -Type DWord -Value 8 # Default: 8
    Set-ItemPropertyVerified -Path "$PathToLMMultimediaSystemProfileOnGameTasks" -Name "Priority" -Type DWord -Value 6 # Default: 2
    Set-ItemPropertyVerified -Path "$PathToLMMultimediaSystemProfileOnGameTasks" -Name "Scheduling Category" -Type String -Value "High" # Default: "Medium"

}

# SIG # Begin signature block
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUoKA1WpPUHT9hrBAXtkpvRe7U
# kLegggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFJywd9q0WvxMQEFCTZ8NyGzXvboVMA0GCSqGSIb3DQEB
# AQUABIIBAI62Z981oYz0NkLMjON2/ymoDo5GE7IYp7OpL8IzVFjd2Y+pq9W57XFQ
# Lh4ZDLiTsENwfKCvKeNtTgfI8HdZwCJwfepaMypxHj9qJgBZ2anY9eoGpM+w5PdG
# 3ssiv5Q6HrYxYpqwmJMKKmVuAI4rWd8TzXBiyIonE6QfdLfJ0RjSzG3SeOa3jQ7C
# E9/Bmyb6mEKKF3flQYdT9fk2kWDr4qh/bF8h4JcEfycH4tKPIlAk1xJJcPsj65Ii
# vc61HK+Af8ohlbUi7QAC/Dk9u9JpraXEXXPgzQejKFaCtnJw8sYdiv8i2Qh79Aj0
# niGxuAoM8l2MExhK+JvPhnoEVV1hZTg=
# SIG # End signature block
