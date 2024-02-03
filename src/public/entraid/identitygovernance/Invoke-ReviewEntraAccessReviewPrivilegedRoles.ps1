function Invoke-ReviewEntraAccessReviewPrivilegedRoles
{
    <#
    .SYNOPSIS
        If 'Access reviews' for high privileged Azure AD roles are configured.
    .DESCRIPTION
        Returns list of missing access reviews for privileged roles.
    .EXAMPLE
        Invoke-ReviewEntraAccessReviewPrivilegedRoles;
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
        $uri = ('https://api.accessreviews.identitygovernance.azure.com/accessReviews/v2.0/approvalWorkflowProviders/0A7B9F79-7FF3-4663-AC01-0222A72F8C02/requests?$count=true&$orderby=startDateTime%20desc&$skip=0&$top=10&$select=id,businessFlowId,decisionsCriteria,reviewedEntity,businessFlowTemplateId,policy,settings,errors,displayName,createdBy,startDateTime,endDateTime,status&$filter=(status%20eq%20%27NotStarted%27%20and%20status%20eq%20%27Starting%27%20and%20status%20eq%20%27InProgress%27%20and%20status%20eq%20%27Completed%27%20and%20status%20eq%20%27Applied%27%20and%20status%20eq%20%27Initializing%27%20and%20status%20eq%20%27AutoReviewing%27%20and%20status%20eq%20%27AutoReviewed%27%20and%20status%20eq%20%27Applying%27%20and%20status%20eq%20%27Completing%27%20and%20status%20eq%20%27Failed%27)&x-tenantid={0}' -f $directoryId);

        # Roles to review.
        $roles = @('Global Administrator', 'SharePoint Administrator', 'Teams Administrator', 'Security Administrator', 'Exchange Administrator');

        # List of missing access reviews.
        $configuredAccessReviews = @();
    }
    PROCESS
    {
        # Invoke the API.
        $accessReviews = Invoke-EntraIdAccessReviewApi -Uri $uri -Method 'GET';
        
        # Foreach access review.
        foreach ($accessReview in $accessReviews.value)
        {
            # If the role is not in the predefined list.
            if ($roles -notcontains ($accessReview.decisionsCriteria)[0].roleDisplayName)
            {
                
                # Skip this access review.
                continue;
            }

            # If the access is reviewed weekly or monthly.
            if($accessReview.settings.recurrenceSettings.recurrenceType -eq 'Weekly' -or $accessReview.settings.recurrenceSettings.recurrenceType -eq 'Monthly')
            {
                # Add to the list of missing access reviews.
                $configuredAccessReviews += ($accessReview.decisionsCriteria)[0].roleDisplayName;
            }
        }
    }
    END
    {
        
        # Get difference between predefined roles and configured access reviews.
        $missingAccessReviews = $roles | Where-Object {$_ -notin $configuredAccessReviews};

        # Return the result.
        return $missingAccessReviews;
    }
}

