function Invoke-ReviewFabricPublishToWebRestricted
{
    <#
    .SYNOPSIS
        Review if 'Publish to web' is restricted in Microsoft Fabric.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewFabricPublishToWebRestricted;
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
            # If the setting name is not "PublishToWeb".
            if($tenantSetting.SettingName -ne 'PublishToWeb')
            {
                # Continue to next.
                continue;
            }

            # If tenant setting value is not "false".
            if($tenantSetting.Enabled -eq $true)
            {
                # Set valid to false.
                $valid = $false;
            }

            # Write to log.
            Write-Log -Category 'Microsoft Fabric' -Subcategory 'Tenant' -Message ("Publish to web restriction is set to '{0}'" -f $valid) -Level Debug;
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
        $review.Id = 'fdd450f1-fb71-4450-a9e2-c82e916e86ab';
        $review.Category = 'Microsoft Fabric Admin Center';
        $review.Subcategory = 'Tenant Settings';
        $review.Title = "Ensure 'Publish to web' is restricted";
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