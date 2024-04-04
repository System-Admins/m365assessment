function Invoke-ReviewFabricSensitivityLabel
{
    <#
    .SYNOPSIS
        Review if 'Allow users to apply sensitivity labels for content' is 'Enabled' in Microsoft Fabric.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewFabricSensitivityLabel;
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
        foreach($tenantSetting in $tenantSettings)
        {
            # If the setting name is not "EimInformationProtectionEdit".
            if($tenantSetting.SettingName -ne 'EimInformationProtectionEdit')
            {
                # Continue to next.
                continue;
            }

            # If tenant setting value is "false".
            if($tenantSetting.Enabled -eq $false)
            {
                # Set valid to false.
                $valid = $false;
            }

            # Write to log.
            Write-CustomLog -Category 'Microsoft Fabric' -Subcategory 'Tenant' -Message ("Allow users to apply sensitivity labels for content is set to '{0}'" -f $valid) -Level Verbose;
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
        $review.Id = '6aa91139-4667-4d38-887b-a22905da5bcc';
        $review.Category = 'Microsoft Fabric Admin Center';
        $review.Subcategory = 'Tenant Settings';
        $review.Title = "Ensure 'Allow users to apply sensitivity labels for content' is 'Enabled'";
        $review.Data = [PSCustomObject]@{
            Enabled = $valid
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