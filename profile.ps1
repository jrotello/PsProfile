################################################################################################
#### Import modules ############################################################################
################################################################################################
Import-Module "posh-git"
Import-Module "posh-docker"
Import-Module "CredentialManager"
Import-Module "PsPowerline"
Import-Module "VSSetup"
Import-Module $PSScriptRoot\PSProfile.psm1

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

if ((Get-VSSetupInstance) -ne $null) {
    $Env:MSBuildPath = "$((Get-VSSetupInstance).InstallationPath)\MSBuild\15.0\bin"
    $Env:Path = "$Env:MSBuildPath;$Env:Path"
}


#$global:GitPromptSettings.EnableFileStatus = $false
