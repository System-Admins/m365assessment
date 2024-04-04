function Invoke-ReviewEntraAccessReviewPrivilegedRole
{
    <#
    .SYNOPSIS
        If 'Access reviews' for high privileged Azure AD roles are configured.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewEntraAccessReviewPrivilegedRole;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name;

        # Get directory id.
        $directoryId = (Get-AzContext).Tenant.Id;

        # URI.
        $uri = ('https://api.accessreviews.identitygovernance.azure.com/accessReviews/v2.0/approvalWorkflowProviders/0A7B9F79-7FF3-4663-AC01-0222A72F8C02/requests?$count=true&$orderby=startDateTime%20desc&$skip=0&$top=10&$select=id,businessFlowId,decisionsCriteria,reviewedEntity,businessFlowTemplateId,policy,settings,errors,displayName,createdBy,startDateTime,endDateTime,status&$filter=(status%20eq%20%27NotStarted%27%20and%20status%20eq%20%27Starting%27%20and%20status%20eq%20%27InProgress%27%20and%20status%20eq%20%27Completed%27%20and%20status%20eq%20%27Applied%27%20and%20status%20eq%20%27Initializing%27%20and%20status%20eq%20%27AutoReviewing%27%20and%20status%20eq%20%27AutoReviewed%27%20and%20status%20eq%20%27Applying%27%20and%20status%20eq%20%27Completing%27%20and%20status%20eq%20%27Failed%27)&x-tenantid={0}' -f $directoryId);

        # Roles to review.
        $roles = @('Global Administrator', 'SharePoint Administrator', 'Teams Administrator', 'Security Administrator', 'Exchange Administrator');

        # List of missing access reviews.
        $configuredAccessReviews = New-Object System.Collections.ArrayList;
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
            if ($accessReview.settings.recurrenceSettings.recurrenceType -eq 'Weekly' -or $accessReview.settings.recurrenceSettings.recurrenceType -eq 'Monthly')
            {
                # Add to the list of missing access reviews.
                $configuredAccessReviews += ($accessReview.decisionsCriteria)[0].roleDisplayName;
            }
        }

        # Get difference between predefined roles and configured access reviews.
        $missingAccessReviews = $roles | Where-Object { $_ -notin $configuredAccessReviews };
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($missingAccessReviews.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'e8c91221-63d2-4797-8a86-7ef53c30a9d6';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity Governance';
        $review.Title = "Ensure 'Access reviews' for high privileged Azure AD roles are configured";
        $review.Data = [PSCustomObject]@{
            NotConfigured = $missingAccessReviews -join ", ";
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand -Completed;

        # Return object.
        return $review;
    }
}

