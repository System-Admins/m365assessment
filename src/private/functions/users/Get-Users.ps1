Function Get-UsersWithAdminRoles
{
    <#
    .SYNOPSIS
        .
    .DESCRIPTION
        .
    .EXAMPLE
        .
    #>
    BEGIN
    {
    }
    PROCESS
    {
        # Get all users with admin roles.
        $users = Get-MgUser -All
    }
    END
    {
    }
}