function Invoke-ReviewPriorityAccounStrictPolicy
{
    <#
    .SYNOPSIS
        Review that priority accounts have 'Strict protection' presets applied.
    .DESCRIPTION
        Get all priority account and check if they have applied the strict proction policies.
    .EXAMPLE
        Invoke-ReviewPriorityAccounStrictPolicy;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get proctection policy rules.
        $eopProtectionPolicyRule = Get-EOPProtectionPolicyRule -Identity 'Strict Preset Security Policy';
        $atpProtectionPolicyRule = Get-ATPProtectionPolicyRule -Identity 'Strict Preset Security Policy';

        # Include / Exclude user lists object array to store who is member of the strict policies.
        $eopUsersInclude = New-Object System.Collections.ArrayList;
        $atpUsersInclude = New-Object System.Collections.ArrayList;
        $eopUsersExclude = New-Object System.Collections.ArrayList;
        $atpUsersExclude = New-Object System.Collections.ArrayList;

        # Object array to store which users is not covered by the strict policies.
        $priorityUsersNotInStrictPolicy = New-Object System.Collections.ArrayList;

        # Get all priority users.
        $priorityUsers = Get-PriorityUsers;
    }
    PROCESS
    {
        # Foreach (include) eop user.
        foreach ($sentTo in $eopProtectionPolicyRule.SentTo)
        {
            # Add user to the list.
            $eopUsersInclude.Add($sentTo) | Out-Null;
        }

        # Foreach (exclude) eop user.
        foreach ($sentTo in $eopProtectionPolicyRule.ExceptIfSentTo)
        {
            # Add user to the list.
            $eopUsersExclude.Add($sentTo) | Out-Null;
        }

        # Foreach (include) eop group.
        foreach ($group in $eopProtectionPolicyRule.SentToMemberOf)
        {
            # Get group.
            $group = Get-MgGroup -Filter ("Mail eq '{0}'" -f $group);

            # If group is null.
            if ($null -eq $group)
            {
                # Skip.
                continue;
            }

            # Get group members.
            $groupMembers = Get-GroupMemberTransitive -Id $group.Id;
            
            # Foreach group member.
            foreach ($groupMember in $groupMembers)
            {
                # Add group member to the list.
                $eopUsersInclude.Add($groupMember.userPrincipalName) | Out-Null;
            }
        }

        # Foreach (exclude) eop group.
        foreach ($group in $eopProtectionPolicyRule.ExceptIfSentToMemberOf)
        {
            # Get group.
            $group = Get-MgGroup -Filter ("Mail eq '{0}'" -f $group);

            # If group is null.
            if ($null -eq $group)
            {
                # Skip.
                continue;
            }

            # Get group members.
            $groupMembers = Get-GroupMemberTransitive -Id $group.Id;
            
            # Foreach group member.
            foreach ($groupMember in $groupMembers)
            {
                # Add group member to the list.
                $eopUsersExclude.Add($groupMember.userPrincipalName) | Out-Null;
            }
        }

        # Foreach (include) atp user.
        foreach ($sentTo in $atpProtectionPolicyRule.SentTo)
        {
            # Add user to the list.
            $atpUsersInclude.Add($sentTo) | Out-Null;
        }

        # Foreach (exclude) atp user.
        foreach ($sentTo in $atpProtectionPolicyRule.ExceptIfSentTo)
        {
            # Add user to the list.
            $atpUsersExclude.Add($sentTo) | Out-Null;
        }

        # Foreach (include) atp group.
        foreach ($group in $atpProtectionPolicyRule.SentToMemberOf)
        {
            # Get group.
            $group = Get-MgGroup -Filter ("Mail eq '{0}'" -f $group);
        
            # If group is null.
            if ($null -eq $group)
            {
                # Skip.
                continue;
            }
        
            # Get group members.
            $groupMembers = Get-GroupMemberTransitive -Id $group.Id;
                    
            # Foreach group member.
            foreach ($groupMember in $groupMembers)
            {
                # Add group member to the list.
                $atpUsersInclude.Add($groupMember.userPrincipalName) | Out-Null;
            }
        }
        
        # Foreach (exclude) atp group.
        foreach ($group in $atpProtectionPolicyRule.ExceptIfSentToMemberOf)
        {
            # Get group.
            $group = Get-MgGroup -Filter ("Mail eq '{0}'" -f $group);
        
            # If group is null.
            if ($null -eq $group)
            {
                # Skip.
                continue;
            }
        
            # Get group members.
            $groupMembers = Get-GroupMemberTransitive -Id $group.Id;
                    
            # Foreach group member.
            foreach ($groupMember in $groupMembers)
            {
                # Add group member to the list.
                $atpUsersExclude.Add($groupMember.userPrincipalName);
            }
        }

        # Remove duplicate users.
        $eopUsersInclude = $eopUsersInclude | Select-Object -Unique;
        $atpUsersInclude = $atpUsersInclude | Select-Object -Unique;
        $eopUsersExclude = $eopUsersExclude | Select-Object -Unique;
        $atpUsersExclude = $atpUsersExclude | Select-Object -Unique;

        # Foreach priority user.
        foreach ($priorityUser in $priorityUsers)
        {
            # Boolean if the user is protected by the strict policy.
            [bool]$protectedByStrictPolicy = $true;

            # If the user is not in the EOP include list.
            if ($eopUsersInclude -notcontains $priorityUser)
            {
                # Set boolean to false.
                $protectedByStrictPolicy = $false;
            }

            # If the user is in the EOP exclude list.
            if ($eopUsersExclude -contains $priorityUser)
            {
                # Set boolean to false.
                $protectedByStrictPolicy = $false;
            }

            # If the user is not in the ATP include list.
            if ($atpUsersInclude -notcontains $priorityUser)
            {
                # Set boolean to false.
                $protectedByStrictPolicy = $false;
            }

            # If the user is in the ATP exclude list.
            if ($atpUsersExclude -contains $priorityUser)
            {
                # Set boolean to false.
                $protectedByStrictPolicy = $false;
            }

            # If the user is not protected by the strict policy.
            if ($false -eq $protectedByStrictPolicy)
            {
                # Add user to the list.
                $priorityUsersNotInStrictPolicy.Add($priorityUser) | Out-Null;
            }
        }
    }
    END
    {
        # Return the users not in the strict policy.
        return $priorityUsersNotInStrictPolicy;
    }
}