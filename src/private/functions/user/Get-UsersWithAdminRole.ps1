function Get-UsersWithAdminRole
{
    <#
    .SYNOPSIS
        Get users with admin roles.
    .DESCRIPTION
        Get all users with admin roles and returns object array
    .EXAMPLE
        $usersWithAdminRoles = Get-UsersWithAdminRole;
    #>
    [cmdletBinding()]
    param
    ( 
    )

    BEGIN
    {
        # Object array to store users with admin roles.
        $usersWithAdminRoles = New-Object System.Collections.ArrayList;

        # Get all users.
        $users = Get-MgUser -All;

        # Get all roles.
        $roles = Get-MgDirectoryRole -All;
    }
    PROCESS
    {
        # Foreach role.
        foreach ($role in $roles)
        {
            # Get role members.
            $roleMembers = Get-MgDirectoryRoleMember -DirectoryRoleId $role.Id;

            # Foreach role member.
            foreach ($roleMember in $roleMembers)
            {
                # Get user.
                $user = $users | Where-Object { $_.Id -eq $roleMember.Id };

                # If user is null.
                if ($null -eq $user)
                {
                    # Continue to next role member.
                    continue;
                }

                # If user is not already in the list.
                if ($usersWithAdminRoles -notcontains $user)
                {
                    # Cloud native.
                    [bool]$cloudOnly = $false;

                    # If the user is cloud only.
                    if ($null -eq $user.OnPremisesSyncEnabled)
                    {
                        # Set cloud only to true.
                        $cloudOnly = $true;
                    }

                    # Write to log.
                    Write-Log -Category "User" -Message ("User '{0}' have the role '{1}'" -f $user.UserPrincipalName, $role.DisplayName) -Level Debug;

                    # Add user to list.
                    $usersWithAdminRoles += [PSCustomObject]@{
                        Id                = $user.Id;
                        DisplayName       = $user.DisplayName;
                        UserPrincipalName = $user.UserPrincipalName;
                        CloudOnly         = $cloudOnly;
                        RoleDisplayName   = $role.DisplayName;
                        RoleId            = $role.Id;
                    };
                }
            }
        }
    }
    END
    {
        # Return users with admin roles.
        return $usersWithAdminRoles;
    }
}