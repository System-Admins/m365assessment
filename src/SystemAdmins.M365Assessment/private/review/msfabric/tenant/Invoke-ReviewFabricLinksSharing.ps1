function Invoke-ReviewFabricLinksSharing
{
    <#
    .SYNOPSIS
        Review if shareable links are restricted in Microsoft Fabric.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewFabricLinksSharing;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name;

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
            # If the setting name is not "ShareLinkToEntireOrg".
            if($tenantSetting.SettingName -ne 'ShareLinkToEntireOrg')
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
            Write-CustomLog -Category 'Microsoft Fabric' -Subcategory 'Tenant' -Message ("Shareable links are restricted '{0}'" -f $valid) -Level Verbose;
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
        $review.Id = 'e9ec0d44-00a5-4305-9d15-a225f00a8364';
        $review.Category = 'Microsoft Fabric Admin Center';
        $review.Subcategory = 'Tenant Settings';
        $review.Title = 'Ensure shareable links are restricted';
        $review.Data = [PSCustomObject]@{
            Restricted = $valid
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}