# PowerShellExtension
A set of functions to extend your PowerShell profile<br/>

## Included functions<br/>
Assert-File - emulation for Linux touch<br/>
Compare-Base64String - compares two Base64 encoded strings<br/>
Compare-HashString - wrapper for Get-FileHash that takes two hashes and a cipher (SHA1, 256, 384, 512; MD5)<br/>
Export-EnvVariable - emulation for Linux export<br/>
Find-Command - emulation for Linux which<br/>
Get-BranchDetails - prompt addition for parsing Git repository stats (see profile/git_integrated)<br/>
Get-PublicIp - Returns public ip from ipify.org<br/>
Read-LocationHistory - returns location traversal history stack (see Update-Location)<br/>
Set-AltUser - emulation for Linux su<br/>
Update-Location - cd replacement. adds directory traversal history to a stack to support emulation of Linux "cd -"<br/>

### Profile Examples<br/>
#### basic:<br/>
supports conventional nested prompt.<br/>
sets prompt to display PowerShell version.<br/>
sets prompt to show leaf pathing<br/>
administrator prompts are colored red and prefix [AMDIN]<br/>
debug prompts are prefied [DBG]<br/>

#### git_integrated:<br/>
used with function Get-BranchDetails<br/>
When in a git repo this adds a prompt tag to show branch and repo stats (untracked files, added, modified, deleted)<br/>
Tags are colored for init, dev, feature, and main branches<br/>

#### full:<br/>
Profile adding all functions, aliases, git and env integrtations<br/>