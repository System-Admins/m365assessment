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
        $txtRecords = Invoke-DnsRequest -Domain $Domain -Type 'TXT' -ErrorAction SilentlyContinue;

        # Object array to store SPF records.
        $spfRecords = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach TXT record.
        foreach ($txtRecord in $txtRecords)
        {
            # If the TXT record contains SPF.
            if ($txtRecord.data -like 'v=spf1*')
            {
                # Write to log.
                Write-Log -Category 'DNS' -Subcategory 'SPF' -Message ("SPF data for '{0}' is '{1}'" -f $Domain, $txtRecord.data) -Level Debug;

                # Add to object array.
                $spfRecords += [PSCustomObject]@{
                    Domain = $Domain;
                    Record = $txtRecord.data;
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