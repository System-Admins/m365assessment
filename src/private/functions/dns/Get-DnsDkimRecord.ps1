function Get-DnsDkimRecord
{
    <#
    .SYNOPSIS
        Get DKIM record for domain.
    .DESCRIPTION
        Uses Google API to resolve DNS.
        Returns selector1 and selector2 if they exists.
    .PARAMETER Domain
        Domain to resolve.
    .EXAMPLE
        # Get SPF record for domain.
        Get-DnsDkimRecord -Domain 'example.com';
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
        # Object array to store SPF records.
        $dkimRecords = @();

        # Construct selectors.
        $selector1 = 'selector1._domainkey';
        $selector2 = 'selector2._domainkey';

        # Construct DKIM record.
        $dkimRecord1 = ("{0}.{1}" -f $selector1, $Domain);
        $dkimRecord2 = ("{0}.{1}" -f $selector2, $Domain);
    }
    PROCESS
    {
        # Invoke DNS requests.
        $dkimRecord1 = Invoke-DnsRequest -Domain $dkimRecord1 -Type 'CNAME' -ErrorAction SilentlyContinue;
        $dkimRecord2 = Invoke-DnsRequest -Domain $dkimRecord2 -Type 'CNAME' -ErrorAction SilentlyContinue;

        # Add DKIM records to array.
        $dkimRecords += $dkimRecord1;
        $dkimRecords += $dkimRecord2;
    }
    END
    {
        # Return SPF records.
        return $dkimRecords;
    }
}