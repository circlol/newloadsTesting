
Function Remove-InstalledProgram {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [string]$UninstallString,
        [Parameter(ValueFromPipeline=$true)]
        [string]$Name
    )
    process {
        try {
            Write-Host "Uninstalling $Name..."
            if ($UninstallString -match 'msiexec.exe') {
                # Uninstall using MSIExec
                $arguments = $UninstallString.Split(" ", 2)[1]
                Start-Process -FilePath 'msiexec.exe' -ArgumentList "/x $arguments" -Wait -NoNewWindow
            } else {
                # Uninstall using regular command
                Start-Process -FilePath $UninstallString -ArgumentList "/quiet", "/norestart" -Wait -NoNewWindow
            }
            
            Write-Host "$Name uninstalled successfully."
        } catch {
            Write-Host "An error occurred during program uninstallation: $_"
        }
    }
}
