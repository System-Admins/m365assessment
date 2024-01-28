function Invoke-ReviewIdleSessionTimeout
{
    <#
    .SYNOPSIS
        Review the idle session timeout policy.
    .DESCRIPTION
        If idle session timeout is configured correct return true otherwise false.
    .EXAMPLE
        Invoke-ReviewIdleSessionTimeout;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get idle session timeout.
        $idleSessionPolicies = Get-PolicyIdleSessionTimeout;

        # Get conditional access that enforce application restrictions.
        $conditionalAccessPolicies = Get-ConditionalAccessEnforceAppRestriction;

        # Bool for a valid configuration.
        [bool]$validConfiguration = $true;
    }
    PROCESS
    {
        # If idleSessionPolicies is higher than 180 minutes (3 hours).
        if ($idleSessionPolicies.IdleTimeoutInMinutes -gt 180)
        {
            # Write to log.
            Write-Log  -Category "User" -Message ('Idle session timeout is {0} minutes' -f $idleSessionPolicies.IdleTimeoutInMinutes) -Level Debug;

            # Set valid configuration to false.
            $validConfiguration = $false;
        }

        # If there is no conditional access policies enforcing this.
        if ($null -eq $conditionalAccessPolicies)
        {
            # Write to log.
            Write-Log  -Category "User" -Message 'No conditional access policies enforcing app restrictions found' -Level Debug;

            # Set valid configuration to false.
            $validConfiguration = $false;
        }
    }
    END
    {
        # If the configuration is valid.
        if ($validConfiguration)
        {
            # Write to log.
            Write-Log  -Category "User" -Message 'Idle session timeout is configured correct' -Level Debug;
        }
        # Else if the configuration is not valid.
        else
        {
            # Write to log.
            Write-Log  -Category "User" -Message 'Idle session timeout is not configured correct' -Level Debug;
        }

        # Return the result.
        return $validConfiguration;
    }
}
