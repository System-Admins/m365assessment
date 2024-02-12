function Invoke-ReviewSpoGuestAccessExpire
{
    <#
    .SYNOPSIS
        Review if guest access to a site or OneDrive will expire automatically.
    .DESCRIPTION
        Return object with days and if setting is valid.
    .EXAMPLE
        Invoke-ReviewSpoGuestAccessExpire;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get tenant settings.
        $tenantSettings = Invoke-PnPSPRestMethod -Method Get -Url '/_api/SPOInternalUseOnly.Tenant';

        # Setting is valid.
        [bool]$guestAccessExpireValid = $false;

    }
    PROCESS
    {
        # If days is set to 30.
        if ($tenantSettings.ExternalUserExpireInDays -eq 30)
        {
            # Setting is valid.
            $guestAccessExpireValid = $true;
        }
    }
    END
    {
        # Return object.
        return [PSCustomObject]@{
            Valid                    = $guestAccessExpireValid;
            ExternalUserExpireInDays = $tenantSettings.ExternalUserExpireInDays;
        }
    } 
}