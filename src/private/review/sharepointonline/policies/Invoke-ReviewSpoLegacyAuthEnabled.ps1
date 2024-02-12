function Invoke-ReviewSpoLegacyAuthEnabled
{
    <#
    .SYNOPSIS
        If legacy authentication is enabled in SharePoint Online.
    .DESCRIPTION
        Return true if enabled otherwise false.
    .EXAMPLE
        Invoke-ReviewSpoLegacyAuthEnabled;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
    }
    PROCESS
    {
        # Get tenant settings.
        $tenantSettings = Get-PnPTenant;
    }
    END
    {
        # Return bool.
        return [bool]$tenantSettings.LegacyAuthProtocolsEnabled;
    }
}