function Invoke-ReviewEntraApplicationUsageReport
{
    <#
    .SYNOPSIS
        Review the Application Usage report.
    .DESCRIPTION
        Return a list of applications and the sign-in.
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
        # Get application sign-in report.
        $applicationSignInSummary = Get-MgBetaReportAzureAdApplicationSignInSummary -Period 'D30';
    }
    END
    {
        # Return results.
        return $applicationSignInSummary;
    }
}