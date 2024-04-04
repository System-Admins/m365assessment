function Invoke-ReviewFabricExternalUserInvitationsRestricted
{
    <#
    .SYNOPSIS
        Review external user invitations are restricted in Microsoft Fabric.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewFabricExternalUserInvitationsRestricted;
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
        Write-CustomLog -Category 'Microsoft Fabric' -Subcategory 'Tenant' -Message ('Getting tenant settings') -Level Verbose;

        # URI to the API.
        $uri = 'https://api.fabric.microsoft.com/v1/admin/tenantsettings';

        # Valid flag.
        [bool]$valid = $true;
    }
    PROCESS
    {
        # Get tenant settings.
        $tenantSettings = (Invoke-FabricApi -Uri $uri -Method 'GET').tenantsettings;

        # Foreach tenant setting.
        foreach ($tenantSetting in $tenantSettings)
        {
            # If the setting name is not "ExternalSharingV2".
            if ($tenantSetting.SettingName -ne 'ExternalSharingV2')
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
            Write-CustomLog -Category 'Microsoft Fabric' -Subcategory 'Tenant' -Message ('external user invitations are restricted in Microsoft Fabric') -Level Verbose;
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
        $review.Id = 'da8daeae-fc77-4bff-9733-19e8fe73b87b';
        $review.Category = 'Microsoft Fabric Admin Center';
        $review.Subcategory = 'Tenant Settings';
        $review.Title = 'Ensure external user invitations are restricted';
        $review.Data = [PSCustomObject]@{
            Restricted = $valid
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