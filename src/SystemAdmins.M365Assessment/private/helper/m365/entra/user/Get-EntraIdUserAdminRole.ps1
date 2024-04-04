function Get-EntraIdUserAdminRole
{
    <#
    .SYNOPSIS
        Get users with admin roles.
    .DESCRIPTION
        Returns a list of users with admin roles.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Identity.DirectoryManagement
    .EXAMPLE
        Get-EntraIdUserAdminRole;
    #>
    [cmdletbinding()]
    [OutputType([System.Collections.ArrayList])]
    param
    (
    )

    BEGIN
    {
        # Object array to store users with admin roles.
        $usersWithAdminRoles = New-Object System.Collections.ArrayList;

        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'User' -Message ('Getting all users') -Level Verbose;

        # Get all users.
        $users = Get-MgUser -Property 'Id', 'DisplayName', 'UserPrincipalName', 'OnPremisesSyncEnabled', 'AccountEnabled' -All;

        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'User' -Message ('Getting all directory roles') -Level Verbose;

        # Get all roles.
        $roles = Get-MgDirectoryRole -All;
    }
    PROCESS
    {
        # Foreach role.
        foreach ($role in $roles)
        {
            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'User' -Message ("Getting members of role '{0}'" -f $role.DisplayName) -Level Verbose;

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
                    Write-CustomLog -Category 'Entra' -Subcategory 'User' -Message ("User '{0}' have the role '{1}'" -f $user.UserPrincipalName, $role.DisplayName) -Level Verbose;

                    # Add user to list.
                    $usersWithAdminRoles += [PSCustomObject]@{
                        Id                = $user.Id;
                        DisplayName       = $user.DisplayName;
                        UserPrincipalName = $user.UserPrincipalName;
                        CloudOnly         = $cloudOnly;
                        RoleDisplayName   = $role.DisplayName;
                        RoleId            = $role.Id;
                        AccountEnabled    = $user.AccountEnabled;
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