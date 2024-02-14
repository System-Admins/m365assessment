function Invoke-ReviewEntraApplicationUserConsent
{
    <#
    .SYNOPSIS
        If user consent to apps accessing company data on their behalf is not allowed in Entra ID.
    .DESCRIPTION
        Return true or false.
    .EXAMPLE
        Invoke-ReviewEntraApplicationUserConsent;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get user consent setting.
        $userConsentSetting = Get-EntraIdApplicationUserConsentSetting; 

        # Boolean if valid. 
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If don't allow user consent.
        if ($userConsentSetting -eq 'DoNotAllowUserConsent')
        {
            # Set valid.
            $valid = $true;
        }
    }
    END
    {
        # Return state.
        return $valid;
    }
}