function Get-UserRole
{
    <#
    .SYNOPSIS
        Get roles of logged in user.
    .DESCRIPTION
        Returns all roles of the logged in user.
    .EXAMPLE
        Get-UserRole;
    #>
    [cmdletbinding()]
    param
    (
    )
    BEGIN
    {
        # URL.
        [string]$uri = 'https://graph.microsoft.com/v1.0/me/memberOf';

        # Object array to store user roles.
        $userRoles = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Try to invoke API.
        try
        {
            # Write to log.
            Write-CustomLog -Category 'User' -Message "Getting all 'member of' for logged in user" -Level Verbose;

            # Invoke Microsoft Graph API.
            $response = Invoke-MgGraphRequest -Uri $uri -Method Get -ErrorAction Stop;
        }
        catch
        {
            # Write to log.
            Write-CustomLog -Category 'User' -Message "Failed to get 'member of' for logged in user" -Level Verbose;

            # Throw error.
            throw ($_);
        }

        # Foreach role.
        foreach ($memberOf in $response.Value)
        {
            # If the type is not a role.
            if ($memberOf['@odata.type'] -ne '#microsoft.graph.directoryRole')
            {
                # Skip.
                continue;
            }

            # Add to object array.
            $userRoles += [PSCustomObject]@{
                id             = $memberOf.id;
                roleTemplateId = $memberOf.roleTemplateId;
                displayName    = $memberOf.displayName;
                description    = $memberOf.description;
            };
        }
    }
    END
    {
        # Return the value.
        return $userRoles;
    }
}