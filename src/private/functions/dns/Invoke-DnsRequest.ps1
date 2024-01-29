function Invoke-DnsRequest
{
    <#
    .SYNOPSIS
        Invoke DNS over HTTPS.
    .DESCRIPTION
        Uses Google API to resolve DNS.
    .PARAMETER Domain
        Domain to resolve.
    .PARAMETER Type
        DNS record type.
    .EXAMPLE
        # Get TXT record for domain.
        Invoke-DnsRequest -Domain 'example.com' -Type 'TXT';
    .EXAMPLE
        # Get A record for domain.
        Invoke-DnsRequest -Domain 'example.com' -Type 'A';
    #>

    [cmdletbinding()]	
		
    Param
    (
        # Domain to lookup.
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Domain,

        # DNS record type.
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('A', 'AAAA', 'CNAME', 'MX', 'NS', 'PTR', 'SOA', 'SRV', 'TXT')]
        [string]$Type = 'A'
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'DNS' -Message "Resolving $Domain" -Level Debug;

        # Base URL to query.
        $baseUrl = 'https://dns.google.com/resolve';

        # Construct the query string.
        $queryString = ('?name={0}&type={1}' -f $Domain, $Type);

        # Construct the URI.
        $uri = ($baseUrl + $queryString);
    }
    PROCESS
    {
        # Invoke the request.
        $response = Invoke-RestMethod -Method Get -Uri $uri;

        if ($response.Status -ne 0)
        {
            # Throw execption.
            Write-Log -Category 'DNS' -Message ("DNS lookup failed for '{0}'" -f $domain) -Level Error;
        }

        # Write to log.
        Write-Log -Category 'DNS' -Message ("DNS lookup succeeded for '{0}'" -f $domain) -Level Debug;
    }
    END
    {
        # If the response is not null.
        if ($null -ne $response)
        {
            # Return the response.
            return $response.Answer;
        }
    }
}