################################################################################################
#### Import modules ############################################################################
################################################################################################
Import-Module "posh-git"
Import-Module "posh-docker"
Import-Module "CredentialManager"
Import-Module "VSSetup"
Import-Module $PSScriptRoot\PSProfile.psm1

################################################################################################
#### Login to Azure if necessary ###############################################################
################################################################################################
if (Test-Path env:\PSPROFILE_AZURE) {
    $cred = Get-StoredCredential -Target "PsProfile - Azure Resource Manager"
    if ($null -ne $cred) {
        Write-Host -ForegroundColor Green "############################################################################"
        Write-Host -ForegroundColor Green "#### Connecting to Azure Resource Manager ##################################"
        Write-Host -ForegroundColor Green "############################################################################"
        Login-AzureRmAccount -Credential $cred
    }
}

################################################################################################
#### Miscellanous ##############################################################################
################################################################################################
Set-Location ~

if (Test-Path Alias:\curl) {
    Get-ChildItem Alias:\curl | Remove-Item
}

if ($null -ne (Get-VSSetupInstance)) {
    $Env:MSBuildPath = "$((Get-VSSetupInstance).InstallationPath)\MSBuild\15.0\bin"
    $Env:Path = "$Env:MSBuildPath;$Env:Path"
}

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

Set-PSReadlineOption -HistoryNoDuplicates 
Set-PSReadlineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineOption -MaximumHistoryCount 4000 
Set-PSReadlineOption -BellStyle Visual

Set-PSReadlineKeyHandler -Chord 'Ctrl+Shift+UpArrow' -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Chord 'Ctrl+Shift+DownArrow' -Function HistorySearchForward

#$global:GitPromptSettings.EnableFileStatus = $false
