$Global:ManageSoftwareLastUpdated = '20220829'
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"show-dialog-window.psm1"
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"

function Install-Software() {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [String]      $Name,
        [Array]       $Packages,
        [ScriptBlock] $InstallBlock = { winget install --silent --source "winget" --id $Package },
        [Parameter(Mandatory = $false)]
        [Switch]      $NoDialog,
        [String]      $PkgMngr = 'Winget',
        [Switch]      $ViaChocolatey,
        [Switch]      $ViaMSStore,
        [Switch]      $ViaWSL
    )

    $DoneTitle = "Information"
    $DoneMessage = "$Name installed successfully!"

    If ($ViaChocolatey) {
        $ViaMSStore, $ViaWSL = $false, $false
        $PkgMngr = 'Chocolatey'
        $InstallBlock = { choco install --ignore-dependencies --yes $Package }
        Write-Status -Types "?" -Status "Chocolatey is configured to ignore dependencies (bloat), you may need to install it before using any program." -Warning
    }

    If ($ViaMSStore) {
        $ViaChocolatey, $ViaWSL = $false, $false
        $PkgMngr = 'Winget (MS Store)'
        $InstallBlock = { winget install --source "msstore" --id $Package --accept-package-agreements }
    }

    If ($ViaWSL) {
        $ViaChocolatey, $ViaMSStore = $false, $false
        $PkgMngr = 'WSL'
        $InstallBlock = { wsl --install --distribution $Package }
    }

    Write-Title "Installing $($Name) via $PkgMngr"
    $DoneMessage += "`n`nInstalled via $PkgMngr`:`n"

    ForEach ($Package in $Packages) {
        If ($ViaMSStore) {
            Write-Status -Types "?" -Status "Reminder: Press 'Y' and ENTER to continue if stuck (1st time only) ..." -Warning
            $PackageName = (winget search --source 'msstore' --exact $Package)[-1].Replace("$Package Unknown", '').Trim(' ')
            $Private:Counter = Write-TitleCounter -Text "$Package - $PackageName" -Counter $Counter -MaxLength $Packages.Length
        } Else {
            $Private:Counter = Write-TitleCounter -Text "$Package" -Counter $Counter -MaxLength $Packages.Length
        }

        Try {
            Invoke-Expression "$InstallBlock" | Out-Host
            If (($LASTEXITCODE)) { throw "Couldn't install package." } # 0 = False, 1 = True

            If ($ViaMSStore) {
                $DoneMessage += "+ $PackageName ($Package)`n"
            } Else {
                $DoneMessage += "+ $Package`n"
            }
        } Catch {
            Write-Status -Types "!" -Status "Failed to install package via $PkgMngr" -Warning

            If ($ViaMSStore) {
                Start-Process "ms-windows-store://pdp/?ProductId=$Package"
                $DoneMessage += "! $PackageName ($Package)`n"
            } Else {
                $DoneMessage += "! $Package`n"
            }
        }
    }

    Write-Host "$DoneMessage" -ForegroundColor Cyan

    If (!($NoDialog)) {
        Show-Message -Title "$DoneTitle" -Message "$DoneMessage"
    }

    return $DoneMessage
}

function Uninstall-Software() {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [String]      $Name,
        [Array]       $Packages,
        [ScriptBlock] $UninstallBlock = { winget uninstall --source "winget" --id $Package },
        [Parameter(Mandatory = $false)]
        [Switch]      $NoDialog,
        [String]      $PkgMngr = 'Winget',
        [Switch]      $ViaChocolatey,
        [Switch]      $ViaMSStore,
        [Switch]      $ViaWSL
    )

    $DoneTitle = "Information"
    $DoneMessage = "$Name uninstalled successfully!"

    If ($ViaChocolatey) {
        $ViaMSStore, $ViaWSL = $false, $false
        $PkgMngr = 'Chocolatey'
        $UninstallBlock = { choco uninstall --remove-dependencies --yes $Package }
        Write-Status -Types "?" -Status "Chocolatey is configured to remove dependencies (bloat), you may need to install it before using any program." -Warning
    }

    If ($ViaMSStore) {
        $ViaChocolatey, $ViaWSL = $false, $false
        $PkgMngr = 'Winget (MS Store)'
        $UninstallBlock = { winget uninstall --source "msstore" --id $Package }
    }

    If ($ViaWSL) {
        $ViaChocolatey, $ViaMSStore = $false, $false
        $PkgMngr = 'WSL'
        $UninstallBlock = { wsl --unregister $Package }
    }

    Write-Title "Uninstalling $($Name) via $PkgMngr"
    $DoneMessage += "`n`nUninstalled via $PkgMngr`:`n"

    ForEach ($Package in $Packages) {
        If ($ViaMSStore) {
            $PackageName = (winget search --source 'msstore' --exact $Package)[-1].Replace("$Package Unknown", '').Trim(' ')
            $Private:Counter = Write-TitleCounter -Text "$Package - $PackageName" -Counter $Counter -MaxLength $Packages.Length
        } Else {
            $Private:Counter = Write-TitleCounter -Text "$Package" -Counter $Counter -MaxLength $Packages.Length
        }

        Try {
            Invoke-Expression "$UninstallBlock" | Out-Host
            If (($LASTEXITCODE)) { throw "Couldn't uninstall package." } # 0 = False, 1 = True

            If ($ViaMSStore) {
                $DoneMessage += "- $PackageName ($Package)`n"
            } Else {
                $DoneMessage += "- $Package`n"
            }
        } Catch {
            Write-Status -Types "!" -Status "Failed to uninstall package via $PkgMngr" -Warning

            If ($ViaMSStore) {
                $DoneMessage += "! $PackageName ($Package)`n"
            } Else {
                $DoneMessage += "! $Package`n"
            }
        }
    }

    Write-Host "$DoneMessage" -ForegroundColor Cyan

    If (!($NoDialog)) {
        Show-Message -Title "$DoneTitle" -Message "$DoneMessage"
    }

    return $DoneMessage
}

<#
Example:
Install-Software -Name "Brave Browser" -Packages "BraveSoftware.BraveBrowser"
Install-Software -Name "Brave Browser" -Packages "BraveSoftware.BraveBrowser" -NoDialog
Install-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaChocolatey
Install-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaChocolatey -NoDialog
Install-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaMSStore
Install-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaMSStore -NoDialog
Install-Software -Name "Ubuntu" -Packages "Ubuntu" -ViaWSL
Install-Software -Name "Ubuntu" -Packages "Ubuntu" -ViaWSL -NoDialog

Uninstall-Software -Name "Brave Browser" -Packages "BraveSoftware.BraveBrowser"
Uninstall-Software -Name "Brave Browser" -Packages "BraveSoftware.BraveBrowser" -NoDialog
Uninstall-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaChocolatey
Uninstall-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaChocolatey -NoDialog
Uninstall-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaMSStore
Uninstall-Software -Name "Multiple Packages" -Packages @("Package1", "Package2", "Package3", ...) -ViaMSStore -NoDialog
Uninstall-Software -Name "Ubuntu" -Packages "Ubuntu" -ViaWSL
Uninstall-Software -Name "Ubuntu" -Packages "Ubuntu" -ViaWSL -NoDialog
#>

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUOiT1QaabxhZzoUwDuyYkB8Nu
# iOCgggMQMIIDDDCCAfSgAwIBAgIQbsRA190DwbdBuskmJyNY4jANBgkqhkiG9w0B
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
# CQQxFgQU5PSWI1mIZjfZBl8DzhA0S0HpbMEwDQYJKoZIhvcNAQEBBQAEggEAjzSE
# DZ0uyJhltTPHfSJgNyai2UnMSVaQ/eUycxIt8F1tg4AEtNItT3NfQ2I0lySi80G3
# kD/hGoUrmXYs6yIBxgbh728Sl2NIB5ayPUd5VdHpb04li2G0vSt8Z2+ONaNjvCZw
# LLLXaJPhyQpBlj2Wf67pW52R+z6Us2coite2YZODVWsMxqIdayvXGlENYsZnQOqC
# Rq9qKUhp7zEGpDjubozc99IUr0+MKvb+KDo7Hx72Q8Sa+5Xb4w75jtxmjAaRukIu
# 8Z2dg6oAvT+V+s+VXEQ97pkWdkIxgakoAYAgJDMtAKa6wqPcCj2g2ZxAhks3xoL9
# RDrJfTxc5bc6gysYOA==
# SIG # End signature block
