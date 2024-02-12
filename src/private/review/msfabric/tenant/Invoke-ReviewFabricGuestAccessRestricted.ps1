function Invoke-ReviewFabricGuestAccessRestricted
{
    <#
    .SYNOPSIS
        Review if guest user access is restricted in Microsoft Fabric.
    .DESCRIPTION
        Return true if configured correctly, false otherwise.
    .EXAMPLE
        Invoke-ReviewFabricGuestAccessRestricted;
    #>

    [CmdletBinding()]
    Param
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
            # If the setting name is not "AllowGuestUserToAccessSharedContent".
            if($tenantSetting.SettingName -ne 'AllowGuestUserToAccessSharedContent')
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