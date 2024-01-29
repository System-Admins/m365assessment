function Invoke-ReviewUnifiedAuditLogIsEnabled
{
    <#
    .SYNOPSIS
        Check if unified audit log is enabled or disabled.
    .DESCRIPTION
        Return true or false based on the feature setting.
    .EXAMPLE
        Invoke-ReviewUnifiedAuditLogIsEnabled;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        
    }
    PROCESS
    {
        # Get the unified audit log configuration.
        $adminAuditLogConfig = Get-AdminAuditLogConfig;
    }
    END
    {
        # Return setting.
        return [bool]$adminAuditLogConfig.UnifiedAuditLogIngestionEnabled;
    }
}