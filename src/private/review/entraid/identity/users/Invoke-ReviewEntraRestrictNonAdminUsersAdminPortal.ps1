function Invoke-ReviewEntraRestrictNonAdminUsersAdminPortal
{
    <#
    .SYNOPSIS
        If users are allowed to access admin portal in Entra ID.
    .DESCRIPTION
        Return true or false.
    .EXAMPLE
        Invoke-ReviewEntraRestrictNonAdminUsersAdminPortal;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # URI to the API.
        $uri = 'https://main.iam.ad.ext.azure.com/api/Directories/Properties';   
    }
    PROCESS
    {
        # Get the Entra ID property settings.
        $entraIdProperties = Invoke-EntraIdIamApi -Uri $uri -Method 'GET';
    }
    END
    {
        # Return state.
        return [bool]$entraIdProperties.restrictNonAdminUsers;
    }
}