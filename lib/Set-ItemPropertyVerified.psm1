Function Set-ItemPropertyVerified {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $Value,
        [Parameter(Mandatory=$true)]
        $Name,
        [Parameter(Mandatory=$true)]
        $Type,
        [Parameter(Mandatory=$true)]
        $Path,
        [Switch]
        $Passthru
    )

    $keyExists = Test-Path -Path $Path

    if (!$keyExists) {
        New-Item -Path $Path -Force | Out-Null
    }

    $currentValue = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue

    if ($currentValue -eq $null -or $currentValue.$Name -ne $Value) {
        Try {
            $warningPreference = Get-Variable -Name WarningPreference -ValueOnly -ErrorAction SilentlyContinue
            Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -ErrorAction Stop -WarningAction $warningPreference -Passthru:$Passthru
            Write-Status -Types "+" -Status "$Name set to $Value in $Path"  
        }
        Catch {
            Write-Error "=> Error: $_.Exception.Message" | Out-File -FilePath $ErrorLog -Append
        }
    }
    else {
        Write-Status -Types "@" -Status "Key already set to desired value. Skipping"
    }
}

## Example Command

<## Set-ItemPropertyVerified -Path "HKCU:\SYSTEM\Love" -Name "Kidney" -Value '3' -Type "DWORD"
    "Supported Commands"
        - Name
        - Value
        - Path
        - Type
        - Passthru
        - Verbose
        #- Debug
        - ErrorAction
        - WarningAction
        #- InformationAction
        #- ErrorVariable
        #- WarningVariable
        #- InformationVariable
        #- outVariable
        #- outBuffer
        #- PipelineVariable
##>

