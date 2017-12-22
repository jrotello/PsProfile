function Update-InstalledModules {
    [CmdletBinding()]
    param()

    Get-InstalledModule |
        Where-Object { (-not $_.Name.StartsWith('AzureRM.')) -and (-not $_.Name.StartsWith('Azure.')) } |
        Update-Module
}

# Taken from: https://mnaoumov.wordpress.com/2014/06/14/unicode-literals-in-powershell/
function Get-UnicodeCharacter {
    param(
        [Parameter(Mandatory = $true)]
        [int]$Code
    )

    if ((0 -le $Code) -and ($Code -le 0xFFFF))
    {
        return [char] $Code
    }

    if ((0x10000 -le $Code) -and ($Code -le 0x10FFFF))
    {
        return [char]::ConvertFromUtf32($Code)
    }

    throw "Invalid character code $Code"
}

function Restart-GpgAgent {
    [CmdletBinding()]
    param()

    $gpgConnectAgent = Get-Command gpg-connect-agent.exe
    if (-not $gpgConnectAgent) {
        Write-Error "Unable to find 'gpg-connect-agent.exe"
    }   
    
    Write-Verbose "Using gpg-connect-agent.exe at $($gpgConnectAgent.Source)"
    
    Write-Verbose "Stopping existing agent"
    gpg-connect-agent killagent /bye
    Write-Verbose "Starting agent"    
    gpg-connect-agent /bye
}

################################################################################################
#### Aliases ###################################################################################
################################################################################################
Set-Alias -Name U -Value Get-UnicodeCharacter

################################################################################################
#### Export Members ############################################################################
################################################################################################
Export-ModuleMember -Function * -Alias *