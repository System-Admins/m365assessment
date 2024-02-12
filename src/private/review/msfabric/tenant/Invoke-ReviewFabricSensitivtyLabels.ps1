function Invoke-ReviewFabricSensitivtyLabels
{
    <#
    .SYNOPSIS
        Review if 'Allow users to apply sensitivity labels for content' is 'Enabled' in Microsoft Fabric.
    .DESCRIPTION
        Return true if configured correctly, false otherwise.
    .EXAMPLE
        Invoke-ReviewFabricSensitivtyLabels;
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
        }
    }
    END
    {
        # Return bool.
        return $valid;
    } 
}