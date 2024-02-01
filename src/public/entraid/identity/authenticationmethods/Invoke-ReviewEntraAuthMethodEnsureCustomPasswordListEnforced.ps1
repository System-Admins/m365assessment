function Invoke-ReviewEntraAuthMethodEnsureCustomPasswordListEnforced
{
    <#
    .SYNOPSIS
        If custom banned passwords lists are used.
    .DESCRIPTION
        Return true if enabled, otherwise false.
    .EXAMPLE
        Invoke-ReviewEntraAuthMethodEnsureCustomPasswordListEnforced;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # URI.
        $uri = 'https://main.iam.ad.ext.azure.com/api/AuthenticationMethods/PasswordPolicy';
        
        # Valid configuration.
        [bool]$validConfiguration = $true;
    }
    PROCESS
    {
        # Invoke Entra ID API.
        $passwordPolicy = Invoke-EntraIdIamApi -Uri $uri -Method Get;

        # if custom passwords is not enforced.
        if ($false -eq $passwordPolicy.enforceCustomBannedPasswords)
        {
            # Set valid configuration to false.
            $validConfiguration = $false;
        }

        # If the custom banned passwords.
        if ($null -eq $passwordPolicy.customBannedPasswords)
        {
            # Set valid configuration to false.
            $validConfiguration = $false;
        }
    }
    END
    {
        # Return state of valid configuration.
        return $validConfiguration;
    }
}