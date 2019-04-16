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
        if ($null -eq (Get-InstalledModule $name -ErrorAction Ignore)) {
            Write-Warning "Missing $name module, installing..."
            Install-Module $name
        } else {
            Write-Warning "Module $name already installed, skipping..."
        }
    }
}

installModule(@(
    'posh-git',
    'posh-docker',
    'Az',
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

Write-Host 'Profile installation complete!' -ForegroundColor Green