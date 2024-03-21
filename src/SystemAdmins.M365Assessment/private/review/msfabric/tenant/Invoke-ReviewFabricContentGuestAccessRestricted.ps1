function Invoke-ReviewFabricContentGuestAccessRestricted
{
    <#
    .SYNOPSIS
        Review if guest access to content is restricted in Microsoft Fabric.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewFabricContentGuestAccessRestricted;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # URI to the API.
        $uri = 'https://api.fabric.microsoft.com/v1/admin/tenantsettings';

        # Valid flag.
        [bool]$valid = $true;
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'Microsoft Fabric' -Subcategory 'Tenant' -Message ('Getting tenant settings') -Level Debug;

        # Get tenant settings.
        $tenantSettings = (Invoke-FabricApi -Uri $uri -Method 'GET').tenantsettings;

        # Foreach tenant setting.
        foreach ($tenantSetting in $tenantSettings)
        {
            # If the setting name is not "ElevatedGuestsTenant".
            if ($tenantSetting.SettingName -ne 'ElevatedGuestsTenant')
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

            # Write to log.
            Write-Log -Category 'Microsoft Fabric' -Subcategory 'Tenant' -Message ('Guest access to content is restricted') -Level Debug;
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
        $review.Id = '24e5ca61-a473-4fcc-b4ef-aad5235e573f';
        $review.Category = 'Microsoft Fabric Admin Center';
        $review.Subcategory = 'Tenant Settings';
        $review.Title = 'Ensure guest access to content is restricted';
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