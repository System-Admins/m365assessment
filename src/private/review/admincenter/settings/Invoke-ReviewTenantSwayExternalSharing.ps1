function Invoke-ReviewTenantSwayExternalSharing
{
    <#
    .SYNOPSIS
        Review that Sway cannot be shared with people outside of your organization.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewTenantSwayExternalSharing;
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
        # Get settings.
        $settings = Get-TenantSwaySetting -ErrorAction SilentlyContinue;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If the review flag should be set.
        if ($true -eq $settings.ExternalSharingEnabled)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                       
        # Create new review object to return.
        [Review]$review = [Review]::new();
                               
        # Add to object.
        $review.Id = 'd10b85ac-05df-4c78-91a5-5bc03f799ea2';
        $review.Category = 'Microsoft 365 Admin Center';
        $review.Subcategory = 'Settings';
        $review.Title = 'Ensure that Sways cannot be shared with people outside of your organization';
        $review.Data = [PSCustomObject]@{
            Enabled = $settings.ExternalSharingEnabled
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();
                               
        # Return object.
        return $review;
    }
}