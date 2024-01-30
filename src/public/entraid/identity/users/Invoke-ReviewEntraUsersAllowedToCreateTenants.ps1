function Invoke-ReviewEntraUsersAllowedToCreateTenants
{
    <#
    .SYNOPSIS
        If users are allowed to create tenants in Entra ID.
    .DESCRIPTION
        Return true or false.
    .EXAMPLE
        Invoke-ReviewEntraUsersAllowedToCreateTenants;
    #>

    [CmdletBinding()]
    Param
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
        return [bool]$authorizationPolicy.DefaultUserRolePermissions.AllowedToCreateTenants;
    }
}