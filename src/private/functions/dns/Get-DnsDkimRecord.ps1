function Get-DnsDkimRecord
{
    <#
    .SYNOPSIS
        Get DKIM record for domain.
    .DESCRIPTION
        Uses Google API to resolve DNS.
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

        # Construct selector1
    }
    PROCESS
    {
        # Get CNAME records for domain.

    }
    END
    {
        # Return SPF records.
        return $dkimRecords;
    }
}

Invoke-DnsRequest -Domain 'selector1._domainkey.systemadmins.com' -Type 'CNAME';