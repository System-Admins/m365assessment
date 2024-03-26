function Invoke-ReviewPurviewUserRoleGroupChange
{
    <#
    .SYNOPSIS
        Review user role group changes are reviewed.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewPurviewUserRoleGroupChange;
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
        Write-Log -Category 'Microsoft Purview' -Subcategory 'Audit' -Message 'Getting user role group changes' -Level Debug;

        # Search between the following dates.
        $startDate = ((Get-Date).AddDays(-7)).ToUniversalTime().ToString('yyyy/MM/dd HH:mm:ss');
        $endDate = (Get-Date).ToUniversalTime().ToString('yyyy/MM/dd HH:mm:ss');

        # Operations to monitor.
        $operations = @(
            'Add member to role.'
        );

        # Write to log.
        Write-Log -Category 'Microsoft Defender' -Subcategory 'Audit' -Message ("Getting user role group changes within start date '{0}' and end date '{1}'" -f $startDate, $endDate) -Level Debug;

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
        $review.Id = '6fe596b2-1ee0-46e1-9dba-316d1888d016';
        $review.Category = 'Microsoft Purview';
        $review.Subcategory = 'Audit';
        $review.Title = 'Ensure user role group changes are reviewed at least weekly';
        $review.Data = $auditLogs | Select-Object RecordType, CreationDate, UserIds, Operations, Identity;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}