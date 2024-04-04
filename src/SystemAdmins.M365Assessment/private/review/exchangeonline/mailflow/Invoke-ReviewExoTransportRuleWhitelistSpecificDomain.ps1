function Invoke-ReviewExoTransportRuleWhitelistSpecificDomain
{
    <#
    .SYNOPSIS
        Check if mail transport rules do not whitelist specific domains.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewExoTransportRuleWhitelistSpecificDomain;
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
        Write-CustomLog -Category 'Exchange Online' -Subcategory 'Mail Flow' -Message 'Getting transport rules' -Level Verbose;

        # Get all transport rules.
        $transportRules = Get-TransportRule -ResultSize Unlimited;

        # Object array with rules that have specific domains in whitelist.
        $transportRulesWithWhitelistSpecificDomains = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach transport rule.
        foreach ($transportRule in $transportRules)
        {
            # Valid.
            [bool]$valid = $true;

            # If sender domain is not null.
            if ($null -ne $transportRule.SenderDomainIs)
            {
                # Not valid.
                $valid = $false;
            }

            # If setscl is -1.
            if ($transportRule.Setscl -eq -1)
            {
                # Not valid.
                $valid = $false;
            }

            # If transport rule is not valid.
            if ($valid -eq $false)
            {
                # Write to log.
                Write-CustomLog -Category 'Exchange Online' -Subcategory 'Mail Flow' -Message ("Transport rule '{0}' have a whitelisted domain" -f $transportRule.Name) -Level Verbose;

                # Add to list.
                $null = $transportRulesWithWhitelistSpecificDomains.Add($transportRule);
            }
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($transportRulesWithWhitelistSpecificDomains.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '8bf19b9f-7c76-4cb6-8d9a-2a327db4d7d3';
        $review.Category = 'Microsoft Exchange Admin Center';
        $review.Subcategory = 'Mail Flow';
        $review.Title = "Ensure mail transport rules do not whitelist specific domains";
        $review.Data = $transportRulesWithWhitelistSpecificDomains | Select-Object -Property Name, Priority, State, Identity, SenderDomainIs, Setscl;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        #Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}