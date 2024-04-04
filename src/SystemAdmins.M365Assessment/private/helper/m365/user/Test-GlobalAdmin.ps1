function Test-GlobalAdmin
{
    <#
    .SYNOPSIS
        Test if user is global administrator.
    .DESCRIPTION
        Return true or false.
    .EXAMPLE
        Test-GlobalAdmin;
    #>
    [cmdletbinding()]
    [OutputType([bool])]
    param
    (
    )
    BEGIN
    {
        # Get all roles for the logged in user.
        $userRoles = Get-UserRole;

        # Get context for user.
        $mgContext = (Get-MgContext);

        # Boolean to store if user is global admin.
        [bool]$isGlobalAdmin = $false;
    }
    PROCESS
    {
        # Foreach role.
        foreach ($userRole in $userRoles)
        {
            # If role is global admin.
            if ($userRole.roleTemplateId -eq '62e90394-69f5-4237-9190-012177145e10')
            {
                # Set flag.
                $isGlobalAdmin = $true;
            }
        }

        # If user is global admin.
        if ($isGlobalAdmin)
        {
            # Write to log.
            Write-CustomLog -Category 'User' -Message ("User '{0}' is global administrator" -f $mgContext.Account) -Level Verbose;
        }
        else
        {
            # Write to log.
            Write-CustomLog -Category 'User' -Message ("User '{0}' is not a global administrator" -f $mgContext.Account) -Level Verbose;
        }
    }
    END
    {
        # Return if global admin.
        return $isGlobalAdmin;
    }
}