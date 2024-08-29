function Set-AltUser {
  <#
  .SYNOPSIS
      emulates Linux su for privilege elevation
  
  .DESCRIPTION
      Set-User launches a Windows Terminal session with a credential prompt
  
  .Notes
      New-Alias -Name 'su' Set-AltUser
  #>
  Start-Process wt.exe -Verb runas
}