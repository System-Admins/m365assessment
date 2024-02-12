function Invoke-ReviewSpoReauthOtpRestricted
{
    <#
    .SYNOPSIS
        Review if reauthentication with verification code is restricted.
    .DESCRIPTION
        Return object with days and if setting is valid.
    .EXAMPLE
        Invoke-ReviewSpoReauthOtpRestricted;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get tenant settings.
        $tenantSettings = Invoke-PnPSPRestMethod -Method Get -Url '/_api/SPOInternalUseOnly.Tenant';

        # Setting is valid.
        [bool]$reauthOtpValid = $false;

    }
    PROCESS
    {
        # If days is set to 30.
        if ($tenantSettings.EmailAttestationEnabled -eq $true -and
            $tenantSettings.EmailAttestationReAuthDays -le 15)
        {
            # Setting is valid.
            $reauthOtpValid = $true;
        }
    }
    END
    {
        # Return object.
        return [PSCustomObject]@{
            Valid                      = $reauthOtpValid;
            EmailAttestationEnabled    = $tenantSettings.EmailAttestationEnabled;
            EmailAttestationReAuthDays = $tenantSettings.EmailAttestationReAuthDays;
        }
    } 
}