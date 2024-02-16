function Invoke-ReviewSpoGuestResharingRestricted
{
    <#
    .SYNOPSIS
        Review if that SharePoint guest users cannot share items they don't own.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Pnp.PowerShell
    .EXAMPLE
        Invoke-ReviewSpoGuestResharingRestricted;
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
        Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ("Getting SharePoint tenant configuration") -Level Debug;

        # Get tenant settings.
        $tenantSettings = Get-PnPTenant;

        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ("Prevent external users from resharing is '{0}'" -f $tenantSettings.PreventExternalUsersFromResharing) -Level Debug;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($false -eq $tenantSettings.PreventExternalUsersFromResharing)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                                     
        # Create new review object to return.
        [Review]$review = [Review]::new();
                                             
        # Add to object.
        $review.Id = '1a27642f-0ab9-46ba-8d26-8e14a5b52994';
        $review.Category = 'Microsoft SharePoint Admin Center';
        $review.Subcategory = 'Policies';
        $review.Title = "Ensure that SharePoint guest users cannot share items they don't own";
        $review.Data = $tenantSettings.PreventExternalUsersFromResharing;
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    } 
}