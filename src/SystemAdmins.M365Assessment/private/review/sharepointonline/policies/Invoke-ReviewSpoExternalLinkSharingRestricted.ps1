function Invoke-ReviewSpoExternalLinkSharingRestricted
{
    <#
    .SYNOPSIS
        Review if link sharing is restricted in SharePoint and OneDrive.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Pnp.PowerShell
    .EXAMPLE
        Invoke-ReviewSpoExternalLinkSharingRestricted;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get SPO urls.
        $spoUrls = Get-SpoTenantUrl;

        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ('Getting SharePoint and OneDrive tenant configuration') -Level Debug;

        # Get tenant settings.
        $spoTenantSettings = Get-PnPTenant;
        $odfbTenantSettings = Get-PnPTenantSite -Identity $spoUrls.OneDrive;

        # External sharing bool.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If the external link sharing is direct.
        if ($spotenantSettings.DefaultSharingLinkType -eq 'Direct' -and
            $odfbtenantSettings.DefaultSharingLinkType -eq 'Direct')
        {
            # Setting is valid.
            $valid = $true;
        }

        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ("External link sharing is set to '{0}' in SharePoint and '{1}' in OneDrive" -f $spoTenantSettings.DefaultSharingLinkType, $odfbTenantSettings.DefaultSharingLinkType) -Level Debug;
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
        $review.Id = 'c4b93e39-d8a1-459e-835e-e4545418c633';
        $review.Category = 'Microsoft SharePoint Admin Center';
        $review.Subcategory = 'Policies';
        $review.Title = 'Ensure link sharing is restricted in SharePoint and OneDrive';
        $review.Data = [PSCustomObject]@{
            SharePointLinkSharing = $spoTenantSettings.DefaultSharingLinkType;
            OneDriveLinkSharing   = $odfbTenantSettings.DefaultSharingLinkType;
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}