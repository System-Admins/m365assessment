function Invoke-ReviewEmailDomainDkim
{
    <#
    .SYNOPSIS
        Review that all e-mail domains have DKIM configured.
    .DESCRIPTION
        Check if all e-mail domains have a valid signing configuration.
    .EXAMPLE
        Invoke-ReviewEmailDomainDkim;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Defender' -Message 'Getting all DKIM configuration' -Level Debug;

        # Get all DKIM configuration.
        $dkimSigningConfig = Get-DkimSigningConfig;

        # Store DKIM settings.
        $dkimSigningSettings = New-Object System.Collections.ArrayList;

        # Get initial domain.
        $initialDomain = Get-DnsOnmicrosoftDomain;
    }
    PROCESS
    {
        # Foreach domain in the DKIM configuration.
        foreach ($domain in $dkimSigningConfig)
        {
            # If this is the initial domain.
            if ($domain.Domain -eq $initialDomain)
            {
                # Skip.
                continue;
            }
            
            # Boolean to check if DKIM is configured correctly.
            $configuredCorrect = $true;

            # If DKIM is not enabled.
            if ($domain.Enabled -eq $false)
            {
                # Set boolean to false.
                $configuredCorrect = $false;
            }

            # Get DKIM record.
            $dkimRecords = Get-DnsDkimRecord -Domain $domain.Domain;

            # If DKIM record is not found.
            if ($dkimRecords.Count -lt 2)
            {
                # Set boolean to false.
                $configuredCorrect = $false;
            }

            # If selector1 in the domain matches the DKIM record.
            if (('{0}.' -f $domain.Selector1CNAME) -notlike $dkimRecords[0].data)
            {
                # Set boolean to false.
                $configuredCorrect = $false;
            }

            # If selector2 in the domain matches the DKIM record.
            if (('{0}.' -f $domain.Selector2CNAME) -notlike $dkimRecords[1].data)
            {
                # Set boolean to false.
                $configuredCorrect = $false;
            }

            # Add to object array.
            $dkimSigningSettings += [pscustomobject]@{
                Domain            = $domain.Domain;
                Enabled           = $domain.Enabled;
                ConfiguredCorrect = $configuredCorrect;
                Selector1CNAME    = $domain.Selector1CNAME;
                Selector2CNAME    = $domain.Selector2CNAME;
                DkimRecord1       = $dkimRecords[0].data;
                DkimRecord2       = $dkimRecords[1].data;
            }
        }
    }
    END
    {
        # Return settings.
        return $dkimSigningSettings;
    }
}