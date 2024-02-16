function Invoke-ReviewDefenderNonGlobalAdminRoleAssignment
{
    <#
    .SYNOPSIS
        Review non-global administrator role group assignments.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewDefenderNonGlobalAdminRoleAssignment;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Search between the following dates.
        $startDate = ((Get-Date).AddDays(-14)).ToUniversalTime().ToString('yyyy/MM/dd HH:mm:ss');
        $endDate = (Get-Date).ToUniversalTime().ToString('yyyy/MM/dd HH:mm:ss');

        # Operations to monitor.
        $operations = @(
            'Add member to role.',
            'Remove member from role.'
        );
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'Microsoft Defender' -Subcategory 'Audit' -Message ("Getting non-global administrator role group assignments with start date '{0}' and end date '{1}'" -f $startDate, $endDate) -Level Debug;

        # Search in the audit log.
        $auditLogs = Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate -Operations $operations;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($auditLogs.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                               
        # Create new review object to return.
        [Review]$review = [Review]::new();
                       
        # Add to object.
        $review.Id = '8104752c-9e07-4a61-99a1-7161a792d76e';
        $review.Category = 'Microsoft 365 Defender';
        $review.Subcategory = 'Audit';
        $review.Title = 'Ensure non-global administrator role group assignments are reviewed at least weekly';
        $review.Data = $auditLogs;
        $review.Review = $reviewFlag;
        
        # Print result.
        $review.PrintResult();
                       
        # Return object.
        return $review;
    }
}
