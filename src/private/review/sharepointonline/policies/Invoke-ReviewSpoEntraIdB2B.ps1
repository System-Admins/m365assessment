function Invoke-ReviewSpoEntraIdB2B
{
    <#
    .SYNOPSIS
        Review if Entra ID B2B is enabled in SharePoint Online.
    .DESCRIPTION
        Return true if enabled otherwise false.
    .EXAMPLE
        Invoke-ReviewSpoEntraIdB2B;
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
        return [bool]$tenantSettings.EnableAzureADB2BIntegration;
    } 
}