function Invoke-ReviewEntraUsersCanRegisterAppsEnabled
{
    <#
    .SYNOPSIS
        If users are allowed to register apps in Entra ID.
    .DESCRIPTION
        Return true or false.
    .EXAMPLE
        Invoke-ReviewEntraUsersCanRegisterAppsEnabled;
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
        # Get auth policy.
        $authorizationPolicy = Get-MgPolicyAuthorizationPolicy;
    }
    END
    {
        # Return state.
        return [bool]$authorizationPolicy.DefaultUserRolePermissions.AllowedToCreateApps;
    }
}