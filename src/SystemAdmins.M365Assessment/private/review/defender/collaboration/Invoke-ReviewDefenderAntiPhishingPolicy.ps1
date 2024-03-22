function Invoke-ReviewDefenderAntiPhishingPolicy
{
    <#
    .SYNOPSIS
        Review that an e-mail anti-phishing policy has been created.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewDefenderAntiPhishingPolicy;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Microsoft Defender' -Subcategory 'Policy' -Message 'Getting anti-phishing e-mail policies' -Level Debug;

        # Get anti-phishing e-mail policies.
        $antiPhishPolicies = Get-AntiPhishPolicy -WarningAction SilentlyContinue;
    }
    PROCESS
    {
        # Object array to store policies.
        $settings = New-Object System.Collections.ArrayList;

        # Foreach anti-phishing e-mail policy.
        foreach ($antiPhishPolicy in $antiPhishPolicies)
        {
            # Boolean if configured correctly.
            $valid = $true;

            # If the policy is not enabled.
            if ($false -eq $antiPhishPolicy.Enabled)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # Phishing threshold level at least 2.
            if ($antiPhishPolicy.PhishThresholdLevel -lt 2)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If mailbox intelligence protection is not enabled.
            if ($false -eq $antiPhishPolicy.EnableMailboxIntelligenceProtection)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If mailbox intelligence is not enabled.
            if ($false -eq $antiPhishPolicy.EnableMailboxIntelligence)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If spoof intelligence is not enabled.
            if ($false -eq $antiPhishPolicy.EnableSpoofIntelligence)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # Add to object array.
            $settings += [PSCustomObject]@{
                Guid                                = $antiPhishPolicy.Guid;
                Id                                  = $antiPhishPolicy.Id;
                Name                                = $antiPhishPolicy.Name;
                Valid                               = $valid;
                Enabled                             = $antiPhishPolicy.Enabled;
                PhishThresholdLevel                 = $antiPhishPolicy.PhishThresholdLevel;
                EnableMailboxIntelligenceProtection = $antiPhishPolicy.EnableMailboxIntelligenceProtection;
                EnableMailboxIntelligence           = $antiPhishPolicy.EnableMailboxIntelligence;
                EnableSpoofIntelligence             = $antiPhishPolicy.EnableSpoofIntelligence;
            };
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($settings | Where-Object { $_.Valid -eq $false })
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '13954bef-f9cd-49f8-b8c8-626e87de6ba2';
        $review.Category = 'Microsoft 365 Defender';
        $review.Subcategory = 'Email and collaboration';
        $review.Title = 'Ensure that an anti-phishing policy has been created';
        $review.Data = $settings;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}

