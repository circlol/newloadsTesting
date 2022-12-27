$Global:SetServiceLastUpdated = '20220829'
Import-Module -DisableNameChecking $PSScriptRoot\..\lib\"templates.psm1"
function Find-Service() {
    [CmdletBinding()]
    [OutputType([Bool])]
    param (
        [Parameter(Mandatory = $true)]
        [String] $Service
    )

    If (Get-Service $Service -ErrorAction SilentlyContinue) {
        return $true
    } Else {
        Write-Status -Types "?", $TweakType -Status "The $Service service was not found." -Warning
        return $false
    }
}

function Set-ServiceStartup() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Switch] $Automatic,
        [Parameter(Mandatory = $false)]
        [Switch] $Disabled,
        [Parameter(Mandatory = $false)]
        [Switch] $Manual,
        [Parameter(Mandatory = $true)]
        [Array] $Services,
        [Parameter(Mandatory = $false)]
        [Array] $Filter,
        [Parameter(Mandatory = $false)]
        [ScriptBlock] $CustomMessage
    )

    $Script:SecurityFilterOnEnable = @("RemoteAccess", "RemoteRegistry")
    $Script:TweakType = "Service"

    ForEach ($Service in $Services) {
        If (Find-Service $Service) {
            If (($Service -in $SecurityFilterOnEnable) -and (($Automatic) -or ($Manual))) {
                Write-Status -Types "?", $TweakType -Status "Skipping $Service ($((Get-Service $Service).DisplayName)) to avoid a security vulnerability..." -Warning
                Continue
            }

            If ($Service -in $Filter) {
                Write-Status -Types "?", $TweakType -Status "The $Service ($((Get-Service $Service).DisplayName)) will be skipped as set on Filter..." -Warning
                Continue
            }

            If (!$CustomMessage) {
                If ($Automatic) {
                    Write-Status -Types "+", $TweakType -Status "Setting $Service ($((Get-Service $Service).DisplayName)) as 'Automatic' on Startup..."
                } ElseIf ($Disabled) {
                    Write-Status -Types "-", $TweakType -Status "Setting $Service ($((Get-Service $Service).DisplayName)) as 'Disabled' on Startup..."
                } ElseIf ($Manual) {
                    Write-Status -Types "-", $TweakType -Status "Setting $Service ($((Get-Service $Service).DisplayName)) as 'Manual' on Startup..."
                } Else {
                    Write-Status -Types "?", $TweakType -Status "No parameter received (valid params: -Automatic, -Disabled or -Manual)" -Warning
                }
            } Else {
                Write-Status -Types "@", $TweakType -Status $(Invoke-Expression "$CustomMessage")
            }

            If ($Automatic) {
                Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType Automatic
            } ElseIf ($Disabled) {
                Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType Disabled
            } ElseIf ($Manual) {
                Get-Service -Name "$Service" -ErrorAction SilentlyContinue | Set-Service -StartupType Manual
            }
        }
    }
}

<#
Set-ServiceStartup -Automatic -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -Automatic -Services @("Service1", "Service2", "Service3") -Filter @("Service3")
Set-ServiceStartup -Automatic -Services @("Service1", "Service2", "Service3") -Filter @("Service3") -CustomMessage { "Setting $Service as Automatic!"}

Set-ServiceStartup -Disabled -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -Disabled -Services @("Service1", "Service2", "Service3") -Filter @("Service3")
Set-ServiceStartup -Disabled -Services @("Service1", "Service2", "Service3") -Filter @("Service3") -CustomMessage { "Setting $Service as Disabled!"}

Set-ServiceStartup -Manual -Services @("Service1", "Service2", "Service3")
Set-ServiceStartup -Manual -Services @("Service1", "Service2", "Service3") -Filter @("Service3")
Set-ServiceStartup -Manual -Services @("Service1", "Service2", "Service3") -Filter @("Service3") -CustomMessage { "Setting $Service as Manual!"}
#>

# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUmm/0p5ePQWFmjpsXj6cxGGmd
# mYigggMQMIIDDDCCAfSgAwIBAgIQbsRA190DwbdBuskmJyNY4jANBgkqhkiG9w0B
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
# CQQxFgQUKATt+dySvRzsUgr9QMhMrZSjbN0wDQYJKoZIhvcNAQEBBQAEggEAIi75
# Zrw+VY5WaiwlxFgftzGz7l0QJODf01yHqx/E+xEkOTx7eXUC6Ux7f+VbLN5XWFzP
# mpOVMwnbHAYSIpdWxX2WPEWTr2GRecD2f6Zx1eLaHxKWIv/wDOpe8N6BVneUynE8
# 8VEDMm7u6G5NV/y2p3HhTCUruie8J9E5AIEwEWpgOcy2Ev+eUcTh267QHnJXEcXQ
# IbqucydHwGdJwi2kxVvC/ei7jfkIR/hIkisuA8u6NnkoPMMdRkivurHLthVoZ1WI
# /h592asRxVBx/XBz6yCruN4Phipj0l9wK/wt913lMBW1yQUW4o+CrEgtzQ8WgiNr
# 9tFzYEXv5nYwFc0bmQ==
# SIG # End signature block
