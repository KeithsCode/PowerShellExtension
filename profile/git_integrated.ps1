function prompt {
  # determine identity
  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = [Security.Principal.WindowsPrincipal] $identity
  $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
  
  # determine PowerShell version
  $PsVersion = $PSVersionTable.PSVersion.ToString()[0]

  # print git details if available
  $branchDetails = $(Get-BranchDetails)

  # define prompt elements: identity flag, PS version, path leaf, nesting suffix
  $prefix = $(if (Test-Path variable:/PSDebugContext) { '[DBG]: ' }
              elseif ($principal.IsInRole($adminRole)) { "[ADMIN]: " }
              else { '' })
  $head = "PS:$PsVersion# "
  $body =  Split-Path -leaf -path $(Get-Location)
  $suffix = $(if ($NestedPromptLevel -ge 1) { '>>' }) + '> '
  
  # construct prompt
  $prompt = $prefix + $head + $body + $suffix
  if (!($principal.IsInRole($adminRole))) {
      if ($branchDetails) {Write-Host ($branchDetails)}
      Write-Host ($prompt) -NoNewline -ForegroundColor Yellow
      return " "
  } else {
      if ($branchDetails) {Write-Host ($branchDetails)}
      Write-Host ($prompt) -NoNewline -ForegroundColor White -BackgroundColor Red
      return " "
  } 
}