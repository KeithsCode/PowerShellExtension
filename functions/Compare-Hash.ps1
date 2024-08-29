function Compare-Hash {
  <#
  .SYNOPSIS
      Compares a file hash with a known value

  .DESCRIPTION
      chash generates a file hash and compares it to a supplied hash string using the selected algorithm
  .Notes
      New-Alias -Name 'chash' Compare-Hash
  #>
  [CmdletBinding()]
  Param (
      [Parameter(Position = 0)]
      [string] $File,

      [Parameter(Position = 1)]
      [string] $Hash,

      [Parameter(Position = 2)]
      [string] $Algorithm
  )
  $FileHash = $(Get-FileHash -Algorithm $Algorithm -Path $File).Hash
  if ($FileHash -eq $Hash) {
      Write-Host ("Good Hash") -ForegroundColor Green
      Write-Host (" - File: ") -NoNewline -ForegroundColor Green
      Write-Host ("$FileHash") -ForegroundColor White
      Write-Host (" - Hash: ") -NoNewline -ForegroundColor Green
      Write-Host ("$Hash") -ForegroundColor White
  } else {
      Write-Host ("Bad Hash") -ForegroundColor Red
      Write-Host (" - File: ") -NoNewline -ForegroundColor Red
      Write-Host ("$FileHash") -ForegroundColor Red
      Write-Host (" - Hash: ") -NoNewline -ForegroundColor Red
      Write-Host ("$Hash") -ForegroundColor Red
  }    
}