function Invoke-ReviewEntraExternalCollaborationDomains
{
    <#
    .SYNOPSIS
        Check that collaboration invitations are sent to allowed domains only.
    .DESCRIPTION
        Return true if configured correct otherwise false.
    .EXAMPLE
        Invoke-ReviewEntraExternalCollaborationDomains;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get the B2B policy.
        $policy = Get-EntraIdB2BPolicy;

        # Boolean for the settings is correct.
        [bool]$valid = $true;

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