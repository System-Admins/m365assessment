function Invoke-ReviewEntraAuthMethodPasswordProtectionOnPremAD
{
    <#
    .SYNOPSIS
        If password protection is enabled for on-prem Active Directory.
    .DESCRIPTION
        Return true if enabled, otherwise false.
    .EXAMPLE
        Invoke-ReviewEntraAuthMethodPasswordProtectionOnPremAD;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get the hybrid AD connect status.
        $adConnectStatus = Get-EntraIdHybridAdConnectStatus;

        # URI.
        $uri = 'https://main.iam.ad.ext.azure.com/api/AuthenticationMethods/PasswordPolicy';
        
        # Valid configuration.
        [bool]$validConfiguration = $true;
    }
    PROCESS
    {
        # Invoke Entra ID API.
        $passwordPolicy = Invoke-EntraIdIamApi -Uri $uri -Method Get;

        # If the hybrid AD connect status is connected.
        if ($adConnectStatus.dirSyncEnabled -eq $true)
        {
            # If password protection is not enforced on premises.
            if ($false -eq $passwordPolicy.enableBannedPasswordCheckOnPremises)
            {
                # Set valid configuration to false.
                $validConfiguration = $false;
            }
        }
    }
    END
    {
        # Return state of valid configuration.
        return $validConfiguration;
    }
}