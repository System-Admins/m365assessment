function Invoke-ReviewExoOutlookAddinsIsNotAllowedRolePolicy
{
    <#
    .SYNOPSIS
        Check if users installing Outlook add-ins is not allowed.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
         Invoke-ReviewExoOutlookAddinsIsNotAllowedRolePolicy;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Exchange Online' -Subcategory 'Roles' -Message 'Getting all mailboxes' -Level Debug;

        # Get all mailboxes.
        $mailboxes = Get-Mailbox -ResultSize Unlimited;

        # List of mailboxes with Outlook add-ins enabled.
        $roleAssignmentPolicies = New-Object System.Collections.ArrayList;

        # Role assignment policies used.
        $usedRoleAssignmentPolicies = New-Object System.Collections.ArrayList;

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
            if ($usedRoleAssignmentPolicies -notcontains $mailbox.RoleAssignmentPolicy)
            {
                # Write to log.
                Write-Log -Category 'Exchange Online' -Subcategory 'Roles' -Message ("Role assignment policy '{0}' is used in the organization" -f $mailbox.RoleAssignmentPolicy) -Level Debug;

                # Add to list.
                $null = $usedRoleAssignmentPolicies.Add($mailbox.RoleAssignmentPolicy);
            }
        }

        # Foreach role assignment policy used.
        foreach ($usedRoleAssignmentPolicy in $usedRoleAssignmentPolicies)
        {
            # Get role assignment policy.
            $roleAssignmentPolicy = Get-RoleAssignmentPolicy -Identity $usedRoleAssignmentPolicy;

            # If there is not any assigned roles with Apps.
            if ($roleAssignmentPolicy.AssignedRoles -like '*My Custom Apps*' -or
                $roleAssignmentPolicy.AssignedRoles -like '*My Marketplace Apps*',
                $roleAssignmentPolicy.AssignedRoles -like '*My ReadWriteMailboxApps*')
            {
                # Write to log.
                Write-Log -Category 'Exchange Online' -Subcategory 'Roles' -Message ("Role assignment policy '{0}' allows users to install outlook add-ins" -f $roleAssignmentPolicy.Name) -Level Debug;
        
                # Add to list.
                $null = $roleAssignmentPolicies.Add($roleAssignmentPolicy);
            }
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($roleAssignmentPolicies.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                                     
        # Create new review object to return.
        [Review]$review = [Review]::new();
                                             
        # Add to object.
        $review.Id = '36ee88d3-0ab8-41ea-90e7-fd9b14ed6a03';
        $review.Category = 'Microsoft Exchange Admin Center';
        $review.Subcategory = 'Roles';
        $review.Title = "Ensure users installing Outlook add-ins is not allowed";
        $review.Data = $roleAssignmentPolicies | Select-Object -Property Name, @{Name='AssignedRoles';Expression={$_.AssignedRoles -join ', '}};
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    } 
}