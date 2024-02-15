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
        # Dates.
        $startDate = (Get-Date).AddMonths(-1);
        $endDate = Get-Date;
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Protection' -Message ('Getting self-service password reset activity report from the last month') -Level Debug;

        # Get audits.
        $auditReport = Get-MgAuditLogDirectoryAudit -Filter ("activityDateTime ge {0} and activityDateTime le {1} and loggedByService eq 'SSPR'" -f $startDate.ToString('yyyy-MM-ddTHH:mm:ss.fffZ'), $endDate.ToString('yyyy-MM-ddTHH:mm:ss.fffZ'));
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($auditReport.Count -gt 0)
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
        $review.Data = $auditReport;
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    }
}