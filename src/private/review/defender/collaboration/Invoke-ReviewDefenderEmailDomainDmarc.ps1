function Invoke-ReviewDefenderEmailDomainDmarc
{
    <#
    .SYNOPSIS
        Review that all e-mail domains have a valid DMARC-record.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Identity.DirectoryManagement
    .EXAMPLE
        Invoke-ReviewDefenderEmailDomainDmarc;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Microsoft Defender' -Subcategory 'Policy' -Message 'Getting all domains' -Level Debug;

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
            $valid = $false;

            # CLear DMARC records.
            $dmarcRecords = $null;

            # If e-mail is a supported service.
            if ($domain.SupportedServices -contains 'Email')
            {
                # Get the DMARC records.
                $dmarcRecords = Get-DnsDmarcRecord -Domain $domain.Id;
                
                # If DMARC record is found.
                if ($dmarcRecords.Count -gt 0)
                {
                    # Set boolean to true.
                    $valid = $true;
                }
            }

            # Add domain DMARC settings to object array.
            $dmarcSettings += [PSCustomObject]@{
                Domain             = $domain.Id;
                Valid              = $valid;
                IsDefault          = $domain.IsDefault;
                IsVerified         = $domain.IsVerified;
                AuthenticationType = $domain.AuthenticationType;
                Record             = $dmarcRecords.Record;
            };
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($dmarcSettings | Where-Object { $_.Valid -eq $false })
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                       
        # Create new review object to return.
        [Review]$review = [Review]::new();
               
        # Add to object.
        $review.Id = '7f46d070-097f-4a6b-aad1-118b5b707f41';
        $review.Category = 'Microsoft 365 Defender';
        $review.Subcategory = 'Email and collaboration';
        $review.Title = 'Ensure DMARC Records for all Exchange Online domains are published';
        $review.Data = $dmarcSettings;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();
               
        # Return object.
        return $review;
    }
}