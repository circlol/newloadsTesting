Function Optimize-Services{
    $IsSystemDriveSSD = $(Get-OSDriveType) -eq "SSD"
    $EnableServicesOnSSD = @("SysMain", "WSearch")
    # Services which will be totally disabled
    $ServicesToDisabled = @(
        "DiagTrack"                                 # DEFAULT: Automatic | Connected User Experiences and Telemetry
        "diagnosticshub.standardcollector.service"  # DEFAULT: Manual    | Microsoft (R) Diagnostics Hub Standard Collector Service
        "dmwappushservice"                          # DEFAULT: Manual    | Device Management Wireless Application Protocol (WAP)
        #"BthAvctpSvc"                               # DEFAULT: Manual    | AVCTP Service - This is Audio Video Control Transport Protocol service
        #"Fax"                                       # DEFAULT: Manual    | Fax Service
        "fhsvc"                                     # DEFAULT: Manual    | Fax History Service
        "GraphicsPerfSvc"                           # DEFAULT: Manual    | Graphics performance monitor service
        "HomeGroupListener"                         # NOT FOUND (Win 10+)| HomeGroup Listener
        "HomeGroupProvider"                         # NOT FOUND (Win 10+)| HomeGroup Provider
        "lfsvc"                                     # DEFAULT: Manual    | Geolocation Service
        "MapsBroker"                                # DEFAULT: Automatic | Downloaded Maps Manager
        "PcaSvc"                                    # DEFAULT: Automatic | Program Compatibility Assistant (PCA)
        "RemoteAccess"                              # DEFAULT: Disabled  | Routing and Remote Access
        "RemoteRegistry"                            # DEFAULT: Disabled  | Remote Registry
        "RetailDemo"                                # DEFAULT: Manual    | The Retail Demo Service controls device activity while the device is in retail demo mode.
        "SysMain"                                   # DEFAULT: Automatic | SysMain / Superfetch (100% Disk usage on HDDs)
        # read://https_helpdeskgeek.com/?url=https%3A%2F%2Fhelpdeskgeek.com%2Fhelp-desk%2Fdelete-disable-windows-prefetch%2F%23%3A~%3Atext%3DShould%2520You%2520Kill%2520Superfetch%2520(Sysmain)%3F
        "TrkWks"                                    # DEFAULT: Automatic | Distributed Link Tracking Client
        "WSearch"                                   # DEFAULT: Automatic | Windows Search (100% Disk usage on HDDs)
        # - Services which cannot be disabled (and shouldn't)
        #"wscsvc"                                   # DEFAULT: Automatic | Windows Security Center Service
        #"WdNisSvc"                                 # DEFAULT: Manual    | Windows Defender Network Inspection Service
        "NPSMSvc_df772"
        "LanmanServer"
    )
    # Making the services to run only when needed as 'Manual' | Remove the # to set to Manual
    $ServicesToManual = @(
        "BITS"                           # DEFAULT: Manual    | Background Intelligent Transfer Service
        "BDESVC"                         # DEFAULT: Manual    | BItLocker Drive Encryption Service
        #"cbdhsvc_*"                      # DEFAULT: Manual    | Clipboard User Service
        "edgeupdate"                     # DEFAULT: Automatic | Microsoft Edge Update Service
        "edgeupdatem"                    # DEFAULT: Manual    | Microsoft Edge Update Service²
        "FontCache"                      # DEFAULT: Automatic | Windows Font Cache
        "iphlpsvc"                       # DEFAULT: Automatic | IP Helper Service (IPv6 (6to4, ISATAP, Port Proxy and Teredo) and IP-HTTPS)
        "lmhosts"                        # DEFAULT: Manual    | TCP/IP NetBIOS Helper
        "ndu"                            # DEFAULT: Automatic | Windows Network Data Usage Monitoring Driver (Shows network usage per-process on Task Manager)
        #"NetTcpPortSharing"             # DEFAULT: Disabled  | Net.Tcp Port Sharing Service
        "PhoneSvc"                       # DEFAULT: Manual    | Phone Service (Manages the telephony state on the device)
        "SCardSvr"                       # DEFAULT: Manual    | Smart Card Service
        "SharedAccess"                   # DEFAULT: Manual    | Internet Connection Sharing (ICS)
        "stisvc"                         # DEFAULT: Automatic | Windows Image Acquisition (WIA) Service
        "WbioSrvc"                       # DEFAULT: Manual    | Windows Biometric Service (required for Fingerprint reader / Facial detection)
        "Wecsvc"                         # DEFAULT: Manual    | Windows Event Collector Service
        "WerSvc"                         # DEFAULT: Manual    | Windows Error Reporting Service
        "wisvc"                          # DEFAULT: Manual    | Windows Insider Program Service
        "WMPNetworkSvc"                  # DEFAULT: Manual    | Windows Media Player Network Sharing Service
        "WpnService"                     # DEFAULT: Automatic | Windows Push Notification Services (WNS)
        # - Diagnostic Services
        "DPS"                            # DEFAULT: Automatic | Diagnostic Policy Service
        "WdiServiceHost"                 # DEFAULT: Manual    | Diagnostic Service Host
        "WdiSystemHost"                  # DEFAULT: Manual    | Diagnostic System Host
        # - Bluetooth services
        "BTAGService"                    # DEFAULT: Manual    | Bluetooth Audio Gateway Service
        "BthAvctpSvc"                    # DEFAULT: Manual    | AVCTP Service
        "bthserv"                        # DEFAULT: Manual    | Bluetooth Support Service
        "RtkBtManServ"                   # DEFAULT: Automatic | Realtek Bluetooth Device Manager Service
        # - Xbox services
        "XblAuthManager"                 # DEFAULT: Manual    | Xbox Live Auth Manager
        "XblGameSave"                    # DEFAULT: Manual    | Xbox Live Game Save
        "XboxGipSvc"                     # DEFAULT: Manual    | Xbox Accessory Management Service
        "XboxNetApiSvc"                  # DEFAULT: Manual    | Xbox Live Networking Service
        # - NVIDIA services
        "NVDisplay.ContainerLocalSystem" # DEFAULT: Automatic | NVIDIA Display Container LS (NVIDIA Control Panel)
        "NvContainerLocalSystem"         # DEFAULT: Automatic | NVIDIA LocalSystem Container (GeForce Experience / NVIDIA Telemetry)
        # - Printer services
        #"PrintNotify"                   # DEFAULT: Manual    | WARNING! REMOVING WILL TURN PRINTING LESS MANAGEABLE | Printer Extensions and Notifications
        #"Spooler"                       # DEFAULT: Automatic | WARNING! REMOVING WILL DISABLE PRINTING              | Print Spooler
        # - Wi-Fi services
        #"WlanSvc"                       # DEFAULT: Manual (No Wi-Fi devices) / Automatic (Wi-Fi devices) | WARNING! REMOVING WILL DISABLE WI-FI | WLAN AutoConfig
        # - 3rd Party Services
        "gupdate"                        # DEFAULT: Automatic | Google Update Service
        "gupdatem"                       # DEFAULT: Manual    | Google Update Service²
        "DisplayEnhancementService"      # DEFAULT: Manual    | A service for managing display enhancement such as brightness control.
        "DispBrokerDesktopSvc"           # DEFAULT: Automatic | Manages the connection and configuration of local and remote displays
    )
    Write-Title "Services tweaks"
    Write-Section "Disabling services from Windows"
    If ($Revert) {
        Write-Status -Types "*", "Service" -Status "Reverting the tweaks is set to '$Revert'." -Warning
        Set-ServiceStartup -State 'Manual' -Services $ServicesToDisabled -Filter $EnableServicesOnSSD
    } Else {
        Set-ServiceStartup -State 'Disabled' -Services $ServicesToDisabled -Filter $EnableServicesOnSSD
    }
    Write-Section "Enabling services from Windows"
    If ($IsSystemDriveSSD -or $Revert) {
        Set-ServiceStartup -State 'Automatic' -Services $EnableServicesOnSSD
    }
    Set-ServiceStartup -State 'Manual' -Services $ServicesToManual
}
# SIG # Begin signature block
# MIIKUQYJKoZIhvcNAQcCoIIKQjCCCj4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUmJ5YQUQcdSzKHOikxq4zu9Tr
# hvqgggZWMIIGUjCCBDqgAwIBAgIQIs9ET5TBkYlFoLQHAUEE/jANBgkqhkiG9w0B
# AQsFADCBrjELMAkGA1UEBhMCQ0ExCzAJBgNVBAgMAkJDMREwDwYDVQQHDAhWaWN0
# b3JpYTEeMBwGCSqGSIb3DQEJARYPY2lyY2xvbEBzaGF3LmNhMScwJQYJKoZIhvcN
# AQkBFhhtaWtlQG1vdGhlcmNvbXB1dGVycy5jb20xIjAgBgNVBAoMGUNvbXB1dGVy
# IE9ubHkgUmV0YWlsIEluYy4xEjAQBgNVBAMMCU5ldyBMb2FkczAeFw0yMzAyMDgw
# MjIwMzVaFw0yNDAyMDgwMjQwMzVaMIGuMQswCQYDVQQGEwJDQTELMAkGA1UECAwC
# QkMxETAPBgNVBAcMCFZpY3RvcmlhMR4wHAYJKoZIhvcNAQkBFg9jaXJjbG9sQHNo
# YXcuY2ExJzAlBgkqhkiG9w0BCQEWGG1pa2VAbW90aGVyY29tcHV0ZXJzLmNvbTEi
# MCAGA1UECgwZQ29tcHV0ZXIgT25seSBSZXRhaWwgSW5jLjESMBAGA1UEAwwJTmV3
# IExvYWRzMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAv5qzNh/aVKRC
# eVOxL0BYxOViVa1zVcjL1/IghB+c+q51dcX2qbGTDiBOMWKGP4pEnN2XrEtAXESo
# vdGlM9If/wQs/ohhDh3sf7YuwH2ay15RIW2DjGKzGVhgvrvbIRnM/p26Cks1JZjV
# FxgSin6vYP77lRGAMWMsNGUplxKJpGdH1YTeIEg3foXVMv78bwBjEoCbC7cwi039
# nz2NS2ZH4evDSjTwh66UkDSNN1H5zsmQPcVPfXN1UabaUmfLhXreww4NmmxFFE/H
# t0t2tZk50BKbkY9Twj8khGjJsVTHBu0RhXwXPC/RN1iOZeNOOurzNk8TXBPPM87r
# fpC8AIwbXtEvmCEEGkivm5VwZ3LR6/fFmKXRp2NsFk5Sh4tvRFQXzbmoPVimoK/7
# d6TlCYyn7Z17zQGQWraO3U55zEjurBABvJ2toeDRzUcF4bekgTlLBw0aoqVhh5DY
# wakTFNzyPLJPfrM8o4OybtUXtswQk4PBSRJp2Jjc4ZUy5qxr+YNqfu2Lm8oxmLc3
# hkSJYx9qlWE9hn2Qkc+S7+Ld0BhDhjWAOFim1qjXDw/5jXvixwJ2zbaacvd/mCg9
# NVQMv5QYXv4EGtoTD5CvNUxIOpRhXX2RoKIyWMLQU/+V9Qk8p3WQzjzZRXqqjNtX
# nfKjmTuye5RU9NxmOG+Evh6i9vbU9l0CAwEAAaNqMGgwDgYDVR0PAQH/BAQDAgeA
# MBMGA1UdJQQMMAoGCCsGAQUFBwMDMCIGA1UdEQQbMBmCF3d3dy5tb3RoZXJjb21w
# dXRlcnMuY29tMB0GA1UdDgQWBBQBOiQX6wdanCPoLrJWg1U8QWjqGTANBgkqhkiG
# 9w0BAQsFAAOCAgEAJilnAd6e5NPMVNH5fC6zAwn+ey8x/IM87z30BjoxGVRWexsC
# PtgGOw770LCKK8ONpTILyIAXapZ8HDDtPMja8QR7bds2qIOqgsiL3hylSe7UcryZ
# KBvpiHJIJOE7vIxZdrmuOIHMai0pK9BTQsGbZGrR0sYeUjLDOwodIuc8ccnuPoNd
# HouHpHl1v3fBXn2/q0Hro+bWp4YHby4s7zPl+OGFLWl1kDkLtVfw81m9g9fqrhN2
# tofGL1vSM2Zg5GhLjFHkGedkGFFes8Oldf0GbfgHEFk7dVgjCxyRo2hZuMwn6DFc
# Oy2G2QjULRv6avqiEyYzdHpBGMvfuP9UWm2rBHoajk4rsb4Sajg1xpppKk9ZJPNR
# 2SenGSEK1qhT4R2F9M68x50pdL2A1ufqU3UOlH8OfwYi1+8sUBS/0wCPgaqLut7P
# k1b6D/brIIqxmlOfK+fmb0rKWlQgakQN5+CmR89bX5owalu5kgH7VcFS9ygjBAlA
# 87U650B0IwnZzeooAEP4TjUnJbVXAykIsjRGl4JzF26tJTQSwF3SLqdLyfi0ZfrO
# FcZoYEkfJLdoxHQ6DLCY9DAz09wNp7W9rERyBO7psdlC9x7VDo/LJFgh3uTtykuy
# ximtLfYl64Yws9XVpRgTSbtFZ6xFPgP5MkDP82UKpZ5UghoRHvDToLmxJCAxggNl
# MIIDYQIBATCBwzCBrjELMAkGA1UEBhMCQ0ExCzAJBgNVBAgMAkJDMREwDwYDVQQH
# DAhWaWN0b3JpYTEeMBwGCSqGSIb3DQEJARYPY2lyY2xvbEBzaGF3LmNhMScwJQYJ
# KoZIhvcNAQkBFhhtaWtlQG1vdGhlcmNvbXB1dGVycy5jb20xIjAgBgNVBAoMGUNv
# bXB1dGVyIE9ubHkgUmV0YWlsIEluYy4xEjAQBgNVBAMMCU5ldyBMb2FkcwIQIs9E
# T5TBkYlFoLQHAUEE/jAJBgUrDgMCGgUAoHgwGAYKKwYBBAGCNwIBDDEKMAigAoAA
# oQKAADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgorBgEEAYI3AgELMQ4w
# DAYKKwYBBAGCNwIBFTAjBgkqhkiG9w0BCQQxFgQU01Y2661T4jMdNBmkD7M3dz6f
# rLAwDQYJKoZIhvcNAQEBBQAEggIAj6VvnitUvl3wJaaE30zgHTRulQiEkkGnOdEx
# gdFDCE1MVy8jLl0mDZddfrZ8ODUXqsNLHDEhOqGSJgAbdzH5SlNjUWrwLL3QntqY
# hMSDdnqd0KGJngAeYWT72fYNvr2Qm05FYJI1QtaA0fRcnMuu9sWZvO1NDXN0sWg1
# 4ReabtWWmPHxdAsHbhuztc3t8JmB3Db/gAzielYFldiQoy6QbaSENQAnH5BdiMPQ
# lCHq1SOTykdd8cDCZ4jdPZV1Wu+YkorwC+KbntSxIGSnZMEigZu+39AvE3r9P3RI
# 9Tbi4J0kG9V5daJZ14AfEERLvUc39oi2+WseIjsX5G2ss+6TBjQLJKPgesGvCGoM
# rFQPE6/T/mcv6TpdAPhs3j4yLW2cQR1zM8+9sa7ZYZEPTbz4Obtw8rEaljXvbr+d
# 79duBbbbqIzAXR1aDwsKIMIqDaG0wPdQAhgqgZ0OfF59Z5AVMQriklI13bh366yA
# ycCbDRC0tALGWWPL4DV4XqdSxAEsfYqXyzMklQ9aCKbEaTeskCeybwMB/r834vXd
# SAfWgrL4G1TC+CHGX5ixIhvlNJw5BtpH87MWi6DQEKOio7GSnLciN4tJ2U2hU8Gz
# 5zBZ9qiXmrV7XVirRpVRNr3pCFEiSmBAtgpPjXDuqsNCPefoTNYVEWMJAjzSpRKp
# 9TY/jFo=
# SIG # End signature block
