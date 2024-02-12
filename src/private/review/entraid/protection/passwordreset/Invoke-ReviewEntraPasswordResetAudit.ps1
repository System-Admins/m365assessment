function Invoke-ReviewEntraPasswordResetAudit
{
    <#
    .SYNOPSIS
        Get the self-service password reset activity report.
    .DESCRIPTION
        Return list of password resets.
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
        # Get audits.
        $auditReport = Get-MgAuditLogDirectoryAudit -Filter ("activityDateTime ge {0} and activityDateTime le {1} and loggedByService eq 'SSPR'" -f $startDate.ToString('yyyy-MM-ddTHH:mm:ss.fffZ'), $endDate.ToString('yyyy-MM-ddTHH:mm:ss.fffZ'));
    }
    END
    {
        # Return audit report.
        return $auditReport;
    }
}