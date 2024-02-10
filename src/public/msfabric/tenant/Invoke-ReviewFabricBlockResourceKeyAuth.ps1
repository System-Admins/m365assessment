function Invoke-ReviewFabricBlockResourceKeyAuth
{
    <#
    .SYNOPSIS
        Review if 'Block ResourceKey Authentication' is 'Enabled' in Microsoft Fabric.
    .DESCRIPTION
        Return true if configured correctly, false otherwise.
    .EXAMPLE
        Invoke-ReviewFabricBlockResourceKeyAuth;
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
            # If the setting name is not "BlockResourceKeyAuthentication".
            if($tenantSetting.SettingName -ne 'BlockResourceKeyAuthentication')
            {
                # Continue to next.
                continue;
            }

            # If tenant setting value is "true".
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