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
        # API url.
        $apiUrl = 'https://admin.microsoft.com/admin/api/navigation';

        # Invoke API.
        $navigation = Invoke-MsAdminApi -Uri $apiUrl -Method 'GET';
    }
    PROCESS
    {
        # Get SharePoint admin url.
        $adminUrl = ($navigation.AdminConsoles.submenu | Where-Object { $_.text -eq 'SharePoint' }).sref;

        # Get the tenant name.
        $tenantName = (($adminUrl.Split('/')[2]).Split('.')[0]).Split('-')[0];

        # Construct URLs.
        $spoUrl = ('https://{0}.sharepoint.com' -f $tenantName);
        $spoAdminUrl = ('https://{0}-admin.sharepoint.com' -f $tenantName);
        $oneDriveUrl = ('https://{0}-my.sharepoint.com' -f $tenantName);

        # Create object.
        $spoUrls = [PSCustomObject]@{
            Url      = $spoUrl;
            AdminUrl = $spoAdminUrl;
            OneDrive = $oneDriveUrl;
        };
    }
    END
    {
        # Return object.
        return $spoUrls;
    }
}