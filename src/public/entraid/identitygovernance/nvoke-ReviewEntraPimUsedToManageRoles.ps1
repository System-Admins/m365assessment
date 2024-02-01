function Invoke-ReviewEntraPimUsedToManageRoles
{
    <#
    .SYNOPSIS
        If 'Privileged Identity Management' is used to manage roles.
    .DESCRIPTION
        Return true or false.
    .EXAMPLE
        Invoke-ReviewEntraPimUsedToManageRoles;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get directory id.
        $directoryId = (Get-AzContext).Tenant.Id;

        # URI.
        $uri = ('https://api.azrbac.mspim.azure.com/api/v2/privilegedAccess/aadroles/resources/{0}/roleDefinitions?$select=id,displayName,type,templateId,resourceId,externalId,isbuiltIn,subjectCount,eligibleAssignmentCount,activeAssignmentCount&$orderby=displayName' -f $directoryId);

        # Roles that should be eligible and not permanent.
        $shouldBeEligible = @(
            'Application Administrator',
            'Authentication Administrator',
            'Billing Administrator',
            'Cloud Application Administrator',
            'Cloud Device Administrator',
            'Compliance Administrator',
            'Customer LockBox Access Approver',
            'Device Administrators',
            'Exchange Administrators',
            'Global Administrators',
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
        $pimRbacRoles | select displayName, activeAssignmentCount;
        
        # Foreach rbac role.
        foreach ($pimRbacRole in $pimRbacRoles)
        {
            # If role is not in the list of roles that should be eligible and not permanent.
            if ($shouldBeEligible -notcontains $pimRbacRole.displayName)
            {
                # Skip.
                continue;
            }

            # Construct active assignments URI.
            $activeAssignmentsUri = ('https://api.azrbac.mspim.azure.com/api/v2/privilegedAccess/aadroles/roleAssignments?$expand=linkedEligibleRoleAssignment,subject,scopedResource,roleDefinition($expand=resource)&$count=true&$filter=(roleDefinition/resource/id%20eq%20%27d8b1b73e-e147-4d6f-b7e4-cf68b59c7224%27)+and+(roleDefinition/id%20eq%20%2762e90394-69f5-4237-9190-012177145e10%27)+and+(assignmentState%20eq%20%27Active%27)&$orderby=roleDefinition/displayName&$skip=0&$top=10' -f $directoryId, $pimRbacRole.id);

            # Get the role active assignments.
            $activeAssignments = 

        }
    }
    END
    {
       
    }
}