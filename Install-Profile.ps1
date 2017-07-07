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
        }
    }
}

installModule('posh-git', 'AzureRM', 'AzureAD', 'CredentialManager', 'PsHosts')

################################################################################################
#### Clone git repositories ####################################################################
################################################################################################
if ((Test-Path $PSScriptRoot\ps-motd\ -PathType Container) -eq $false) { 
    Write-Warning "Missing 'ps-motd' repository, cloning from GitHub" 
    git clone https://github.com/mmillar-bolis/ps-motd.git $PSScriptRoot\ps-motd\ 
} 

Write-Host 'Profile installation complete!' -ForegroundColor Green