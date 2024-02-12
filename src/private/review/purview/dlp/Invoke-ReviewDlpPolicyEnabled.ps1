function Invoke-ReviewDlpPolicyEnabled
{
    <#
    .SYNOPSIS
        Check if DLP policies are enabled.
    .DESCRIPTION
        Return list of DLP policies.
    .EXAMPLE
        Invoke-ReviewDlpPolicyEnabled;
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
        # Get only enabled DLP policies.
        $dlpPolicies = Get-DlpCompliancePolicy | Where-Object {$_.Mode -eq 'Enable'};
    }
    END
    {
        # Return policies.
        return $dlpPolicies;
    }
}