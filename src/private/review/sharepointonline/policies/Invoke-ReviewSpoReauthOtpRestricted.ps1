function Invoke-ReviewSpoReauthOtpRestricted
{
    <#
    .SYNOPSIS
        Review if re-authentication with verification code is restricted.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Pnp.PowerShell
    .EXAMPLE
        Invoke-ReviewSpoReauthOtpRestricted;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ('Getting SharePoint tenant configuration') -Level Debug;
        
        # Get tenant settings.
        $tenantSettings = Invoke-PnPSPRestMethod -Method Get -Url '/_api/SPOInternalUseOnly.Tenant';

        # Setting is valid.
        [bool]$valid = $false;

    }
    PROCESS
    {
        # If days is set to 30.
        if ($tenantSettings.EmailAttestationEnabled -eq $true -and
            $tenantSettings.EmailAttestationReAuthDays -le 15)
        {
            # Setting is valid.
            $valid = $true;
        }

        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ("Email attestation is '{0}' and re-auth days is '{1}'" -f $tenantSettings.EmailAttestationEnabled, $tenantSettings.EmailAttestationReAuthDays) -Level Debug;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($false -eq $valid)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                                     
        # Create new review object to return.
        [Review]$review = [Review]::new();
                                             
        # Add to object.
        $review.Id = '82712a94-8427-4871-8d09-f2b94e8e1bf1';
        $review.Category = 'Microsoft SharePoint Admin Center';
        $review.Subcategory = 'Policies';
        $review.Title = 'Ensure reauthentication with verification code is restricted';
        $review.Data = [PSCustomObject]@{
            EmailAttestationEnabled    = $tenantSettings.EmailAttestationEnabled;
            EmailAttestationReAuthDays = $tenantSettings.EmailAttestationReAuthDays;
        };
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    } 
}