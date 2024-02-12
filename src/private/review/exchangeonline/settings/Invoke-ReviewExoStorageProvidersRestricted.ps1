function Invoke-ReviewExoStorageProvidersRestricted
{
    <#
    .SYNOPSIS
        Review additional storage providers are restricted in
Outlook on the web.
    .DESCRIPTION
        Return list of policies that are not restricted, if return nothing then all policies are restricted.
    .EXAMPLE
        Invoke-ReviewExoStorageProvidersRestricted;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get OWA policies.
        $owaPolicies = Get-OwaMailboxPolicy;

        # List of OWA policies with additional storage providers not restricted.
        $owaPoliciesNotRestricted = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach OWA policy.
        foreach ($owaPolicy in $owaPolicies)
        {
            # If additional storage providers are not restricted.
            if ($owaPolicy.AdditionalStorageProvidersAvailable -eq $false)
            {
                # Add OWA policy to list.
                $owaPoliciesNotRestricted.Add($owaPolicy) | Out-Null;
            }
        }
    }
    END
    {
        # Return list.
        return $owaPoliciesNotRestricted;
    } 
}