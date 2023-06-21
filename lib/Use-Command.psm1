function Use-Command() {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Command,
        [switch]$Suppress,
        [switch]$Verbose
    )
    try {
        If ($Suppress -eq $True){
            Invoke-Expression $Command -Verbose:$verbose -ErrorAction SilentlyContinue | Out-Null
        } else {
            Invoke-Expression $Command -Verbose:$verbose
        }
    }catch {
    $errorMessage = $_.Exception.Message
    $lineNumber = $_.InvocationInfo.ScriptLineNumber
    $command = $_.InvocationInfo.Line
    $errorType = $_.CategoryInfo.Reason
    $ErrorLog = ".\ErrorLog.txt"

$errorString = @"
-
Time of error: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Command run was: $command
Reason for error was: $errorType
Offending line number: $lineNumber
Error Message: $errorMessage
-

"@
    Add-Content $ErrorLog $errorString
    Write-Output $_
    }
}