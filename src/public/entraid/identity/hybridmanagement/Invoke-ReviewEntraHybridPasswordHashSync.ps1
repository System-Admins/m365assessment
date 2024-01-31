function Invoke-ReviewEntraHybridPasswordHashSync
{
    <#
    .SYNOPSIS
        Check that password hash sync is enabled for hybrid deployments.
    .DESCRIPTION
        Return true if configured correct otherwise false.
    .EXAMPLE
        Invoke-ReviewEntraHybridPasswordHashSync;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get the B2B policy.
        $policy = Get-EntraIdB2BPolicy;

    }
    PROCESS
    {
        # If the policy is not a allow list.
        if ($false -eq $policy.isAllowlist)
        {
            # Set bool.
            $valid = $false;
        }
    }
    END
    {
        # Return bool.
        return $valid;
    }
}

Invoke-MgGraphRequest -uri "https://graph.microsoft.com/beta/security/secureScores"