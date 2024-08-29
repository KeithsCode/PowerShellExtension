# PowerShellExtension
A set of functions to extend your PowerShell profile

###Included functions
Assert-File - emulation for Linux touch
Compare-Base64String - compares two Base64 encoded strings
Compare-HashString - wrapper for Get-FileHash that takes two hashes and a cipher (SHA1, 256, 384, 512; MD5)
Export-EnvVariable - emulation for Linux export
Find-Command - emulation for Linux which
Get-BranchDetails - prompt addition for parsing Git repository stats (see profile/git_integrated)
Get-PublicIp - Returns public ip from ipify.org
Read-LocationHistory - returns location traversal history stack (see Update-Location)
Set-AltUser - emulation for Linux su
Update-Location - cd replacement. adds directory traversal history to a stack to support emulation of Linux "cd -"

###Profile Examples
####basic:
supports conventional nested prompt.
sets prompt to display PowerShell version.
sets prompt to show leaf pathing
administrator prompts are colored red and prefix [AMDIN]
debug prompts are prefied [DBG]

####git_integrated:
used with function Get-BranchDetails
When in a git repo this adds a prompt tag to show branch and repo stats (untracked files, added, modified, deleted)
Tags are colored for init, dev, feature, and main branches

####full:
Profile adding all functions, aliases, git and env integrtations