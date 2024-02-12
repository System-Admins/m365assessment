function Invoke-ReviewFabricContentGuestAccessRestricted
{
    <#
    .SYNOPSIS
        Review if guest access to content is restricted in Microsoft Fabric.
    .DESCRIPTION
        Return true if configured correctly, false otherwise.
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
        # Get tenant settings.
        $tenantSettings = (Invoke-FabricApi -Uri $uri -Method 'GET').tenantsettings;

        # Foreach tenant setting.
        foreach($tenantSetting in $tenantSettings)
        {
            # If the setting name is not "ElevatedGuestsTenant".
            if($tenantSetting.SettingName -ne 'ElevatedGuestsTenant')
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
        }
    }
    END
    {
        # Return bool.
        return $valid;
    } 
}