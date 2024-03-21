function Invoke-ReviewDefenderPriorityAccountStrictPolicy
{
    <#
    .SYNOPSIS
        Review that priority accounts have 'Strict protection' presets applied.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
        - Microsoft.Graph.Groups
    .EXAMPLE
        Invoke-ReviewDefenderPriorityAccountStrictPolicy;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Microsoft Defender' -Subcategory 'Settings' -Message 'Strict Preset Security Policies' -Level Debug;
        
        # Get protection policy rules.
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
        $priorityUsers = Get-EntraIdUserPriority;
    }
    PROCESS
    {
        # Foreach (include) eop user.
        foreach ($sentTo in $eopProtectionPolicyRule.SentTo)
        {
            # Add user to the list.
            $null = $eopUsersInclude.Add($sentTo);
        }

        # Foreach (exclude) eop user.
        foreach ($sentTo in $eopProtectionPolicyRule.ExceptIfSentTo)
        {
            # Add user to the list.
            $null = $eopUsersExclude.Add($sentTo);
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
            $groupMembers = Get-EntraIdGroupMemberTransitive -Id $group.Id;
            
            # Foreach group member.
            foreach ($groupMember in $groupMembers)
            {
                # Add group member to the list.
                $null = $eopUsersInclude.Add($groupMember.userPrincipalName);
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
            $groupMembers = Get-EntraIdGroupMemberTransitive -Id $group.Id;
            
            # Foreach group member.
            foreach ($groupMember in $groupMembers)
            {
                # Add group member to the list.
                $null = $eopUsersExclude.Add($groupMember.userPrincipalName);
            }
        }

        # Foreach (include) atp user.
        foreach ($sentTo in $atpProtectionPolicyRule.SentTo)
        {
            # Add user to the list.
            $null = $atpUsersInclude.Add($sentTo);
        }

        # Foreach (exclude) atp user.
        foreach ($sentTo in $atpProtectionPolicyRule.ExceptIfSentTo)
        {
            # Add user to the list.
            $null = $atpUsersExclude.Add($sentTo);
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
            $groupMembers = Get-EntraIdGroupMemberTransitive -Id $group.Id;
                    
            # Foreach group member.
            foreach ($groupMember in $groupMembers)
            {
                # Add group member to the list.
                $null = $atpUsersInclude.Add($groupMember.userPrincipalName);
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
            $groupMembers = Get-EntraIdGroupMemberTransitive -Id $group.Id;
                    
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
                # Write to log.
                Write-Log -Category 'Microsoft Defender' -Subcategory 'Settings' -Message ("Priority user '{0}' is not protected by the strict policy" -f $priorityUser) -Level Debug;

                # Add user to the list.
                $null = $priorityUsersNotInStrictPolicy.Add($priorityUser);
            }
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($priorityUsersNotInStrictPolicy.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                              
        # Create new review object to return.
        [Review]$review = [Review]::new();
                                      
        # Add to object.
        $review.Id = '9780f1b2-e2ea-4f6e-9bd9-7eb551b5d1e7';
        $review.Category = 'Microsoft 365 Defender';
        $review.Subcategory = 'Settings';
        $review.Title = "Ensure Priority accounts have 'Strict protection' presets applied";
        $review.Data = $priorityUsersNotInStrictPolicy;
        $review.Review = $reviewFlag;
                       
        # Print result.
        $review.PrintResult();
                                      
        # Return object.
        return $review;
    }
}