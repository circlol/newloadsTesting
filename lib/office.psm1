$Global:OfficeLastUpdated = '20221014'
Function OfficeCheck() {
    Write-Host "`n" ; Write-TitleCounter -Counter '7' -MaxLength $MaxLength -Text "Office Removal"
    Write-Status -Types "?" -Status "Checking for Office"
    If (Test-Path "$PathToOffice64") { $office64 = $true }Else { $office64 = $false }
    If (Test-Path "$PathToOffice86") { $Office32 = $true }Else { $office32 = $false }
    If ($office32 -eq $true) { $officecheck = $true }       
    If ($office64 -eq $true) { $officecheck = $true }    
    If ($officecheck -eq $true) { Write-Status -Types "WAITING" -Status "Office Exists" -Warning }Else { Write-Status -Types "?" -Status "Office Doesn't Exist on This Machine" -Warning }
    If ($officecheck -eq $true) { Office_Removal_AskUser }
}
Function Office_Removal_AskUser() {
    $TweakType = "Office"
    $SaRAURL = "https://github.com/circlol/newload/raw/main/SaRACmd_17_0_9246_0.zip"
    
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    $msgBoxInput = [System.Windows.Forms.MessageBox]::Show('  OFFICE EXISTS ON THIS PC:  SHALL I REMOVE IT?', 'New Loads', 'YesNoCancel', 'Question')
    switch ($msgBoxInput) {
    
        'Yes' {
            CheckNetworkStatus
            Write-Status "+", $TweakType -Status "Downloading Microsoft Support and Recovery Assistant (SaRA)..."
            #Start-BitsTransfer -Source:https://aka.ms/SaRA_CommandLineVersionFiles -Destination:"$SaRA" | Out-Host
            Start-BitsTransfer -Source:$SaRAURL -Destination:$SaRA -TransferType Download -Dynamic | Out-Host
            Expand-Archive -Path $SaRA -DestinationPath $Sexp -Force
            Check
            $SaRAcmdexe = (Get-ChildItem ".\SaRA\" -Include SaRAcmd.exe -Recurse).FullName

            Write-Status "+", $TweakType -Status "Starting OfficeScrubScenario via Microsoft Support and Recovery Assistant (SaRA)... "
            Start-Process "$SaRAcmdexe" -ArgumentList "-S OfficeScrubScenario -AcceptEula -OfficeVersion All" -NoNewWindow | Out-Host
        }
    
        'No' {
            Write-Status -Types "?" -Status "Skipping Office Removal" -Warning
        }
        'Cancel'{
            Write-Status -Types "?" -Status "Skipping Office Removal" -Warning
        }
    }    
    
}


# SIG # Begin signature block
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUfUzas5OGLJ5iqI+EVkqLEwvq
# 3ymgggMQMIIDDDCCAfSgAwIBAgIQbsRA190DwbdBuskmJyNY4jANBgkqhkiG9w0B
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
# CQQxFgQUo11kfu7UHuFCIKWdZ6DHYItymfQwDQYJKoZIhvcNAQEBBQAEggEAN6F2
# j6pgFAVb0p/R6ipq5cKVliywLYMtFKqnco+m8SsT0p9yT4TjMbDT9onEsd0xY36P
# oEP0RPZ41Fs7QTUvInKNmqr4Y0WsrWaUqXx/Dt8f/5a2PfaQZZOKcOdbkJDdEDDg
# eSNPXxLg4tTeRHadvbtpo43mXkOQaC4IiZ08HXn7CU4MNegTP783NoLyIbU3+k7t
# /5JW48nhmul/4zZREgY1FQ+HaJJLrceBaeOMFKunKKDGjFG9KDL2xXpgx9QHTlyA
# liq6LCHMEohFW87zqH3rEIvttqvksHByqVF891PooAQo3Qe38qCNwBPb/jyDfYsN
# Iy1Z/Q00z5qDPE4QFQ==
# SIG # End signature block
