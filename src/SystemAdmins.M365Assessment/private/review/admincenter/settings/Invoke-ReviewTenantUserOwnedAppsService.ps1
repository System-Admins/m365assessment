function Invoke-ReviewTenantUserOwnedAppsService
{
    <#
    .SYNOPSIS
        Review 'User owned apps and services' is restricted
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewTenantUserOwnedAppsService;
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
        Write-CustomLog -Category 'Tenant' -Subcategory 'Policy' -Message 'Getting user owned apps and services settings' -Level Verbose;

        # Get User owned apps and services settings.
        $settings = Get-TenantStorePolicy;

        # Boolean to check restrictions.
        [bool]$restricted = $false;
    }
    PROCESS
    {
        # If the settings are null.
        if ($null -eq $settings)
        {
            # Throw exception.
            throw ("Something went wrong getting user owned apps and services settings");
        }

        # If "Let users access the Office store" and "Let users start trials on behalf of your organization" is disabled.
        if ($settings.accessOfficeStore -eq $false -and $settings.startTrial -eq $false)
        {
            # Set restricted to true.
            $restricted = $true;
        }

        # Write to log.
        Write-CustomLog -Category 'Tenant' -Subcategory 'Policy' -Message ("'Let users access the Office store' status is set to '{0}'" -f $settings.accessOfficeStore) -Level Verbose;
        Write-CustomLog -Category 'Tenant' -Subcategory 'Policy' -Message ("'Let users start trials on behalf of your organization' status is set to '{0}'" -f $settings.accessOfficeStore) -Level Verbose;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $restricted)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '59a56832-8e8f-42ef-b03c-3a147059fe6f';
        $review.Category = 'Microsoft 365 Admin Center';
        $review.Subcategory = 'Settings';
        $review.Title = "Ensure 'User owned apps and services' is restricted";
        $review.Data = $settings;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        #Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}