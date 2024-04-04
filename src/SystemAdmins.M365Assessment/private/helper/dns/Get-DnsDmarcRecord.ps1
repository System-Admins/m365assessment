function Get-DnsDmarcRecord
{
    <#
    .SYNOPSIS
        Get DMARC record for domain.
    .DESCRIPTION
        Uses Google API to resolve DNS.
    .PARAMETER Domain
        Domain to resolve.
    .EXAMPLE
        # Get DMARC record for domain.
        Get-DnsDmarcRecord -Domain 'example.com';
    #>

    [cmdletbinding()]

    param
    (
        # Domain to lookup.
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Domain
    )

    BEGIN
    {
        # Get TXT records for domain.
        $txtRecords = Invoke-DnsRequest -Domain ('_dmarc.' + $Domain) -Type 'TXT' -ErrorAction SilentlyContinue;

        # Object array to store DMARC records.
        $dmarcRecords = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach TXT record.
        foreach ($txtRecord in $txtRecords)
        {
            # If the TXT record contains DMARC.
            if ($txtRecord.data -like 'v=DMARC1*')
            {
                # Write to log.
                Write-CustomLog -Category 'DNS' -Subcategory 'DMARC' -Message ("DMARC data for '{0}' is '{1}'" -f $Domain, $txtRecord.data) -Level Verbose;

                # Add to object array.
                $dmarcRecords += [PSCustomObject]@{
                    Domain = $Domain;
                    Record = $txtRecord.data;
                };
            }
        }
    }
    END
    {
        # Return DMARC records.
        return $dmarcRecords;
    }
}