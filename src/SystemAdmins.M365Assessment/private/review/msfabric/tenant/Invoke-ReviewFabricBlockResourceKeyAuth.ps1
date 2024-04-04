function Invoke-ReviewFabricBlockResourceKeyAuth
{
    <#
    .SYNOPSIS
        Review if 'Block ResourceKey Authentication' is 'Enabled' in Microsoft Fabric.
    .DESCRIPTION
        Return true if configured correctly, false otherwise.
    .EXAMPLE
        Invoke-ReviewFabricBlockResourceKeyAuth;
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
            # If the setting name is not "BlockResourceKeyAuthentication".
            if ($tenantSetting.SettingName -ne 'BlockResourceKeyAuthentication')
            {
                # Continue to next.
                continue;
            }

            # If tenant setting value is "true".
            if ($tenantSetting.Enabled -eq $false)
            {
                # Set valid to false.
                $valid = $false;
            }

            # Write to log.
            Write-CustomLog -Category 'Microsoft Fabric' -Subcategory 'Tenant' -Message ("Block ResourceKey Authentication '{0}'" -f $valid) -Level Verbose;
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
        $review.Id = 'bbcbdabf-221c-412e-92d5-67367053ff27';
        $review.Category = 'Microsoft Fabric Admin Center';
        $review.Subcategory = 'Tenant Settings';
        $review.Title = "Ensure 'Block ResourceKey Authentication' is 'Enabled'";
        $review.Data = [PSCustomObject]@{
            Blocked = $valid
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        #Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}