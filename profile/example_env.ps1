# environmental variables to set
Write-Host ('Loading environmental variables. . .') -ForegroundColor Green
$env:secret      = ""
$env:specialPath = ""

# modules to import on load

$script:modules = @{}