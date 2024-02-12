function Invoke-ReviewEmailDomainSpf
{
    <#
    .SYNOPSIS
        Review that all e-mail domains have a valid SPF-record.
    .DESCRIPTION
        Lookup DNS TXT records and verify that e-mail.
    .EXAMPLE
        Invoke-ReviewEmailDomainSpf;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Defender' -Message 'Getting all domains' -Level Debug;

        # Get all domains in Microsoft 365 tenant.
        $domains = Get-MgDomain -All;

        # Object array to store domain SPF settings.
        $spfSettings = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach domain.
        foreach ($domain in $domains)
        {
            # Boolean if SPF is configured correct.
            $spfValid = $false;

            # If e-mail is a supported service.
            if ($domain.SupportedServices -contains 'Email')
            {
                # Get the SPF record.
                $spfRecord = Get-DnsSpfRecord -Domain $domain.Id;

                # If SPF record contain the correct value.
                if ($spfRecord.Record -like '*include:spf.protection.outlook.com*')
                {
                    # Write to log.
                    Write-Log -Category 'Defender' -Message ("SPF is configured correct for domain '{0}'" -f $domain.Id) -Level Debug;

                    # SPF is configured correct.
                    $spfValid = $true;
                }
            }

            # Add domain SPF settings to object array.
            $spfSettings += [pscustomobject]@{
                Domain             = $domain.Id;
                DnsRecordValid     = $spfValid;
                IsDefault          = $domain.IsDefault;
                IsVerified         = $domain.IsVerified;
                AuthenticationType = $domain.AuthenticationType;
            };
        }
    }
    END
    {
        # Return object.
        return $spfSettings;
    }
}