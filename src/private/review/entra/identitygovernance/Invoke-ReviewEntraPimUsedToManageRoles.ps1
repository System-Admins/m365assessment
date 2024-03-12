function Invoke-ReviewEntraPimUsedToManageRoles
{
    <#
    .SYNOPSIS
        If 'Privileged Identity Management' is used to manage roles and if there is any permanent roles assigned.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewEntraPimUsedToManageRoles;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get all role definitions.
        $directoryRoleDefinitions = Get-MgRoleManagementDirectoryRoleDefinition -All;

        # Get all role eligibility schedule instances.
        $roleEligibilityScheduleInstances = Get-MgRoleManagementDirectoryRoleEligibilityScheduleInstance -ExpandProperty '*' -All;

        # Get all role active assignments.
        $roleAssignmentScheduleInstances = Get-MgRoleManagementDirectoryRoleAssignmentScheduleInstance -ExpandProperty '*' -All;

        # Roles that should be eligible and not permanent.
        $shouldOnlyBeEligibleRoles = @(
            'Application Administrator',
            'Authentication Administrator',
            'Billing Administrator',
            'Cloud Application Administrator',
            'Cloud Device Administrator',
            'Compliance Administrator',
            'Customer LockBox Access Approver',
            'Device Administrators',
            'Exchange Administrator',
            'Global Administrator',
            'HelpDesk Administrator',
            'Information Protection Administrator',
            'Intune Service Administrator',
            'Kaizala Administrator',
            'License Administrator',
            'Password Administrator',
            'PowerBI Service Administrator',
            'Privileged Authentication Administrator',
            'Privileged Role Administrator',
            'Security Administrator',
            'SharePoint Service Administrator',
            'Skype for Business Administrator',
            'Teams Service Administrator',
            'User Administrator'
        );

        # Object array for roles eligible and active assignments.
        $roles = @();

        # Object array to store the roles that is configured incorrectly.
        $incorrectlyConfigured = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach role definition.
        foreach ($directoryRoleDefinition in $directoryRoleDefinitions)
        {
            # Object arrays for eligible and active assignments.
            $eligibleAssignments = @();
            $activeAssignments = @();

            # Foreach role eligibility schedule instance.
            foreach ($roleEligibilityScheduleInstance in $roleEligibilityScheduleInstances)
            {
                # If the role definition id matches the role id of the role eligibility schedule instance.
                if ($directoryRoleDefinition.Id -eq $roleEligibilityScheduleInstance.RoleDefinitionId)
                {
                    # Assignment.
                    [string]$assignmentType = '';
            
                    # If the role eligibility schedule instance is eligible.
                    if ($null -ne $roleEligibilityScheduleInstance.EndDateTime)
                    {
                        # Set to eligible.
                        $assignmentType = 'Eligible';
                    }
                    # Else the assignment is permanent.
                    else
                    {
                        # Set to permanent.
                        $assignmentType = 'Permanent';
                    }

                    # Add to eligible assignments.
                    $eligibleAssignments += [PSCustomObject]@{
                        displayName   = $roleEligibilityScheduleInstance.Principal.AdditionalProperties.displayName;
                        startDateTime = $roleEligibilityScheduleInstance.StartDateTime;
                        endDateTime   = $roleEligibilityScheduleInstance.EndDateTime;
                        memberType    = $roleEligibilityScheduleInstance.MemberType;
                        roleName      = $roleEligibilityScheduleInstance.RoleDefinition.DisplayName;
                        roleID        = $roleEligibilityScheduleInstance.RoleDefinition.Id;
                        assignment    = $assignmentType;
                    };
                }
            }

            # Foreach role assignment schedule instance.
            foreach ($roleAssignmentScheduleInstance in $roleAssignmentScheduleInstances)
            {
                # If the role definition id matches the role id of the role assignment schedule instance.
                if ($directoryRoleDefinition.Id -eq $roleAssignmentScheduleInstance.RoleDefinitionId)
                {
                    # Assignment.
                    [string]$assignmentType = '';
            
                    # If the role assignment schedule instance is eligible.
                    if ($null -ne $roleAssignmentScheduleInstance.EndDateTime)
                    {
                        # Set to eligible.
                        $assignmentType = 'Eligible';
                    }
                    # Else the assignment is permanent.
                    else
                    {
                        # Set to permanent.
                        $assignmentType = 'Permanent';
                    }

                    # Add to active assignments.
                    $activeAssignments += [PSCustomObject]@{
                        displayName = $roleAssignmentScheduleInstance.Principal.AdditionalProperties.displayName;
                        memberType  = $roleAssignmentScheduleInstance.MemberType;
                        roleName    = $roleAssignmentScheduleInstance.RoleDefinition.DisplayName;
                        roleID      = $roleAssignmentScheduleInstance.RoleDefinition.Id;
                        assignment  = $assignmentType;
                        state       = $roleAssignmentScheduleInstance.AssignmentType;
                    };
                }
            }

            # Add to roles.
            $roles += [PSCustomObject]@{
                roleName            = $directoryRoleDefinition.DisplayName;
                roleID              = $directoryRoleDefinition.Id;
                eligibleAssignments = $eligibleAssignments;
                eligibleCount       = $eligibleAssignments.Count;
                activeAssignments   = $activeAssignments;
                activeCount         = $activeAssignments.Count;
            };
        }

        # Foreach role that only should be eligible.
        foreach ($shouldOnlyBeEligibleRole in $shouldOnlyBeEligibleRoles)
        {
            # Foreach role.
            foreach ($role in $roles)
            {
                # If the role name matches the role that only should be eligible.
                if ($role.roleName -eq $shouldOnlyBeEligibleRole)
                {
                    # If the role has active assignments.
                    if ($role.activeCount -gt 0)
                    {
                        # If already in object array.
                        if ($incorrectlyConfigured -notcontains $shouldOnlyBeEligibleRole)
                        {
                            # Add to incorrectly configured.
                            $null = $incorrectlyConfigured.Add($shouldOnlyBeEligibleRole);
                        }
                    }
                }
            }
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($incorrectlyConfigured.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                                     
        # Create new review object to return.
        [Review]$review = [Review]::new();
                                             
        # Add to object.
        $review.Id = '99dcdd37-60f6-450e-be03-13a85fcc5776';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity Governance';
        $review.Title = "Ensure 'Privileged Identity Management' is used to manage roles";
        $review.Data = $roles | Select-Object roleID, roleName, eligibleCount, activeCount;
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    }
}