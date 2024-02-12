function Invoke-ReviewExoOutlookAddinsIsNotAllowedRolePolicy
{
    <#
    .SYNOPSIS
        Check if users installing Outlook add-ins is not allowed.
    .DESCRIPTION
        Return true if disabled otherwise false.
    .EXAMPLE
         Invoke-ReviewExoOutlookAddinsIsNotAllowedRolePolicy;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get all mailboxes.
        $mailboxes = Get-Mailbox -ResultSize Unlimited;

        # List of mailboxes with Outlook add-ins enabled.
        $roleAssignmentPolicies = New-Object System.Collections.ArrayList;

        # Role assignment policies used.
        $usedRoleAssignementPolicies = New-Object System.Collections.ArrayList;

    }
    PROCESS
    {
        # Foreach mailbox.
        foreach ($mailbox in $mailboxes)
        {
            # If role assignment policy is null.
            if ($null -eq $mailbox.RoleAssignmentPolicy)
            {
                # Skip.
                continue;
            }

            # If role assignment policy is not in list.
            if ($usedRoleAssignementPolicies -notcontains $mailbox.RoleAssignmentPolicy)
            {
                # Add to list.
                $usedRoleAssignementPolicies.Add($mailbox.RoleAssignmentPolicy) | Out-Null;
            }
        }

        # Foreach role assignment policy used.
        foreach ($usedRoleAssignementPolicy in $usedRoleAssignementPolicies)
        {
            # Get role assignment policy.
            $roleAssignmentPolicy = Get-RoleAssignmentPolicy -Identity $usedRoleAssignementPolicy;

            # If there is not any assigned roles with Apps.
            if ($roleAssignmentPolicy.AssignedRoles -like '*My Custom Apps*' -or
                $roleAssignmentPolicy.AssignedRoles -like '*My Marketplace Apps*',
                $roleAssignmentPolicy.AssignedRoles -like '*My ReadWriteMailboxApps*')
            {
                # Add to list.
                $roleAssignmentPolicies.Add($roleAssignmentPolicy) | Out-Null;
            }
        }
    }
    END
    {
        # Return object.
        return $roleAssignmentPolicies;
    } 
}