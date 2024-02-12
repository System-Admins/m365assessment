function Invoke-ReviewNonGlobalAdminRoleAssignment
{
    <#
    .SYNOPSIS
        Review non-global administrator role group assignments.
    .DESCRIPTION
        Get role group assignment activities from the audit log.
    .EXAMPLE
        Invoke-ReviewNonGlobalAdminRoleAssignment;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Search betwen the following dates.
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
        # Search in the audit log.
        $auditLogs = Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate -Operations $operations;
    }
    END
    {
        # Return results.
        return $auditLogs;
    }
}
