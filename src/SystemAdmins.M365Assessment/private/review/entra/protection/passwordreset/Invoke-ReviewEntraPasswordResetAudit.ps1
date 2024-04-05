function Invoke-ReviewEntraPasswordResetAudit
{
    <#
    .SYNOPSIS
        Get the self-service password reset activity report.
    .DESCRIPTION
        Return list of password resets.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Reports
    .EXAMPLE
        Invoke-ReviewEntraPasswordResetAudit;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # Dates.
        $startDate = (Get-Date).AddDays(-7);
        $endDate = Get-Date;

        # Uri.
        $uri = ("https://graph.microsoft.com/v1.0/auditLogs/directoryAudits?`$filter=(activityDateTime ge {0} and activityDateTime le {1} and loggedByService eq 'SSPR')&`$top=50&`$orderby=activityDateTime desc" -f $startDate.ToString('yyyy-MM-ddTHH:mm:ss.fffZ', [CultureInfo]::InvariantCulture), $endDate.ToString('yyyy-MM-ddTHH:mm:ss.fffZ', [CultureInfo]::InvariantCulture));
    }
    PROCESS
    {
        # Try to get the report.
        try
        {
            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'Protection' -Message ('Getting self-service password reset activity report from the last week') -Level Verbose;

            # Invoke Microsoft Graph API.
            $auditReport = Invoke-MgGraphRequest -Uri $uri -Method Get -ErrorAction Stop -OutputType PSObject;

            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'Protection' -Message ('Successfully got self-service password reset activity report') -Level Verbose;
        }
        # Something went wrong.
        catch
        {
            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'Protection' -Message ('Failed to get self-service password reset activity report') -Level Verbose;

            # Return.
            return;
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($auditReport.value.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '9141c4a0-0323-4aa3-abb5-e6a0a2bedffa';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Protection';
        $review.Title = 'Ensure the self-service password reset activity report is reviewed at least weekly';
        $review.Data = $auditReport.value | Select-Object ActivityDateTime, LoggedByService, Category, ActivityDisplayName, Result, ResultReason, @{Name = 'UserPrincipalName'; Expression = { $_.targetResources.UserPrincipalName } };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}