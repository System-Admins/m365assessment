function Get-SpoUrl
{
    <#
    .SYNOPSIS
        Get SharePoint URLs.
    .DESCRIPTION
        Return object of two URLs (sites and admin center).
    .EXAMPLE
        Get-SpoUrl
    #>
    [CmdletBinding()]
    Param
    (
    )
    
    BEGIN
    {
        # Get domains.
        $azDomains = Get-AzDomain;
    }
    PROCESS
    {
        # Get directory domain.
        $directoryUrl = $azDomains.ExtendedProperties.Directory;

        # Split the domain.
        $tenantName = $directoryUrl.Split('.')[0];

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