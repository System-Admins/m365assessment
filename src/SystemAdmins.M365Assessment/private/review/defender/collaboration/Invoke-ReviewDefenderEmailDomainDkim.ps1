function Invoke-ReviewDefenderEmailDomainDkim
{
    <#
    .SYNOPSIS
        Review that all e-mail domains have DKIM configured.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
        - Microsoft.Graph.Identity.DirectoryManagement
    .EXAMPLE
        Invoke-ReviewDefenderEmailDomainDkim;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # Write to log.
        Write-CustomLog -Category 'Microsoft Defender' -Subcategory 'Policy' -Message 'Getting all DKIM configuration' -Level Verbose;

        # Get all DKIM configuration.
        $dkimSigningConfig = Get-DkimSigningConfig;

        # Store DKIM settings.
        $dkimSigningSettings = New-Object System.Collections.ArrayList;

        # Store results.
        $results = New-Object System.Collections.ArrayList;

        # Write to log.
        Write-CustomLog -Category 'Microsoft Defender' -Subcategory 'Policy' -Message 'Getting all domains' -Level Verbose;

        # Get all domains in Microsoft 365 tenant.
        $domains = Get-MgDomain -All;

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
            $valid = $true;

            # If DKIM is not enabled.
            if ($domain.Enabled -eq $false)
            {
                # Set boolean to false.
                $valid = $false;
            }

            # Get DKIM record.
            $dkimRecords = Get-DnsDkimRecord -Domain $domain.Domain -ErrorAction SilentlyContinue;

            # If DKIM record is not found.
            if($null -eq $dkimRecords)
            {
                # Continue.
                continue;
            }

            # If DKIM record is not found.
            if ($dkimRecords.Count -lt 2)
            {
                # Set boolean to false.
                $valid = $false;
            }

            # If selector1 in the domain matches the DKIM record.
            if (('{0}.' -f $domain.Selector1CNAME) -notlike $dkimRecords[0].data)
            {
                # Set boolean to false.
                $valid = $false;
            }

            # If selector2 in the domain matches the DKIM record.
            if (('{0}.' -f $domain.Selector2CNAME) -notlike $dkimRecords[1].data)
            {
                # Set boolean to false.
                $valid = $false;
            }

            # Add to object array.
            $dkimSigningSettings += [PSCustomObject]@{
                Domain         = $domain.Domain;
                Enabled        = $domain.Enabled;
                Valid          = $valid;
                Selector1CNAME = $domain.Selector1CNAME;
                Selector2CNAME = $domain.Selector2CNAME;
                DkimRecord1    = $dkimRecords[0].data;
                DkimRecord2    = $dkimRecords[1].data;
            }
        }

        # Foreach domain.
        foreach ($domain in $domains)
        {
            # If this is the initial domain.
            if ($domain.Domain -eq $initialDomain)
            {
                # Skip.
                continue;
            }

            # Boolean if DKIM is configured correct.
            $valid = $false;
            $enabled = $false;

            # If e-mail is a supported service.
            if ($domain.SupportedServices -contains 'Email')
            {
                # Get DKIM setting.
                $dkimSigningSetting = $dkimSigningSettings | Where-Object { $_.Domain -eq $domain.Id };

                # If DKIM is configured correct.
                if ($dkimSigningSetting.Valid -eq $true)
                {
                    # Write to log.
                    Write-CustomLog -Category 'Microsoft Defender' -Subcategory 'Policy' -Message ("Domain '{0}' have a valid DKIM configuration") -Level Verbose;

                    # SPF is configured correct.
                    $valid = $true;
                }
                # Else if DKIM is not configured correct.
                else
                {
                    # Write to log.
                    Write-CustomLog -Category 'Microsoft Defender' -Subcategory 'Policy' -Message ("Domain '{0}' does not have a valid DKIM configuration") -Level Verbose;
                }

                # If DKIM is enabled.
                if ($dkimSigningSetting.Enabled -eq $true)
                {
                    # DKIM setting is enabled.
                    $enabled = $true;
                }

                # Add domain object array.
                $results += [PSCustomObject]@{
                    Domain             = $domain.Id;
                    Valid              = $valid;
                    IsDefault          = $domain.IsDefault;
                    IsVerified         = $domain.IsVerified;
                    AuthenticationType = $domain.AuthenticationType;
                    DkimEnabled        = $enabled;
                    DkimRecord1        = $dkimSigningSetting.DkimRecord1;
                    DkimRecord2        = $dkimSigningSetting.DkimRecord2;
                };
            }
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if (($results | Where-Object { $_.Valid -eq $false }) -or $null -eq $results)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '92adb77c-a12b-4dee-8ce8-2b5f748f22ec';
        $review.Category = 'Microsoft 365 Defender';
        $review.Subcategory = 'Email and collaboration';
        $review.Title = 'Ensure that DKIM is enabled for all Exchange Online Domains';
        $review.Data = $results;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}