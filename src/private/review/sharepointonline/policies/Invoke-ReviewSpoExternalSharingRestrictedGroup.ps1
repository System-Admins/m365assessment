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
        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ('Getting SharePoint tenant configuration') -Level Debug;
        
        # Get tenant settings.
        $tenantSettings = Invoke-PnPSPRestMethod -Method Get -Url '/_api/SPOInternalUseOnly.Tenant';

        # Setting is valid.
        [bool]$valid = $false;

    }
    PROCESS
    {
        # If security group is set.
        if ($null -ne $tenantSettings.WhoCanShareAllowListInTenant -and
            $null -ne $tenantSettings.WhoCanShareAllowListInTenantByPrincipalIdentity)
        {
            # Setting is valid.
            $valid = $true;

            # Write to log.
            Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ("External sharing is restricted by security group '{0}'" -f $tenantSettings.WhoCanShareAllowListInTenantByPrincipalIdentity) -Level Debug;
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
        $review.Data = [PSObject]@{
            WhoCanShareAllowListInTenant                    = $tenantSettings.WhoCanShareAllowListInTenant;
            WhoCanShareAllowListInTenantByPrincipalIdentity = $tenantSettings.WhoCanShareAllowListInTenantByPrincipalIdentity;
        };
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    } 
}