function Invoke-ReviewEntraSsprEnabledForAll
{
    <#
    .SYNOPSIS
        If 'Self service password reset enabled' is set to 'All'.
    .DESCRIPTION
        Return true if enabled, otherwise false.
    .EXAMPLE
        Invoke-ReviewEntraSsprEnabledForAll;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # URI.
        $uri = 'https://main.iam.ad.ext.azure.com/api/PasswordReset/PasswordResetPolicies?getPasswordResetEnabledGroup=true';
        
        # Valid configuration.
        [bool]$validConfiguration = $true;
    }
    PROCESS
    {
        # Invoke Entra ID API.
        $passwordResetPolicies = Invoke-EntraIdIamApi -Uri $uri -Method Get;

        # If not set to all users.
        if($passwordResetPolicies.enablementType -ne 2)
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