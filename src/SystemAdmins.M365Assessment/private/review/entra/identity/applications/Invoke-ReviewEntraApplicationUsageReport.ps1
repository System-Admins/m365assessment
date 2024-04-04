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
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name;
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Identity' -Message ('Getting application usage report') -Level Verbose;

        # Get application sign-in report.
        $applicationSignInSummary = Get-MgBetaReportAzureAdApplicationSignInSummary -Period 'D7';

        # If application sign-in summary is not empty.
        if ($applicationSignInSummary.Count -gt 0)
        {
            # Sort by failed sign-in count.
            $applicationSignInSummary = $applicationSignInSummary | Sort-Object -Property FailedSignInCount -Descending;
        }
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

        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}