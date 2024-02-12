function Invoke-ReviewDlpTeamsPolicyEnabled
{
    <#
    .SYNOPSIS
        Check if DLP policies are enabled for Microsoft Teams.
    .DESCRIPTION
        Return policies based on DLP policies is enabled for Microsoft Teams.
    .EXAMPLE
        Invoke-ReviewDlpTeamsPolicyEnabled;
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
        # Get only enabled DLP policies.
        $dlpPolicies = Get-DlpCompliancePolicy | Where-Object {$_.Mode -eq 'Enable' -and $_.Workload -like '*Teams*'};
    }
    END
    {
        # Return policies.
        return $dlpPolicies;
    }
}