function Get-PublicIp {
  <#
  .SYNOPSIS
      displays current public IP address
  
  .DESCRIPTION
      collect and display public IPv4 address using api.ipify.org
  .Notes
      New-Alias -Name 'gpip' Get-PublicIp
  #>
  $(Invoke-Webrequest -Uri https://api.ipify.org).Content
}