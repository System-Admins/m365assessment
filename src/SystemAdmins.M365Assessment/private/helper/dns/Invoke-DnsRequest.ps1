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

    param
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
        Write-CustomLog -Category 'DNS' -Subcategory $Type -Message ("Resolving record of type '{0}' for domain '{1}'" -f $Type, $Domain) -Level Verbose;

        # Base URL to query.
        $baseUrl = 'https://dns.google.com/resolve';

        # Construct the query string.
        $queryString = ('?name={0}&type={1}' -f $Domain, $Type);

        # Construct the URI.
        $uri = ($baseUrl + $queryString);
    }
    PROCESS
    {
        # Try to invoke the DNS request.
        try
        {
            # Write to log.
            Write-CustomLog -Category 'DNS' -Subcategory $Type -Message ("Calling API endpoint '{0}'" -f $uri) -Level Verbose;

            # Invoke the request.
            $response = Invoke-RestMethod -Method Get -Uri $uri -ErrorAction Stop;

            # If the response status is not 0.
            if ($response.Status -ne 0)
            {
                # Write to log.
                Write-CustomLog -Category 'DNS' -Subcategory $Type -Message ("DNS lookup failed for '{0}'" -f $domain, $_) -Level Verbose;
            }

            # Write to log.
            Write-CustomLog -Category 'DNS' -Subcategory $Type -Message ("DNS lookup succeeded for '{0}'" -f $domain) -Level Verbose;
        }
        # Something went wrong invoking the DNS request.
        catch
        {
            # Throw exception.
            throw ("Something went wrong while invoking DNS request for '{0}', exception is '{1}'" -f $domain, $_);
        }
    }
    END
    {
        # If the response have an answer for the DNS request.
        if ($null -ne $response.Answer)
        {
            # Return the response.
            return $response.Answer;
        }
    }
}