# Compatibility with PS major versions <= 2
if(!$PSScriptRoot) {
    $PSScriptRoot = Split-Path $Script:MyInvocation.MyCommand.Path
}

. C:\dev\github\ps-motd\Get-MOTD.ps1
Get-MOTD

try {
    # Check if git is on PATH, i.e. Git already installed on system
    Get-command -Name "git" -ErrorAction Stop >$null
} catch {
    Write-Warning "Missing git support, install git with 'choco install git.install' and restart cmder."
}

try {
    Import-Module -Name "posh-git" -ErrorAction Stop >$null
    $gitStatus = $true
    $global:GitPromptSettings.EnableFileStatus = $false
} catch {
    Write-Warning "Missing git support, install posh-git with 'Install-Module posh-git' and restart cmder."
    $gitStatus = $false
}

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

# Set up a Cmder prompt, adding the git prompt parts inside git repos
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

# Move to the wanted location
if (Test-Path Env:\CMDER_START) {
    Set-Location -Path $Env:CMDER_START
} elseif ($Env:CMDER_ROOT -and $Env:CMDER_ROOT.StartsWith($pwd)) {
    Set-Location -Path $Env:USERPROFILE
}

# Enhance Path
if (Test-Path Env:\CMDER_ROOT) {
    $env:Path = "$Env:CMDER_ROOT\bin;$env:Path;$Env:CMDER_ROOT"
}