function Invoke-ReviewEntraPimUsedToManageRoles
{
    <#
    .SYNOPSIS
        If 'Privileged Identity Management' is used to manage roles and if there is any permanent roles assigned.
    .DESCRIPTION
        Return list of active members of a role that only should be eligible instead of permanent.
    .EXAMPLE
        Invoke-ReviewEntraPimUsedToManageRoles;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get directory id.
        $directoryId = (Get-AzContext).Tenant.Id;

        # URI.
        $uri = ('https://api.azrbac.mspim.azure.com/api/v2/privilegedAccess/aadroles/resources/{0}/roleDefinitions?$select=id,displayName,type,templateId,resourceId,externalId,isbuiltIn,subjectCount,eligibleAssignmentCount,activeAssignmentCount&$orderby=displayName' -f $directoryId);

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

        # Object array to store the roles that is configured incorrectly.
        $incorrectlyConfigured = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Invoke the API.
        $pimRbacRoles = Invoke-EntraIdRbacApi -Uri $uri -Method 'GET';
        
        # Foreach rbac role.
        foreach ($pimRbacRole in $pimRbacRoles)
        {
            # Bool for being in the eligible list.
            [bool]$isInEligibleList = $false;

            # Foreach role in the eligible list.
            foreach ($shouldOnlyBeEligibleRole in $shouldOnlyBeEligibleRoles)
            {
                # If the role is in the eligible list.
                if ($pimRbacRole.displayName -eq $shouldOnlyBeEligibleRole)
                {
                    # Set bool to true.
                    $isInEligibleList = $true;
                }
            }

            # If the role is not in the eligible list.
            if ($isInEligibleList -eq $false)
            {
                # Write to log.
                Write-Log -Category 'Identity Governance' -Message ('The role "{0}" is not in the eligible list, skipping' -f $pimRbacRole.displayName) -Level Debug;

                # Skip.
                continue;
            }

            # If there is no active assignments.
            if ($pimRbacRole.activeAssignmentCount -eq 0)
            {
                # Write to log.
                Write-Log -Category 'Identity Governance' -Message ('The role "{0}" dont have any active assignments, skipping' -f $pimRbacRole.displayName) -Level Debug;

                # Skip.
                continue;
            }

            # Write to log.
            Write-Log -Category 'Identity Governance' -Message ('Getting active assignments for the role "{0}"' -f $pimRbacRole.displayName) -Level Debug;

            # Construct active assignments URI.
            $activeAssignmentsUri = ('https://api.azrbac.mspim.azure.com/api/v2/privilegedAccess/aadroles/roleAssignments?$expand=linkedEligibleRoleAssignment,subject,scopedResource,roleDefinition($expand=resource)&$count=true&$filter=(roleDefinition/resource/id%20eq%20%27{0}%27)+and+(roleDefinition/id%20eq%20%27{1}%27)+and+(assignmentState%20eq%20%27Active%27)&$orderby=roleDefinition/displayName&$skip=0&$top=10' -f $pimRbacRole.resourceId, $pimRbacRole.id);

            # Invoke the API again for active assignments.
            $activeAssignments = Invoke-EntraIdRbacApi -Uri $activeAssignmentsUri -Method 'GET';

            # Foreach active assignment.
            foreach ($activeAssignment in $activeAssignments)
            {
                # If the assignment is permanent.
                if ($activeAssignment.isPermanent -eq $true)
                {
                    # Write to log.
                    Write-Log -Category 'Identity Governance' -Message ("Member '{0}' is permanent for the role '{1}', should only be eligible" -f $activeAssignment.subject.principalName, $pimRbacRole.displayName) -Level Debug;
            
                    # Add to the list of incorrectly configured roles.
                    $incorrectlyConfigured += [PSCustomObject]@{
                        'RoleId'          = $pimRbacRole.id;
                        'RoleDisplayName' = $pimRbacRole.displayName;
                        'RoleType'        = $pimRbacRole.type;
                        'Member'          = $activeAssignment.subject.principalName;
                        'MemberType'      = $activeAssignment.memberType;
                        'IsPermanent'     = $activeAssignment.isPermanent;
                        'AssignmentState' = $activeAssignment.assignmentState;
                        'Type'            = $activeAssignment.subject.type;
                    };
                }
            }
        }
    }
    END
    {
        # Return the list of incorrectly configured roles.
        return $incorrectlyConfigured;
    }
}