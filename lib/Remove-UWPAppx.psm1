Import-Module -DisableNameChecking $PSScriptRoot..\"assets.psm1"

Function Remove-UWPAppx() {
    [CmdletBinding()]
    param (
        [Array] $AppxPackages
    )
    $TweakType = "UWP"
    $Global:PackagesRemoved = [System.Collections.ArrayList]::new()
    ForEach ($AppxPackage in $AppxPackages) {
        $appxPackageToRemove = Get-AppxPackage -AllUsers -Name $AppxPackage -ErrorAction SilentlyContinue
        if ($appxPackageToRemove) {
            $appxPackageToRemove | ForEach-Object {
                Write-Status -Types "-", $TweakType -Status "Trying to remove $AppxPackage from ALL users..."
                Remove-AppxPackage $_.PackageFullName -EA SilentlyContinue -WA SilentlyContinue >$NULL | Out-Null #4>&1 | Out-Null
                If ($?){ $Global:Removed++ ; $PackagesRemoved += $appxPackageToRemove.PackageFullName  } elseif (!($?)) { $Global:Failed++ }
            }
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $AppxPackage | Remove-AppxProvisionedPackage -Online -AllUsers | Out-Null
            If ($?){ $Global:Removed++ ; $PackagesRemoved += "Provisioned Appx $($appxPackageToRemove.PackageFullName)" } elseif (!($?)) { $Global:Failed++ }
        } else {
            $Global:NotFound++
        }
    }
}