function Invoke-ReviewEntraAccessReviewGuestUsers
{
    <#
    .SYNOPSIS
        If 'Access reviews' for Guest Users are configured.
    .DESCRIPTION
        Return true if configured correctly, otherwise false.
    .EXAMPLE
        Invoke-ReviewEntraAccessReviewGuestUsers;
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
        $uri = ('https://api.accessreviews.identitygovernance.azure.com/accessReviews/v2.0/approvalWorkflowProviders/D5EC9F3B-324E-4F8A-AF55-B69EDD48ECBE/requests?$count=true&$orderby=createdDateTime%20desc&$skip=0&$top=10&$select=id,businessFlowId,decisionsCriteria,reviewedEntity,businessFlowTemplateId,policy,settings,errors,displayName,status,createdDateTime&$filter=((customDataProvider%20eq%20null))&x-tenantid={0}' -f $directoryId);
    }
    PROCESS
    {
        # Invoke the API.
        $accessReviews = Invoke-EntraIdAccessReviewApi -Uri $uri -Method 'GET';
        
        # Foreach access review.
        foreach ($accessReview in $accessReviews)
        {
            # Bool to keep track of single access review.
            [bool]$configuredCorrectly = $true;

            # 
            $accessReview.policy.decisionMakerCriteria
        }
    }
    END
    {
        
    }
}