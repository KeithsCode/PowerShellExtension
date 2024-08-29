function Assert-File {
  <#
  .SYNOPSIS
      adds emulation for Linux touch

  .DESCRIPTION
      Assert-File will add a new file in the current directory if that file does not exist.
      if the named file exists then its LastWriteTime attribute will be updated to the current timestamp.

  .Notes
      New-Alias -Name 'touch' Assert-File
  #>
  [CmdletBinding()]
  Param (
      [Parameter(Position = 0)]
      [string] $FileName
  )
  try {
      New-Item -ItemType File -Name $FileName -ErrorAction Stop
  } catch {
      $(Get-Item $FileName).LastWriteTime = (Get-Date)
  }
}