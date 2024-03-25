function Invoke-ReviewEntraApplicationUsageReport
{
    <#
    .SYNOPSIS
        Review the Application Usage report.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Beta.Reports
    .EXAMPLE
        Invoke-ReviewEntraApplicationUsageReport;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Identity' -Message ('Getting application usage report') -Level Debug;

        # Get application sign-in report.
        $applicationSignInSummary = Get-MgBetaReportAzureAdApplicationSignInSummary -Period 'D7';
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($applicationSignInSummary.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '95d55daa-d432-44f5-907a-eda61b57696f';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity';
        $review.Title = 'Ensure the Application Usage report is reviewed at least weekly';
        $review.Data = $applicationSignInSummary | Select-Object Id, AppDisplayName, FailedSignInCount, SuccessfulSignInCount, SuccessPercentage;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}