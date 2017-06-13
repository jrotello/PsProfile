try {
    # Check if git is on PATH, i.e. Git already installed on system
    Get-command -Name "git" -ErrorAction Stop | Out-Null

    # if (-not (Test-Path $PSScriptRoot\ps-motd\Get-MOTD.ps1)) {
    #     Write-Warning "Missing 'ps-motd', cloning from GitHub"
    #     git clone https://github.com/mmillar-bolis/ps-motd.git $PSScriptRoot\ps-motd\
    # }
} catch {
    Write-Warning "Missing git support, install git with 'choco install git.install'"
}

try {
    Import-Module -Name "posh-git" -ErrorAction Stop | Out-Null
    $gitStatus = $true
    $global:GitPromptSettings.EnableFileStatus = $false
} catch {
    Write-Warning "Missing git support, install posh-git with 'Install-Module posh-git'"
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

if ((Get-Host).UI.RawUI -ne $null) {
    (Get-Host).UI.RawUI.WindowTitle = "[$env:COMPUTERNAME] $($(Get-Host).UI.RawUI.WindowTitle)"
}

# . "$PSScriptRoot\ps-motd\Get-MOTD.ps1"
# Get-MOTD

Set-Location ~