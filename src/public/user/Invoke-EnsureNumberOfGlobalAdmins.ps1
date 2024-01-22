function Invoke-EnsureNumberOfGlobalAdmins
{
    <#
    .SYNOPSIS
        Check if the number of global admin is sufficent.
    .DESCRIPTION
        The best practice is to have at least 2 and at most 4 global admins.
        Return true or false.
    .EXAMPLE
        # Check if the number of global admin is sufficent.
        Invoke-EnsureNumberOfGlobalAdmins;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get all users with admin roles.
        $usersWithAdminRole = Get-UsersWithAdminRole;

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
                # Increment global admin counter.
                $globalAdminCounter++;
            }
        }
    }
    END
    {
        # If the global admin counter is between the minimum and maximum threshold.
        if ($globalAdminCounter -ge $minimumThreshold -and $globalAdminCounter -le $maximumThreshold)
        {
            # Return true.
            return $true;
        }
        else
        {
            # Return false.
            return $false;
        }
    }
}