################################################################################################
#### Import modules ############################################################################
################################################################################################
Import-Module "posh-git"
Import-Module "CredentialManager"
Import-Module "PsPowerline"
Import-Module $PSScriptRoot\PSProfile.psm1

################################################################################################
#### Set up prompt, adding the git prompt parts from posh-git ##################################
################################################################################################

# $global:GitPromptSettings.EnableFileStatus = $false
# $gitStatus = $true

# function checkGit($Path) {
#     if (Test-Path -Path (Join-Path $Path '.git/') ) {
#         Write-VcsStatus
#         return
#     }
#     $SplitPath = split-path $path
#     if ($SplitPath) {
#         checkGit($SplitPath)
#     }
# }

# function global:prompt {
#     $realLASTEXITCODE = $LASTEXITCODE
#     $Host.UI.RawUI.ForegroundColor = "White"
#     Write-Host $pwd.ProviderPath -NoNewLine -ForegroundColor Green
#     if($gitStatus){
#         checkGit($pwd.ProviderPath)
#     }
#     $global:LASTEXITCODE = $realLASTEXITCODE
#     Write-Host "`n$([char]0x3BB)" -NoNewLine -ForegroundColor "DarkGray"
#     return " "
# }

################################################################################################
#### Login to Azure if necessary ###############################################################
################################################################################################
if (Test-Path env:\PSPROFILE_AZURE) {
    $cred = Get-StoredCredential -Target "PsProfile - Azure Resource Manager"
    if ($cred -ne $null) {
        Write-Host -ForegroundColor Green "############################################################################"
        Write-Host -ForegroundColor Green "#### Connecting to Azure Resource Manager ##################################"
        Write-Host -ForegroundColor Green "############################################################################"
        Login-AzureRmAccount -Credential $cred
    }
}

################################################################################################
#### Display any global git aliases ############################################################
################################################################################################
Write-Host -ForegroundColor Green "############################################################################"
Write-Host -ForegroundColor Green "#### Configured Git Aliases ################################################"
Write-Host -ForegroundColor Green "############################################################################"
git config --get-regexp alias

################################################################################################
#### Miscellanous ##############################################################################
################################################################################################
Set-Location ~

if ((Get-Host).UI.RawUI -ne $null) {
    (Get-Host).UI.RawUI.WindowTitle = "[$env:COMPUTERNAME] $($(Get-Host).UI.RawUI.WindowTitle)"
}

# . "$PSScriptRoot\ps-motd\Get-MOTD.ps1"
# Get-MOTD
