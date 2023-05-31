Function Optimize-Services{
    $IsSystemDriveSSD = $(Get-OSDriveType) -eq "SSD"
    $EnableServicesOnSSD = @("SysMain", "WSearch",  "fhsvc")
    # Services which will be totally disabled
    $ServicesToDisabled = @(
        "DiagTrack"                                 # DEFAULT: Automatic | Connected User Experiences and Telemetry
        "diagnosticshub.standardcollector.service"  # DEFAULT: Manual    | Microsoft (R) Diagnostics Hub Standard Collector Service
        "dmwappushservice"                          # DEFAULT: Manual    | Device Management Wireless Application Protocol (WAP)
        #"BthAvctpSvc"                               # DEFAULT: Manual    | AVCTP Service - This is Audio Video Control Transport Protocol service
        #"Fax"                                       # DEFAULT: Manual    | Fax Service
        #"fhsvc"                                     # DEFAULT: Manual    | File History Service
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
        Write-Status -Types "*", "Services" -Status "Reverting the tweaks is set to '$Revert'." -Warning
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
# MIIFeQYJKoZIhvcNAQcCoIIFajCCBWYCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnGEsTaAM/kfZCVHoR+KBETp0
# 7OegggMQMIIDDDCCAfSgAwIBAgIQOtpMekE2BIRJ/swv2v8NGDANBgkqhkiG9w0B
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
# CQQxFgQUbyI6AzuCmN4YXYX9qp1oi9U0TOEwDQYJKoZIhvcNAQEBBQAEggEAFkhG
# ThVR0XWoRFMytxGQvtK7MSlU3kzBZz5qShXi+vVrT61tw/eMcy/0XwKLWRA89LOj
# mCO9uypxaleTq2AnVb5/4lRFJVh+7nffO0ovqjGzXY7H/DXLyWmFMaMyzhPWT78Q
# 2RNm3UeikOCN9FtgmiysM4WpTu/sjPzztWKeb8Icgwsmqf66Fus4GnYVF82DnCtq
# yIMuH5zV9rwx86aG8PdrmF5O/JB7lRNC1Hh93JJBLMT1zuJ3oBo4C2euF+tTA2ez
# tQpgj5OKSG5gL+5UMbLbJKeqUtS5T2Qxm8q+2xdDsS7CeJweMg/yN6uvoeQJT0Ip
# SvZ9nq3v6OqxQ53Lsg==
# SIG # End signature block
