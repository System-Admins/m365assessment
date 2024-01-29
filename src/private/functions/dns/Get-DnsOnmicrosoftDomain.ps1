function Get-DnsOnmicrosoftDomain
{
    <#
    .SYNOPSIS
        Get <customer>.onmicrosoft.com domain for the tenant.
    .DESCRIPTION
        Get initial domain through Microsoft Graph.
    .PARAMETER Domain
        Domain to resolve.
    .EXAMPLE
        Get-DnsOnmicrosoftDomain;
    #>

    [cmdletbinding()]	
        
    Param
    (
        
    )

    BEGIN
    {
        # Get domains.
        $domains = Get-MgDomain -All;

        # Variable to store initial domain.
        [string]$initialDomain = '';

    }
    PROCESS
    {
        # Foreach domain.
        foreach($domain in $domains)
        {
            # If domain is initial domain.
            if($domain.IsInitial -eq $true)
            {
                # Set initial domain.
                $initialDomain = $domain.id;

                # Break loop.
                break;
            }
        }
    }
    END
    {
        # Return initial domain.
        return $initialDomain;
    }
}