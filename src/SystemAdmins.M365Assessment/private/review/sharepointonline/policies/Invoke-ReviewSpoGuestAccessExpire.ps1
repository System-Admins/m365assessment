function Invoke-ReviewSpoGuestAccessExpire
{
    <#
    .SYNOPSIS
        Review if guest access to a site or OneDrive will expire automatically.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Pnp.PowerShell
    .EXAMPLE
        Invoke-ReviewSpoGuestAccessExpire;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name;

        # Write to log.
        Write-CustomLog -Category 'SharePoint Online' -Subcategory 'Policies' -Message ('Getting SharePoint tenant configuration') -Level Verbose;

        # Get tenant settings.
        $tenantSettings = Invoke-PnPSPRestMethod -Method Get -Url '/_api/SPOInternalUseOnly.Tenant';

        # Setting is valid.
        [bool]$valid = $false;

    }
    PROCESS
    {
        # If days is set to 30.
        if ($tenantSettings.ExternalUserExpireInDays -eq 30)
        {
            # Setting is valid.
            $valid = $true;
        }

        # Write to log.
        Write-CustomLog -Category 'SharePoint Online' -Subcategory 'Policies' -Message ("Guest user access is set to expire after {0} days" -f $tenantSettings.ExternalUserExpireInDays) -Level Verbose;
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
        $review.Id = 'af231488-4ca8-4496-8d10-09b65110d1ee';
        $review.Category = 'Microsoft SharePoint Admin Center';
        $review.Subcategory = 'Policies';
        $review.Title = 'Ensure guest access to a site or OneDrive will expire automatically';
        $review.Data = $tenantSettings | Select-Object -Property ExternalUserExpireInDays;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}