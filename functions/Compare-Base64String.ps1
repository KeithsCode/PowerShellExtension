function Compare-Base64String {
  <#
  .SYNOPSIS
      Compares a two Base64 hashes

  .DESCRIPTION
      cbstring compares two base64 encoded strings and returns rhe results
  .Notes
      New-Alias -name 'cbstring' Compare-Base64String
  #>
  [CmdletBinding()]
  Param (
      [Parameter(Position = 0)]
      [string] $First,

      [Parameter(Position = 1)]
      [string] $Second
  )
  if (([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("$First"))) -eq `
      ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("$Second")))) `
      {
      Write-Host ("Good Hash") -ForegroundColor Green
      Write-Host ("$First") -ForegroundColor Green
      Write-Host ("$Second") -ForegroundColor Green
  } else {
      Write-Host ("Bad Hash") -ForegroundColor Red
      Write-Host ("$First") -ForegroundColor Red
      Write-Host ("$Second") -ForegroundColor Red
  } 
}