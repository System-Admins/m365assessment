function Invoke-ReviewEntraSecurityDefaultEnabled
{
    <#
    .SYNOPSIS
        Get if security defaults are enabled.
    .DESCRIPTION
        Return true or false
    .EXAMPLE
        Invoke-ReviewEntraSecurityDefaultEnabled;
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
        # Get security defaults.
        $securityDefaults = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy;
    }
    END
    {
        # Return state.
        return [bool]$securityDefaults.IsEnabled;
    }
}