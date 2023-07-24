<#
.SYNOPSIS
Sets the script status and performs various actions based on the provided parameters.

.DESCRIPTION
The Set-ScriptStatus function is used to set the status of a script and perform specific actions based on the provided parameters. It is apart of New Loads by Circlol and uses custom commands such as Write-Section, Write-TitleCounter, sets a tweak type variable, change the window title, and create a checkpoint by saving the state to the registry.

.PARAMETER AddCounter
Specifies whether to increment the script counter. If this switch is provided, the function will increment the $Counter variable by 1.

.PARAMETER Section
Indicates whether to display a section text. If this parameter is set to $true, the function will use the SectionText parameter to display the section information.

.PARAMETER SectionText
The text to be displayed when the -Section switch is used. This parameter is used to indicate the current section or phase of the script.

.PARAMETER Title
Specifies whether to display a title text with the counter. If this parameter is set to $true, the function will use the TitleText parameter to display the title information along with the current counter value.

.PARAMETER TitleText
The text to be displayed as the title when the -Title switch is used. This parameter is used to provide a descriptive title for the current phase or action of the script.

.PARAMETER TweakType
Sets the value of the $TweakType variable to the specified value. This parameter allows customization of the script behavior based on different tweak types.

.PARAMETER WindowTitle
Changes the window title of the current PowerShell host to include the provided text. This parameter can be used to give the script's PowerShell window a more descriptive title.

.PARAMETER SaveState
Creates a checkpoint for the specified state by saving it to the registry under HKCU:\Software\New Loads\SaveState. This parameter is used to store the state of the script for future reference or recovery.

.EXAMPLE
Set-ScriptStatus -AddCounter -Section -SectionText "Processing Phase" -Title -TitleText "Processing Items" -TweakType "Fast" -WindowTitle "Script Execution"

DESCRIPTION
    Sets the script status by incrementing the counter, displaying the section "Processing Phase," showing the title "Processing Items (1/2)", setting the $TweakType to "Fast", and changing the window title to "New Loads - Script Execution".
.LINK
https://github.com/circlol/newloadsTesting/blob/main/lib/Set-ScriptStatus.psm1

.EXAMPLE
Set-ScriptStatus -SaveState "InitialSetup"

DESCRIPTION
    Sets the script status by creating a checkpoint for the state "InitialSetup" and saving it to the registry.
#>
Function Set-ScriptStatus() {
    param(
        [Switch]$AddCounter,
        [Boolean]$Section,
        [String]$SectionText,
        [Boolean]$Title,
        [String]$TitleText,
        [String]$TweakType,
        [String]$WindowTitle,
        [String]$SaveState
    )
    If ($AddCounter){
        $Counter++
    }
    If ($SaveState){
        Write-Status "+","SaveState" -Status "-> Creating checkpoint for $SaveState"
        Set-ItemPropertyVerified -Path "HKCU:\Software\New Loads" -Name "SaveState" -Value "$SaveState" -Type STRING
    }
    If ($Section -eq $True){
        Write-Section -Text $SectionText
    }
    If ($Title -eq $True){  
        Write-TitleCounter -Counter $Counter -MaxLength $MaxLength -Text $TitleText
    }
    If ($TweakType){
        Set-Variable -Name 'TweakType' -Value $TweakType -Scope Global -Force
    }
    If ($WindowTitle){
        $host.UI.RawUI.WindowTitle = "New Loads - $WindowTitle"
    }
}


Function Get-ScriptStatus() {
    If ($SaveState){
        $CurrentSaveState = Get-ItemProperty -Path "$SaveStatePath\$SaveState" -Name Active
        Write-Host "Current Save State: $CurrentSaveState"
    }
    If ($TweakType){
        $CurrentTweakType = Get-Variable -Name "PATH TO STUFF"
        Write-Host "Current Tweak Type: $CurrentTweakType"
    }
    If ($WindowTitle){
        $CurrentTitle = $host.UI.RawUI.WindowTitle
        Write-Host "Current Title: $CurrentTitle"
    }
    If ($Title -eq $True){
        $CurrentTitleCounter = $Counter
        Write-Host "Current Section: $CurrentTitleCounter"
    }
}




# SIG # Begin signature block
# MIIHAwYJKoZIhvcNAQcCoIIG9DCCBvACAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUYLaJ2pi82PIFGhcDlD5yryOp
# zf2gggQiMIIEHjCCAwagAwIBAgIQSGGcb8+NWotO0lk12RTDYTANBgkqhkiG9w0B
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
# IwYJKoZIhvcNAQkEMRYEFM+rat6hBeGdiXB5yRFLGU/EUF38MA0GCSqGSIb3DQEB
# AQUABIIBABqrejPMnjR0CxKJa8GHUlm46PKMogog8lNx0jAUxQlsIVyNQSaLLIKQ
# /Z1mvEytVjC3WnCoU6UDcgM+W6NkwsaysBdWD2HF6yrmHorsdps/h/TY2tYJny9I
# U1ghCzSPiy5wB+P2WB6HDvFG9uAUn9BZv1WcpUwQ2yV//3+zoRf7h0qdh6JjpJ+q
# 2OKC/oc7CCGshgum4uABvEzLc8LzP4JVjMXChQKppeK330rxruSBRJjZB4wgNP/N
# r0oadkre9tDCTjn+TCfBUfzg2XfRUJBr4LFOoM30cGp04G05C/kPn81QKSktAXXC
# qahdOssN9AGhwV/T/eFO0kqVZSh9INE=
# SIG # End signature block
