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
        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ('Getting SharePoint tenant configuration') -Level Debug;

        # Get tenant settings.
        $tenantSettings = Get-PnPTenant;

        # External sharing bool.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If the external sharing is restricted.
        if ($tenantSettings.SharingCapability -eq 'ExternalUserSharingOnly' -and
            $tenantSettings.SharingCapability -eq 'ExistingExternalUserSharingOnly' -and
            $tenantSettings.SharingCapability -eq 'Disabled')
        {
            # Setting is valid.
            $valid = $true;
        }
        
        # If the external sharing is not restricted.
        if ($false -eq $valid)
        {
            # Write to log.
            Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ('Sharing is not restricted') -Level Debug;
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
                                             
        # Return object.
        return $review;
    } 
}