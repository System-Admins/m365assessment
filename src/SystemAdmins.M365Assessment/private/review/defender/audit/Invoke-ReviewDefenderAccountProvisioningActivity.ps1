function Invoke-ReviewDefenderAccountProvisioningActivity
{
    <#
    .SYNOPSIS
        Review the Account Provisioning Activity report.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewDefenderAccountProvisioningActivity;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Search between the following dates.
        $startDate = ((Get-Date).AddDays(-7)).ToUniversalTime().ToString('yyyy/MM/dd HH:mm:sz');
        $endDate = (Get-Date).ToUniversalTime().ToString('yyyy/MM/dd HH:mm:sz');

        # Operations to monitor.
        $operations = @(
            'Add user.',
            'Change user license.',
            'Change user password.',
            'Delete user.',
            'Reset user password.',
            'Set force change user password.',
            'Set license properties.',
            'Update user.'
        );
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'Microsoft Defender' -Subcategory 'Audit' -Message ("Getting account provisioning activity with start date '{0}' and end date '{1}'" -f $startDate, $endDate) -Level Debug;

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
        $review.Id = '3483e87b-6069-4355-928f-dc9be4e31902';
        $review.Category = 'Microsoft 365 Defender';
        $review.Subcategory = 'Audit';
        $review.Title = 'Ensure the Account Provisioning Activity report is reviewed at least weekly';
        $review.Data = $auditLogs;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}

