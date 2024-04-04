function Invoke-ReviewSpoDomainSharingControl
{
    <#
    .SYNOPSIS
        Review if SharePoint external sharing is managed through domain whitelist/blacklists.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Pnp.PowerShell
    .EXAMPLE
        Invoke-ReviewSpoDomainSharingControl;
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
        $tenantSettings = Get-PnPTenant;

        # Bool for valid setting.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If SharingDomainRestrictionMode is set to allow list.
        if ($tenantSettings.SharingDomainRestrictionMode -eq 'AllowList')
        {
            # Return true.
            $valid = $true;
        }

        # Write to log.
        Write-CustomLog -Category 'SharePoint Online' -Subcategory 'Policies' -Message ("External sharing mode is set to '{0}'" -f $tenantSettings.SharingDomainRestrictionMode) -Level Verbose;
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
        $review.Id = '2c6d9aa6-0698-468d-8b0f-8d40ba5daa7b';
        $review.Category = 'Microsoft SharePoint Admin Center';
        $review.Subcategory = 'Policies';
        $review.Title = 'Ensure SharePoint external sharing is managed through domain whitelist/blacklists';
        $review.Data = $tenantSettings | Select-Object -Property SharingDomainRestrictionMode;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}