# parse environmental variables
$MyEnvPath = '' # path to env.ps1 file

if (Test-Path -Path $MyEnvPath) {
    $envPath = $MyEnvPath
    . $envPath
} else {
    $envPath = $(Join-Path -Path $(Get-ChildItem -Path $PROFILE).DirectoryName 'env.ps1' -ErrorAction SilentlyContinue)
    if (Test-Path -Path $envPath) {
        . $envPath
    }    
}

# import modules from environental variable $script:modules
if ($script:modules) {
    Write-Host ('Loading Powershell Modules. . .') -ForegroundColor Green
    foreach ($module in $script:modules) {
        if (!(Get-Module -Name $module)) {
            Write-Host (" - trying to import $module. . .") -ForegroundColor Green
            Try {
                Import-Module -Name $module -ErrorAction Stop
                Write-Host (" - $module imported successfully") -ForegroundColor Green
            } catch {
                Write-Host " - $module not found, attempting to install" -ForegroundColor DarkYellow
                try {
                    Install-Module -Name $module -Scope CurrentUser -ErrorAction Stop
                    Write-Host (" - install successful, trying to import $module. . .") -ForegroundColor Green
                    Import-Module -Name $module -ErrorAction Stop
                    Write-Host (" - $module imported successfully") -ForegroundColor Green
                } catch {
                    Write-Host $module could not be automatically installed -ForegroundColor DarkRed
                }
            }
        }
    }
    Clear-Variable -Name module
    Clear-Variable -Name modules
}

# remove builtin cd alias so we can replace it
Remove-Item Alias:cd -Force -ErrorAction SilentlyContinue

#* command functions

# build stack history of directory locations and add Linux 'cd -' emulation
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
      Read-LocationHistory
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

# compare two base64 hashs
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

# compare file hash with supplied hash
function Compare-HashString {
  <#
  .SYNOPSIS
      Compares a file hash with a known value

  .DESCRIPTION
      Compate-HashString generates a file hash and compares it to a supplied hash string using the selected algorithm
  .Notes
      New-Alias -Name 'chash' Compare-HashString
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

# simulate export functionality
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

# gets public IP from ipify.org
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

# display stack of previous directory locations
function Read-LocationHistory {
  <#
  .SYNOPSIS
      List directory traversal history stack
  
  .DESCRIPTION
      ld adds a stack viewer to list the contents of the 'History' stack generated by cd which holds all previous directory locations for reverse traversal

  .NOTES
      New-Alias -Name 'ld' Read-LocationHistory
  .LINK
      Update-Location
  #>
  if ($(Get-Location -StackName "History" -ErrorAction SilentlyContinue)) {
      Get-Location -StackName "History"
  } else {
      Write-Output -InputObject "No path history available"
  }
}

# simulate su functionality
function Set-AltUser {
  <#
  .SYNOPSIS
      emulates Linux su for privilege elevation
  
  .DESCRIPTION
      Set-AltUser launches a Windows Terminal session with a credential prompt
  
  .Notes
      New-Alias -Name 'su' Set-AltUser
  #>
  Start-Process wt.exe -Verb runas
}

# emulate Linux touch command for creating files in local directory
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

# simulate which functionality
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

# New-Azure wraps Connect-AzAccount with parameters
function New-Azure {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)]
        [hashtable] $Subscription,

        [Parameter(Mandatory=$false)]
        [string] $SubscriptionID,

        [parameter(Mandatory=$false)]
        [string] $TenantID
        )
    if ($subscription) {
        Connect-AzAccount -Subscription $Subscription.SubscriptionId -Tenant $Subscription.TenantID
        return
    }
    if ($SubscriptionID -and $TenantID) {
        Connect-AzAccount -Subscription $SubscriptionId -Tenant $TenantID
        return
    }
    Write-Output -InputObject "Parameters incorrect"
}

#* environment functions

# alias functions
New-Alias -Name 'cd' Update-Location
New-Alias -Name 'cbstring' Compare-Base64String
New-Alias -Name 'chash' Compare-HashString
New-Alias -Name 'df' Get-Volume
New-Alias -Name 'export' Export-EnvVariable
New-Alias -Name 'gpip' Get-PublicIp
New-Alias -Name 'ld' Read-LocationHistory
New-Alias -Name 'su' Set-AltUser
New-Alias -Name 'touch' Set-File
New-Alias -Name 'which' Find-Command


# collect git details
function Get-BranchDetails {
    # store current foreground and background colors for later
    $defaultForeground = $(get-host).ui.rawui.ForegroundColor
    $defaultBackground = $(get-host).ui.rawui.BackgroundColor
    try {
        $branch = git rev-parse --abbrev-ref HEAD

        # return if not in a git repo
        if ($null -eq $branch) {
            return $false
        }

        $symbolicref = git symbolic-ref HEAD
        if($null -ne $symbolicref) {
            # determine differences between local and last commit
            $differences = $(git diff-index --name-status HEAD)
            if (!($differences)) {$differences = 'none'}

            # determine if there are untracked files
            $untracked = $(git ls-files --others --exclude-standard)

            # count all files
            if ($differences -or $untracked) {
                $git_untracked_count = $untracked.count
                
                $git_update_count = [regex]::matches("$differences", "M`t").count
                $git_create_count = [regex]::matches("$differences", "A`t").count
                $git_delete_count = [regex]::matches("$differences", "D`t").count
        
                $gitStats += " u" + $git_untracked_count + " +" + $git_create_count + " ~" + $git_update_count + " -" + $git_delete_count
            } else {
                # register counts as zero if there is nothing to count
                $gitStats += " u" + 0 + " +" + 0 + " ~" + 0 + " -" + 0
            }
        }

        # colorize git information by branch name or state
        switch ($branch) {
            'HEAD' {
                $branch = git rev-parse --short HEAD
                if (!($null -eq $branch)) {
                    # we're probably in detached HEAD state, so print the SHA
                    Write-Host "[$branch]$gitStats" -NoNewline -ForegroundColor White -BackgroundColor DarkRed;
                        Write-Host ' ' -ForegroundColor $defaultForeground -BackgroundColor $defaultBackground
                } else {
                    # we're probably in a repository with no commits
                    Write-Host "[init]$gitStats" -NoNewline -ForegroundColor Black -BackgroundColor Gray;
                        Write-Host ' ' -ForegroundColor $defaultForeground -BackgroundColor $defaultBackground
                }
            }
            'main' {
                # we're on an un named branch, so print the branch name
                Write-Host "[$branch]$gitStats" -NoNewline -ForegroundColor White -BackgroundColor DarkYellow;
                Write-Host ' ' -ForegroundColor $defaultForeground -BackgroundColor $defaultBackground
            }
            'dev' {
                # we're on a feature branch, so print the branch name
                Write-Host "[$branch]$gitStats" -NoNewline -ForegroundColor White -BackgroundColor Blue;
                Write-Host ' ' -ForegroundColor $defaultForeground -BackgroundColor $defaultBackground
            }
            'feature' {
                # we're on a feature branch, so print the branch name
                Write-Host "[$branch]$gitStats" -NoNewline -ForegroundColor White -BackgroundColor Magenta;
                Write-Host ' ' -ForegroundColor $defaultForeground -BackgroundColor $defaultBackground
            }
            default {
                # we're on an un named branch, so print the branch name
                Write-Host "[$branch]$gitStats" -NoNewline -ForegroundColor Black -BackgroundColor White;
                Write-Host ' ' -ForegroundColor $defaultForeground -BackgroundColor $defaultBackground
            }
        }
    } catch {
        # git is not installed or an error occured in the counting logic
        return
    }
}

# dynamically prompt construction
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