function Get-DnsSpfRecord
{
    <#
    .SYNOPSIS
        Get SPF record for domain.
    .DESCRIPTION
        Uses Google API to resolve DNS.
    .PARAMETER Domain
        Domain to resolve.
    .EXAMPLE
        # Get SPF record for domain.
        Get-DnsSpfRecord -Domain 'example.com';
    #>

    [cmdletbinding()]	
        
    Param
    (
        # Domain to lookup.
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Domain
    )

    BEGIN
    {
        # Get TXT records for domain.
        $txtRecords = Invoke-DnsRequest -Domain $Domain -Type 'TXT';

        # Object array to store SPF records.
        $spfRecords = @();
    }
    PROCESS
    {
        # Foreach TXT record.
        foreach ($txtRecord in $txtRecords)
        {
            # If the TXT record contains SPF.
            if ($txtRecord.data -like 'v=spf1*')
            {
                # Add to object array.
                $spfRecords += [PSCustomObject]@{
                    Domain = $Domain;
                    Record    = $txtRecord.data;
                };
            }
        }
    }
    END
    {
        # Return SPF records.
        return $spfRecords;
    }
}