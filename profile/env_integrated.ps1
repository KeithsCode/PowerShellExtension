# parse environmental variables
$envPath = $(Join-Path -Path $(Get-ChildItem -Path $PROFILE).DirectoryName 'env.ps1' -ErrorAction SilentlyContinue)

if (Test-Path -Path $envPath) {
    . $envPath
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