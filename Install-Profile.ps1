################################################################################################
#### Ensure git is installed ###################################################################
################################################################################################
try {
    # Check if git is on PATH, i.e. Git already installed on system
    Get-command -Name "git" -ErrorAction Stop | Out-Null
} catch {
    Write-Warning "Missing git support, install git with 'choco install git.install'"
}

################################################################################################
#### Install modules ###########################################################################
################################################################################################
function installModule {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$Names
    )

    foreach ($name in $Names) {
        if ((Get-InstalledModule $name -ErrorAction Ignore) -eq $null) {
            Write-Warning "Missing $name module, installing..."
            Install-Module $name
        } else {
            Write-Warning "Module $name already installed, skipping..."
        }
    }
}

installModule(@(
    'posh-git',
    'AzureRM',
    'AzureAD',
    'CredentialManager',
    'PsHosts',
    'VSSetup'
))

################################################################################################
#### Clone git repositories ####################################################################
################################################################################################
function cloneModuleRepository {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ModuleName,
        [Parameter(Mandatory = $true)]
        [string]$RepoUrl
    )

    $LocalPath = "$PSScriptRoot\Modules\$ModuleName"
    if ((Test-Path $LocalPath -PathType Container) -eq $false) {
        Write-Warning "Missing '$ModuleName' repository, cloning from GitHub"
        git clone $RepoUrl $LocalPath
    } else {
        Write-Warning "'$ModuleName' repository ($RepoUrl) already cloned, skipping..."
    }
}

cloneModuleRepository -ModuleName "ps-motd" -RepoUrl "https://github.com/mmillar-bolis/ps-motd.git"
cloneModuleRepository -ModuleName "PsPowerline" -RepoUrl "https://github.com/jrotello/PSPowerline.git"

Write-Host 'Profile installation complete!' -ForegroundColor Green