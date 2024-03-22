function Invoke-ReviewSpoEntraIdB2B
{
    <#
    .SYNOPSIS
        Review if Entra ID B2B is enabled in SharePoint Online.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Pnp.PowerShell
    .EXAMPLE
        Invoke-ReviewSpoEntraIdB2B;
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
        Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ('Getting SharePoint tenant configuration') -Level Debug;

        # Get tenant settings.
        $tenantSettings = Get-PnPTenant;

        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ("Enable Entra B2B feature is set to '{0}'" -f $tenantSettings.EnableAzureADB2BIntegration) -Level Debug;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $tenantSettings.EnableAzureADB2BIntegration)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '68e99561-878a-4bcd-bce1-d69a6c0e2282';
        $review.Category = 'Microsoft SharePoint Admin Center';
        $review.Subcategory = 'Policies';
        $review.Title = 'Ensure SharePoint and OneDrive integration with Azure AD B2B is enabled';
        $review.Data = $tenantSettings | Select-Object -Property EnableAzureADB2BIntegration;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}