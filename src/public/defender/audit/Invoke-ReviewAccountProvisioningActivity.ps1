function Invoke-ReviewAccountProvisioningActivity
{
    <#
    .SYNOPSIS
        Review the Account Provisioning Activity report.
    .DESCRIPTION
        Get account provisioning activity report details.
    .EXAMPLE
        Invoke-ReviewAccountProvisioningActivity;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Search betwen the following dates.
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
        # Search in the audit log.
        $auditLogs = Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate -Operations $operations;
    }
    END
    {
        # Return results.
        return $auditLogs;
    }
}

