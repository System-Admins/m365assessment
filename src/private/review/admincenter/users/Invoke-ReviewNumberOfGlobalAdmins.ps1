function Invoke-ReviewNumberOfGlobalAdmins
{
    <#
    .SYNOPSIS
        If there is between two and four global admins are designated.
    .DESCRIPTION
        Return object with a valid flag and number of global admins.
    .EXAMPLE
        Invoke-ReviewNumberOfGlobalAdmins;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get all users with admin roles.
        $usersWithAdminRole = Get-EntraIdUserAdminRole;

        # Global admin threshold.
        $minimumThreshold = 2;
        $maximumThreshold = 4;

        # Global admin counter.
        $globalAdminCounter = 0;
    }
    PROCESS
    {
        # Foreach user with admin role.
        foreach ($userWithAdminRole in $usersWithAdminRole)
        {
            # If user is global admin.
            if ($userWithAdminRole.RoleDisplayName -eq 'Global Administrator')
            {
                # Write to log.
                Write-Log -Category 'Entra ID' -Subcategory 'Role' -Message ("User '{0}' have the role '{1}'" -f $userWithAdminRole.UserPrincipalName, $userWithAdminRole.RoleDisplayName) -Level Debug;

                # Increment global admin counter.
                $globalAdminCounter++;
            }
        }
    }
    END
    {
        # Write to log.
        Write-Log -Category 'Entra ID' -Subcategory 'Role' -Message ('Found {0} with the role Global Administrator' -f $globalAdminCounter) -Level Debug;
                    
        # If the global admin counter is between the minimum and maximum threshold.
        if ($globalAdminCounter -ge $minimumThreshold -and $globalAdminCounter -le $maximumThreshold)
        {
            # Return object.
            return [PSCustomObject]@{
                Valid = $true;
                Count = $globalAdminCounter;
            };
        }
        else
        {
            # Return object.
            return [PSCustomObject]@{
                Valid = $false;
                Count = $globalAdminCounter;
            };
        }
    }
}