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