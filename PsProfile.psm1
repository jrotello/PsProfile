function Connect-AzureRm {
    [CmdletBinding()]
    [System.Diagnostics.CodeAnalysis.SuppressMessage("PSAvoidUsingPlainTextForPassword", "CredentialFilePath")]
    param(
        [Parameter(Mandatory = $true)]
        [string]$CredentialFilePath
    )

    if (Test-Path $CredentialFilePath -PathType Leaf) {
        Login-AzureRmAccount -Credential (Import-Clixml $CredentialFilePath)
    } else {
        Write-Verbose "Credential file ($CredentialFilePath) not found. Continuing without signing into Azure."
    }
}

function Update-InstalledModules {
    [CmdletBinding()]
    param()

    Get-InstalledModule |
        Where-Object { (-not $_.Name.StartsWith('AzureRM.')) -and (-not $_.Name.StartsWith('Azure.')) } |
        Update-Module
}

################################################################################################
#### Export Members ############################################################################
################################################################################################
$funcs = @(
    'Connect-AzureRm',
    'Update-InstalledModules'
)

Export-ModuleMember -Function $funcs