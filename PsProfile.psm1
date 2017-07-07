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
Export-ModuleMember -Function *