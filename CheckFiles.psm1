Function CheckFiles() {
    
    Try{
        If (Test-Path ".\tmp.txt") { Write-Status -Types "-" -Status "Removing a previously runs tmp.txt." ; Remove-Item ".\tmp.txt" -Force}
        If (!(Test-Path ".\bin")) { Write-Status -Types "+" -Status "Creating Bin Folder." ; mkdir ".\bin" }
        If (!(Test-Path ".\assets")) { Write-Status -Types "+" -Status "Creating Assets Folder." ; mkdir ".\assets" }
        If (!(Test-Path ".\lib")) { Write-Status -Types "+" -Status "Creating Lib Folder." ; mkdir ".\lib" }
        If (Test-Path .\ErrorLog.txt) { Write-Status -Types "-" -Status "Removing a previous runs ErrorLog.txt." ; Remove-Item -Path ".\ErrorLog.txt"}
        "$(Get-Date) - New Loads Error Log:" | Out-File ".\newloads-errorlog.txt"
        #ForEach ($CurrentLibFile in $CurrentLibFiles){Remove-Item -Path .\lib\"$CurrentLibFile" -Force}
    }Catch{}

    Write-Section -Text "Scanning Exisitng Files"
    
    $Files = @(
        "Assets\start.bin"
        "Assets\10.jpg"
        "Assets\10_mGaming.png"
        "Assets\11.jpg"
        "Assets\11_mGaming.png"
        "Assets\Microsoft.HEVCVideoExtension_2.0.51121.0_x64__8wekyb3d8bbwe.appx"
        "lib\get-hardware-info.psm1"
        "lib\gui.psm1"
        "lib\new-shortcut.psm1"
        "lib\office.psm1"
        "lib\optimization.psm1"
        #"lib\open-file.psm1"
        "lib\restart-explorer.psm1"
        "lib\remove-uwp-appx.psm1"
        "lib\optimization.psm1"
        "lib\restart-explorer.psm1"
        "lib\set-scheduled-task-state.psm1"
        "lib\set-service-startup.psm1"
        #"lib\set-wallpaper.psm1"
        "lib\set-windows-feature-state.psm1"
        "lib\show-dialog-window.psm1"
        #"lib\undoScript.psm1"
        )
    #  Generates an Empty Array  #
    $Items = [System.Collections.ArrayList]::new()

    # Checks if each file exists on the computer #
    ForEach ($file in $files) {
        If (Test-Path ".\$File") {
            Write-CaptionSucceed -Text "$File Validated"
        }else {
            Write-CaptionFailed -Text "$file Failed to validate."
            $Items += $file
        }
    }

    # Validates files - Downloads missing files from github #
    If (!($Items)) {
        Write-Section -Text "All packages successfully validated."
    }else {

        $ItemsFile = ".\tmp.txt"
        $Items | Out-File $ItemsFile -Encoding ASCII 
        (Get-Content $ItemsFile).replace('\', '/') | Set-Content $ItemsFile
        $urls = Get-Content $ItemsFile
        CheckNetworkStatus
        Write-Section -Text "Downloading Missing Files"
        Try {
            ForEach ($url in $urls) {
                Write-Caption "Attempting to Download $url"
                $link = "https://raw.githubusercontent.com/circlol/newloadsTesting/main/" + $url.replace('\', '/')
                Start-BitsTransfer -Dynamic -Source "$link" -Destination ".\$url" -Verbose -TransferType Download -RetryTimeout 60 -RetryInterval 60 -Confirm:$False | Out-Host
                Check ; ""
            }
        }Catch{Continue}
        Write-Status -Types "-" -Status "Removing $ItemsFile"
        Remove-Item $ItemsFile
    }
}
# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUlzitXq9I3alsio+03kvfRiuM
# yH6gggMQMIIDDDCCAfSgAwIBAgIQbsRA190DwbdBuskmJyNY4jANBgkqhkiG9w0B
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
# CQQxFgQUWvt1hSC6jZwk8GDwXCLSV9gea+QwDQYJKoZIhvcNAQEBBQAEggEAC6iH
# e40qn2l05bReSpnPeRVT4PNIQvQZkyOkEQvvN+3kwwreGVEm0dMUZ2F/Sjrr3omS
# ZQpdNsLQ/WsCiQ8s9NscLmMzd1wj6j0SGwk7izwJzJAcmzFlju1IUNVtD8WXttRL
# 5SrkZKHNoKlMh8XuwSNA08+ZzYdw0Zs16CsbMSmGVyb/yVIu+hYQkq2BiMpm3OZr
# sRE4AuOQTvZU+iQuURS3ZcKlwwHd5COdo6VmM4vMEE0rR+jQooeQvFvStX1bKjEv
# 9RhhYGSCzyR/5MdolezoU6c7V7s1CRtGRPG+P8+y1SMJ8FR38UKy2Utx9jaVIyVG
# ssqWRREKZ//HwMkBhg==
# SIG # End signature block
