function Invoke-ReviewFabricLinksSharing
{
    <#
    .SYNOPSIS
        Review if shareable links are restricted in Microsoft Fabric.
    .DESCRIPTION
        Return true if configured correctly, false otherwise.
    .EXAMPLE
        Invoke-ReviewFabricLinksSharing;
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
        }
    }
    END
    {
        # Return bool.
        return $valid;
    } 
}