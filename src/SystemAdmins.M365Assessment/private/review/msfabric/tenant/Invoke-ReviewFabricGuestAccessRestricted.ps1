function Invoke-ReviewFabricGuestAccessRestricted
{
    <#
    .SYNOPSIS
        Review if guest user access is restricted in Microsoft Fabric.
    .DESCRIPTION
        Return true if configured correctly, false otherwise.
    .EXAMPLE
        Invoke-ReviewFabricGuestAccessRestricted;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # URI to the API.
        $uri = 'https://api.fabric.microsoft.com/v1/admin/tenantsettings';

        # Valid flag.
        [bool]$valid = $true;
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category 'Microsoft Fabric' -Subcategory 'Tenant' -Message ('Getting tenant settings') -Level Verbose;

        # Get tenant settings.
        $tenantSettings = (Invoke-FabricApi -Uri $uri -Method 'GET').tenantsettings;

        # Foreach tenant setting.
        foreach ($tenantSetting in $tenantSettings)
        {
            # If the setting name is not "AllowGuestUserToAccessSharedContent".
            if ($tenantSetting.SettingName -ne 'AllowGuestUserToAccessSharedContent')
            {
                # Continue to next.
                continue;
            }

            # If tenant setting value is not "false".
            if ($tenantSetting.Enabled -eq $true)
            {
                # Set valid to false.
                $valid = $false;
            }
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
        $review.Id = '4d179407-ca60-4a37-981f-99584ea2d6ea';
        $review.Category = 'Microsoft Fabric Admin Center';
        $review.Subcategory = 'Tenant Settings';
        $review.Title = 'Ensure guest user access is restricted';
        $review.Data = [PSCustomObject]@{
            Restricted = $valid
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}