function Invoke-ReviewFabricExternalDataSharingRestricted
{
    <#
    .SYNOPSIS
        Review if enabling of external data sharing is restricted in Microsoft Fabric.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewFabricExternalDataSharingRestricted;
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
        foreach($tenantSetting in $tenantSettings)
        {
            # If the setting name is not "EnableDatasetInPlaceSharing".
            if($tenantSetting.SettingName -ne 'EnableDatasetInPlaceSharing')
            {
                # Continue to next.
                continue;
            }

            # If tenant setting value is "true".
            if($tenantSetting.Enabled -eq $true)
            {
                # Set valid to false.
                $valid = $false;
            }

            # Write to log.
            Write-Log -Category 'Microsoft Fabric' -Subcategory 'Tenant' -Message ("External data sharing is restricted '{0}'" -f $valid) -Level Debug;
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
        $review.Id = '832a0d52-55b7-4a27-a6c7-a90e04bdaa7a';
        $review.Category = 'Microsoft Fabric Admin Center';
        $review.Subcategory = 'Tenant Settings';
        $review.Title = 'Ensure enabling of external data sharing is restricted';
        $review.Data = $valid;
        $review.Review = $reviewFlag;
                                     
        # Print result.
        $review.PrintResult();
                                                    
        # Return object.
        return $review;
    } 
}