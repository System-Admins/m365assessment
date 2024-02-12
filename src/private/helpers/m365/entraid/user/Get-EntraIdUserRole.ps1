function Get-EntraIdUserRole
{
    <#
    .SYNOPSIS
        Get current admin roles for current user.
    .DESCRIPTION
        Return list of Entra ID roles assigned to the logged in user.
    .NOTES
        Uses the following modules:
        - Microsoft.Graph.Users
        - Microsoft.Graph.Authentication
    .EXAMPLE
        Get-EntraIdUserRole;
    #>
    [CmdletBinding()]
    Param
    (
    )
    BEGIN
    {
        # Get Microsoft Graph context.
        $mgContext = Get-MgContext;

        # List to store roles.
        $roles = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Get user roles.
        $userMemberOf = Get-MgUserMemberOf -UserId $mgContext.account;

        # Foreach item.
        foreacH( $item in $userMemberOf )
        {
            # If item is not a role.
            if(($item.AdditionalProperties).'@odata.type' -ne '#microsoft.graph.directoryRole')
            {
                # Skip.
                continue;
            }

            # Variables.
            $roleTemplateId = ($item.AdditionalProperties).roleTemplateId;
            $roleDisplayName = ($item.AdditionalProperties).displayName;

            # Write to log.
            Write-Log -Category 'Authentication' -Message ("Account '{0}' have the role '{1}' ({2})" -f $mgContext.account, $roleDisplayName, $roleTemplateId) -Level Debug;

            # Add to list.
            $roles += [PSCustomObject]@{
                Account = $mgContext.account;
                RoleTemplateId = ($item.AdditionalProperties).roleTemplateId;
                DisplayName = ($item.AdditionalProperties).displayName;
            };
        }
    }
    END
    {
        # Return roles.
        return $roles;
    }
}