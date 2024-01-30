function Invoke-ReviewEntraUsersCanRegisterAppsEnabled
{
    <#
    .SYNOPSIS
        If users are allowed to register apps in Entra ID.
    .DESCRIPTION
        Return true or false
    .EXAMPLE
        Invoke-ReviewEntraUsersCanRegisterAppsEnabled;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Uri to API.
        $uri = 'https://main.iam.ad.ext.azure.com/api/Directories/Properties';
    }
    PROCESS
    {
        # Get settings.
        $entraIdDirectoryProperties = Invoke-EntraIdIamApi -Uri $uri -Method 'GET';
    }
    END
    {
        # Return state.
        return [bool]$entraIdDirectoryProperties.usersCanRegisterApps;
    }
}