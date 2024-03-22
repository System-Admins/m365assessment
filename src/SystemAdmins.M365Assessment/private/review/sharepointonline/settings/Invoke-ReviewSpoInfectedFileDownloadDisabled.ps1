function Invoke-ReviewSpoInfectedFileDownloadDisabled
{
    <#
    .SYNOPSIS
        Review if Office 365 SharePoint infected files are disallowed for download.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Pnp.PowerShell
    .EXAMPLE
        Invoke-ReviewSpoInfectedFileDownloadDisabled;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {

    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Settings' -Message ('Getting SharePoint tenant configuration') -Level Debug;

        # Get tenant settings.
        $tenantSettings = Invoke-PnPSPRestMethod -Method Get -Url '/_api/SPOInternalUseOnly.Tenant';

        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Settings' -Message ("Infected file download is '{0}'" -f $tenantSettings.DisallowInfectedFileDownload) -Level Debug;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $tenantSettings.DisallowInfectedFileDownload)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '7033c11e-71d9-407b-9a19-cde209d05426';
        $review.Category = 'Microsoft SharePoint Admin Center';
        $review.Subcategory = 'Settings';
        $review.Title = 'Ensure Office 365 SharePoint infected files are disallowed for download';
        $review.Data = $tenantSettings | Select-Object -Property DisallowInfectedFileDownload;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}