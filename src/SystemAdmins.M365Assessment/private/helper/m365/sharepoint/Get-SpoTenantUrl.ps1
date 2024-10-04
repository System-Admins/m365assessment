function Get-SpoTenantUrl
{
    <#
    .SYNOPSIS
        Get SharePoint URLs.
    .DESCRIPTION
        Return object of two URLs (sites and admin center).
    .EXAMPLE
        Get-SpoTenantUrl
    #>
    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get initial domain.
        $initialDomain = Get-MgDomain -All | Where-Object {$_.IsInitial -eq $true};
    }
    PROCESS
    {
        # Get the tenant name.
        $tenantName = ($initialDomain.Id).Split('.')[0];

        # Construct URLs.
        $spoUrl = ('https://{0}.sharepoint.com' -f $tenantName);
        $spoAdminUrl = ('https://{0}-admin.sharepoint.com' -f $tenantName);
        $oneDriveUrl = ('https://{0}-my.sharepoint.com' -f $tenantName);

        # Create object.
        $spoUrls = [PSCustomObject]@{
            Url      = $spoUrl;
            AdminUrl = $spoAdminUrl;
            OneDrive = $oneDriveUrl;
            tenantUrl = $initialDomain.Id;
        };
    }
    END
    {
        # Return object.
        return $spoUrls;
    }
}