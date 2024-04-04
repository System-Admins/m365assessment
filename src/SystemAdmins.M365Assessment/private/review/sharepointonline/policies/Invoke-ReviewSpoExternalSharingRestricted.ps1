function Invoke-ReviewSpoExternalSharingRestricted
{
    <#
    .SYNOPSIS
        Review if external content sharing is restricted for SharePoint Online.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Pnp.PowerShell
    .EXAMPLE
        Invoke-ReviewSpoExternalSharingRestricted;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # Write to log.
        Write-CustomLog -Category 'SharePoint Online' -Subcategory 'Policies' -Message ('Getting SharePoint tenant configuration') -Level Verbose;

        # Get tenant settings.
        $tenantSettings = Get-PnPTenant;

        # External sharing bool.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If the external sharing is restricted.
        if ($tenantSettings.SharingCapability -eq 'ExternalUserSharingOnly' -or
            $tenantSettings.SharingCapability -eq 'ExistingExternalUserSharingOnly' -or
            $tenantSettings.SharingCapability -eq 'Disabled')
        {
            # Setting is valid.
            $valid = $true;
        }

        # If the external sharing is not restricted.
        if ($false -eq $valid)
        {
            # Write to log.
            Write-CustomLog -Category 'SharePoint Online' -Subcategory 'Policies' -Message ('Sharing is not restricted') -Level Verbose;
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
        $review.Id = 'f30646cc-e1f1-42b5-a3a5-4d46db01e822';
        $review.Category = 'Microsoft SharePoint Admin Center';
        $review.Subcategory = 'Policies';
        $review.Title = 'Ensure external content sharing is restricted';
        $review.Data = $tenantSettings | Select-Object -Property SharingCapability;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        #Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}