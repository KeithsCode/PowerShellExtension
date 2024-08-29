function Export-EnvVariable {
  <#
  .SYNOPSIS
      create an environmental variable
  
  .DESCRIPTION
      create an environmental variable on the local machine
  .Notes
      New-Alias -Name 'export' Export-EnvVariable
  #>
  [CmdletBinding()]
  Param (
      [Parameter(Position = 0)]
      [string] $Name,

      [Parameter(Position = 1)]
      [string] $Value,

      [switch] $f
  )
  if (!($f.IsPresent)) {
      set-item -Force -Path "env:$Name" -Value $Value;
  } else {
      [System.Environment]::SetEnvironmentVariable("$Name", "$Value", 'User')  
  }
}