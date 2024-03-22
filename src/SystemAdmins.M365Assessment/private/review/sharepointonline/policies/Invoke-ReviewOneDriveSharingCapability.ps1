function Invoke-ReviewOneDriveSharingCapability
{
    <#
    .SYNOPSIS
        Review if external content sharing is restricted for OneDrive.
   .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Pnp.PowerShell
    .EXAMPLE
        Invoke-ReviewOneDriveSharingCapability;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get SharePoint URLs.
        $spoUrls = Get-SpoTenantUrl;

        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ('Getting OneDrive tenant configuration') -Level Debug;

        # Get tenant settings.
        $tenantSettings = Get-PnPTenantSite -Identity $spoUrls.OneDrive;

        # External sharing bool.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If the external sharing is restricted.
        if ($tenantSettings.SharingCapability -eq 'Disabled')
        {
            # Setting is valid.
            $valid = $true;
        }
        # Else not restricted.
        else
        {
            # Write to log.
            Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ('OneDrive sharing is not restricted') -Level Debug;
        }
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
        $review.Id = 'fcf37f2f-6b1d-4616-85cd-0b5b33d8f028';
        $review.Category = 'Microsoft SharePoint Admin Center';
        $review.Subcategory = 'Policies';
        $review.Title = "Ensure OneDrive content sharing is restricted";
        $review.Data = $tenantSettings | Select-Object -Property SharingCapability;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}