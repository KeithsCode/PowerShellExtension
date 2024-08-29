function Update-Location {
    <#
    .SYNOPSIS
        Modifies the standard function of Set-Location (cd) to push current locations on a stack before directory traversal.

    .DESCRIPTION
        Update-Location replaces the builtin cd alias to more closely emulate Linux with "cd -" functionality by adding to a 'History' stack,
        pushing all locations onto it before traversal, and parsing "cd -" to pop the last location from the stack.

    .NOTES
        New-Alias -Name 'cd' Update-Location
    .LINK
        ld
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string] $Path
    )
    if (!($Path -eq "-")) {
        Push-Location -Path $(Get-Location) -StackName "History"
        Set-Location -Path "$Path"
    } else {
        if ($(Get-Location -StackName "History" -ErrorAction SilentlyContinue)) {
            Pop-Location -StackName "History"
        } else {
            Write-Output -InputObject "No path history available"
        }
    }
}
