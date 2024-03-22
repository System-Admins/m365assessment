function Invoke-ReviewFabricInteractPython
{
    <#
    .SYNOPSIS
        Review if 'Interact with and share R and Python' visuals is 'Disabled' in Microsoft Fabric.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewFabricInteractPython;
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
            # If the setting name is not "RScriptVisual".
            if($tenantSetting.SettingName -ne 'RScriptVisual')
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
            Write-Log -Category 'Microsoft Fabric' -Subcategory 'Tenant' -Message ("Interact with and share R and Python visuals is set to '{0}'" -f $valid) -Level Debug;
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
        $review.Id = '134ffbee-2092-42a7-9309-7b9b04c14b4b';
        $review.Category = 'Microsoft Fabric Admin Center';
        $review.Subcategory = 'Tenant Settings';
        $review.Title = "Ensure 'Interact with and share R and Python' visuals is 'Disabled'";
        $review.Data = [PSCustomObject]@{
            Disabled = $valid
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}