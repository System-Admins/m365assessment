function Invoke-ReviewTenantCustomerLockEnabled
{
    <#
    .SYNOPSIS
        Review that customer lock is enabled.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewTenantCustomerLockEnabled;
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
        $settings = Get-OrganizationConfig;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If the review flag should be set.
        if ($false -eq $settings.CustomerLockBoxEnabled)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                               
        # Create new review object to return.
        $review = [Review]::new();
                       
        # Add to object.
        $review.Id = 'f4cf24ca-cd8f-4ded-bfe0-6f45f3bcfed0';
        $review.Title = "Ensure the customer lockbox feature is enabled";
        $review.Data = $settings.CustomerLockBoxEnabled;
        $review.Review = $reviewFlag;
                       
        # Return object.
        return $review;
    }
}