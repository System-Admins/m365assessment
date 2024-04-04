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
        # Get DKIM record for domain.
        Get-DnsDkimRecord -Domain 'example.com';
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
        # Object array to store SPF records.
        $dkimRecords = New-Object System.Collections.ArrayList;

        # Construct selectors.
        $selector1 = 'selector1._domainkey';
        $selector2 = 'selector2._domainkey';

        # Construct DKIM record.
        $dkimRecord1 = ('{0}.{1}' -f $selector1, $Domain);
        $dkimRecord2 = ('{0}.{1}' -f $selector2, $Domain);
    }
    PROCESS
    {
        # Try to get DKIM records.
        try
        {
            # Invoke DNS requests.
            $dkimRecord1Result = Invoke-DnsRequest -Domain $dkimRecord1 -Type 'CNAME' -ErrorAction SilentlyContinue;
            $dkimRecord2Result = Invoke-DnsRequest -Domain $dkimRecord2 -Type 'CNAME' -ErrorAction SilentlyContinue;
            # Add DKIM records to array.
            $dkimRecords += $dkimRecord1Result;
            $dkimRecords += $dkimRecord2Result;
        }
        catch
        {
            # Write to log.
            Write-CustomLog -Category 'DNS' -Subcategory 'DKIM' -Message ("DKIM data for '{0}' is '{1}'" -f $dkimRecord1, $dkimRecord1Result.data) -Level Verbose;
            Write-CustomLog -Category 'DNS' -Subcategory 'DKIM' -Message ("DKIM data for '{0}' is '{1}'" -f $dkimRecord2, $dkimRecord2Result.data) -Level Verbose;
        }
    }
    END
    {
        # Return SPF records if any.
        if($null -ne $dkimRecords)
        {
            return $dkimRecords;
        }
    }
}