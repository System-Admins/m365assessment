function Get-DnsOnmicrosoftDomain
{
    <#
    .SYNOPSIS
        Get <customer>.onmicrosoft.com domain for the tenant.
    .DESCRIPTION
        Get initial domain through Microsoft Graph.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Identity.DirectoryManagement
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
        # Write to log.
        Write-Log -Category 'DNS' -Message ('Getting all Microsoft 365 managed domains') -Level Debug;

        # Get domains.
        $domains = Get-MgDomain -All;

        # Variable to store initial domain.
        [string]$initialDomain = '';
    }
    PROCESS
    {
        # Foreach domain.
        foreach ($domain in $domains)
        {
            # If domain is initial domain.
            if ($domain.IsInitial -eq $true)
            {
                # Set initial domain.
                $initialDomain = $domain.id;

                #  Write to log.
                Write-Log -Category 'DNS' -Message ('Initial Microsoft 365 domain is "{0}"' -f $initialDomain) -Level Debug;

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