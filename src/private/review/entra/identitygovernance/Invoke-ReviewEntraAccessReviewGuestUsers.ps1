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

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get directory id.
        $directoryId = (Get-AzContext).Tenant.Id;

        # URI.
        $uri = ('https://api.accessreviews.identitygovernance.azure.com/accessReviews/v2.0/approvalWorkflowProviders/D5EC9F3B-324E-4F8A-AF55-B69EDD48ECBE/requests?$count=true&$orderby=createdDateTime%20desc&$skip=0&$top=10&$select=id,businessFlowId,decisionsCriteria,reviewedEntity,businessFlowTemplateId,policy,settings,errors,displayName,status,createdDateTime&$filter=((customDataProvider%20eq%20null))&x-tenantid={0}' -f $directoryId);

        # Bool for valid access review configuration.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # Invoke the API.
        $accessReviews = Invoke-EntraIdAccessReviewApi -Uri $uri -Method 'GET';
        
        # Foreach access review.
        foreach ($accessReview in $accessReviews.value)
        {
            # Bool for valid access review.
            [bool]$guestOnly = $false;
            [bool]$reviewersNotGuest = $true;
            [bool]$reviewSchedule = $true;
            [bool]$autoApply = $true;
            [bool]$reviewerRemoveNoRespond = $true;

            # Construct URI for the access reviewers.
            $accessReviewersUri = ('https://api.accessreviews.identitygovernance.azure.com/accessReviews/v2.0/approvalWorkflowProviders/D5EC9F3B-324E-4F8A-AF55-B69EDD48ECBE/requests/{0}?x-tenantid={1}' -f $accessReview.id, $directoryId);

            # Invoke the API.
            $accessReviewers = Invoke-EntraIdAccessReviewApi -Uri $accessReviewersUri -Method 'GET';

            # Foreach reviewer.
            foreach ($accessReviewer in $accessReviewers.policy.decisionMakerCriteria)
            {
                # Get user from Entra ID.
                $user = Get-MgUser -UserId $accessReviewer.userId -Property UserType;

                # If user is a guest.
                if ($user.UserType -eq 'Guest')
                {
                    # Write to log.
                    Write-Log -Category 'Identity Governance' -Message ('User "{0}" is a guest' -f $accessReviewer.userId) -Level Debug;

                    # Set guest only to true.
                    $reviewersNotGuest = $false;
                }
            }

            # Foreach decision criteria.
            foreach ($decisionCriteria in $accessReview.decisionsCriteria)
            {
                # If decision criteria is guest.
                if ($decisionCriteria.guestUsersOnly -eq $true)
                {
                    # Write to log.
                    Write-Log -Category 'Identity Governance' -Message ('Scope is set to "Guests Only"') -Level Debug;

                    # Set guest only to true.
                    $guestOnly = $true;
                }
            }

            # If review recurrence is not at least monthly or weekly
            if ($accessReview.settings.recurrenceSettings.recurrenceType -ne 'monthly' -and $accessReview.settings.recurrenceSettings.recurrenceType -ne 'Weekly')
            {
                # Write to log.
                Write-Log -Category 'Identity Governance' -Message ('Review schedule recurrence is not monthly or weekly') -Level Debug;

                # Set review schedule to false.
                $reviewSchedule = $false;
            }

            # If the access review end date is never.
            if ($accessReview.settings.recurrenceSettings.recurrenceEndType -ne 'never')
            {
                # Write to log.
                Write-Log -Category 'Identity Governance' -Message ('Review schedule end time is not set to "Never"') -Level Debug;

                # Set review schedule to false.
                $reviewSchedule = $false;
            }

            # If auto apply is not enabled.
            if ($accessReview.settings.autoApplyReviewResultsEnabled -eq $false)
            {
                # Write to log.
                Write-Log -Category 'Identity Governance' -Message ('Auto apply results to resource is not set') -Level Debug;

                # Set review schedule to false.
                $reviewSchedule = $false;
            }

            # If reviewers dont respond is not set to automatically remove access.
            if ($accessReview.settings.autoReviewSettings.notReviewedResult -ne 'Deny')
            {
                # Write to log.
                Write-Log -Category 'Identity Governance' -Message ('If reviewers dont respond is not automatically set to remove access') -Level Debug;

                # Set auto apply to false.
                $reviewerRemoveNoRespond = $false;
            }

            # If the conditions are met.
            if ($guestOnly -eq $true -and
                $reviewersNotGuest -eq $true -and
                $reviewSchedule -eq $true -and
                $autoApply -eq $true -and
                $reviewerRemoveNoRespond -eq $true)
            {
                # Write to log.
                Write-Log -Category 'Identity Governance' -Message ('Access reviews for Guest Users are configured correct') -Level Debug;

                # Set valid to true.
                $valid = $true;

                # Break the loop.
                break;
            }
        }
    }
    END
    {
        # Return the result.
        return $valid;
    }
}