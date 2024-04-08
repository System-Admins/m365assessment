function Invoke-ReviewDefenderEmailDomainSpf
{
    <#
    .SYNOPSIS
        Review that all e-mail domains have a valid SPF-record.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Identity.DirectoryManagement
    .EXAMPLE
        Invoke-ReviewDefenderEmailDomainSpf;
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
        Write-CustomLog -Category 'Microsoft Defender' -Subcategory 'Policy' -Message 'Getting all domains' -Level Verbose;

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
            $valid = $false;

            # If e-mail is a supported service.
            if ($domain.SupportedServices -contains 'Email')
            {
                # Get the SPF record.
                $spfRecord = Get-DnsSpfRecord -Domain $domain.Id -ErrorAction SilentlyContinue;

                # If no SPF record.
                if ($null -eq $spfRecord)
                {
                    # Continue to next domain.
                    continue;
                }

                # If SPF record contain the correct value.
                if ($spfRecord.Record -like '*include:spf.protection.outlook.com*')
                {
                    # Write to log.
                    Write-CustomLog -Category 'Microsoft Defender' -Subcategory 'Policy' -Message ("SPF is configured correct for domain '{0}'" -f $domain.Id) -Level Verbose;

                    # SPF is configured correct.
                    $valid = $true;
                }
                else
                {
                    # Write to log.
                    Write-CustomLog -Category 'Microsoft Defender' -Subcategory 'Policy' -Message ("SPF is not configured correct for domain '{0}'" -f $domain.Id) -Level Verbose;
                }

                # Add domain SPF settings to object array.
                $spfSettings += [PSCustomObject]@{
                    Domain             = $domain.Id;
                    Valid              = $valid;
                    IsDefault          = $domain.IsDefault;
                    IsVerified         = $domain.IsVerified;
                    AuthenticationType = $domain.AuthenticationType;
                    Record             = $spfRecord.Record;
                };
            }
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ( $spfSettings | Where-Object { $_.Valid -eq $false })
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '9be729e4-0378-4c2c-afa1-92b2af71c4e9';
        $review.Category = 'Microsoft 365 Defender';
        $review.Subcategory = 'Email and collaboration';
        $review.Title = 'Ensure that SPF records are published for all Exchange Domains';
        $review.Data = $spfSettings | Where-Object { $_.Valid -eq $false };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}