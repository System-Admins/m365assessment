function Invoke-ReviewSpoExternalSharingRestrictedGroup
{
    <#
    .SYNOPSIS
        Review if external sharing is restricted by security group.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Pnp.PowerShell
    .EXAMPLE
        Invoke-ReviewSpoExternalSharingRestrictedGroup;
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
        $tenantSettings = Invoke-PnPSPRestMethod -Method Get -Url '/_api/SPOInternalUseOnly.Tenant';

        # Setting is valid.
        [bool]$valid = $false;

    }
    PROCESS
    {
        # If security group is set.
        if ($null -ne $tenantSettings.GuestSharingGroupAllowListInTenant -and
            $null -ne $tenantSettings.GuestSharingGroupAllowListInTenantByPrincipalIdentity)
        {
            # Setting is valid.
            $valid = $true;

            # Write to log.
            Write-CustomLog -Category 'SharePoint Online' -Subcategory 'Policies' -Message ("External sharing is restricted by security group '{0}'" -f $tenantSettings.GuestSharingGroupAllowListInTenantByPrincipalIdentity) -Level Verbose;
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
        $review.Id = 'd62a22ba-144b-44e6-8592-9e3692742a89';
        $review.Category = 'Microsoft SharePoint Admin Center';
        $review.Subcategory = 'Policies';
        $review.Title = 'Ensure external sharing is restricted by security group';
        $review.Data = $tenantSettings | Select-Object -Property GuestSharingGroupAllowListInTenant, GuestSharingGroupAllowListInTenantByPrincipalIdentity;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        #Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}