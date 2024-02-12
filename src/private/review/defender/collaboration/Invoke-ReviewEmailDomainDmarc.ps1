function Invoke-ReviewEmailDomainDmarc
{
    <#
    .SYNOPSIS
        Review that all e-mail domains have a valid DMARC-record.
    .DESCRIPTION
        Lookup DNS TXT records and verify that e-mail.
    .EXAMPLE
        Invoke-ReviewEmailDomainDmarc;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Defender' -Message 'Getting all domains' -Level Debug;

        # Get all domains in Microsoft 365 tenant.
        $domains = Get-MgDomain -All;

        # Get initial domain.
        $initialDomain = Get-DnsOnmicrosoftDomain;

        # Object array to store domain DMARC settings.
        $dmarcSettings = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach domain.
        foreach ($domain in $domains)
        {
            # If this is the initial domain.
            if ($domain.Id -eq $initialDomain)
            {
                # Skip.
                continue;
            }
            
            # Boolean if DMARC is configured correct.
            $dmarcValid = $false;

            # If e-mail is a supported service.
            if ($domain.SupportedServices -contains 'Email')
            {
                # Get the DMARC records.
                $dmarcRecords = Get-DnsDmarcRecord -Domain $domain.Id;
                
                # If DMARC record is found.
                if ($dmarcRecords.Count -gt 0)
                {
                    # Set boolean to true.
                    $dmarcValid = $true;
                }
            }

            # Add domain DMARC settings to object array.
            $dmarcSettings += [pscustomobject]@{
                Domain             = $domain.Id;
                DnsRecordValid     = $dmarcValid;
                IsDefault          = $domain.IsDefault;
                IsVerified         = $domain.IsVerified;
                AuthenticationType = $domain.AuthenticationType;
            };
        }
    }
    END
    {
        # Return object array.
        return $dmarcSettings;
    }
}