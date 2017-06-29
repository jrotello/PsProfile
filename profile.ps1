################################################################################################
#### Set up prompt, adding the git prompt parts from posh-get ##################################
################################################################################################
Import-Module -Name "posh-git"
$gitStatus = $true
$global:GitPromptSettings.EnableFileStatus = $false

function checkGit($Path) {
    if (Test-Path -Path (Join-Path $Path '.git/') ) {
        Write-VcsStatus
        return
    }
    $SplitPath = split-path $path
    if ($SplitPath) {
        checkGit($SplitPath)
    }
}

function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE
    $Host.UI.RawUI.ForegroundColor = "White"
    Write-Host $pwd.ProviderPath -NoNewLine -ForegroundColor Green
    if($gitStatus){
        checkGit($pwd.ProviderPath)
    }
    $global:LASTEXITCODE = $realLASTEXITCODE
    Write-Host "`n$([char]0x3BB)" -NoNewLine -ForegroundColor "DarkGray"
    return " "
}

################################################################################################
#### Login to Azure if necessary ###############################################################
################################################################################################
try {
    $cred_path = '~\.pscredentials\azure.credential'
    if (Test-Path $cred_path -PathType Leaf) {
        Login-AzureRmAccount -Credential (Import-Clixml $cred_path)
    }
} finally {
    Remove-Variable cred_path
}

################################################################################################
#### Miscellanous ##############################################################################
################################################################################################
Set-Location ~

if ((Get-Host).UI.RawUI -ne $null) {
    (Get-Host).UI.RawUI.WindowTitle = "[$env:COMPUTERNAME] $($(Get-Host).UI.RawUI.WindowTitle)"
}

# . "$PSScriptRoot\ps-motd\Get-MOTD.ps1"
# Get-MOTD
