function Find-Command {
  <#
  .SYNOPSIS
      adds emulation for Linux which

  .DESCRIPTION
      displays full path of an executable
  .Notes
      New-Alias -Name 'which' Find-Command
   #>
  [CmdletBinding()]
  Param (
      [Parameter(Position = 0)]
      [string] $FileName,

      [switch] $a
  )
  if ($a.IsPresent) {
      Get-Command $FileName
  } else {
      Get-Command $FileName | Select-Object -ExpandProperty Definition
  }
}