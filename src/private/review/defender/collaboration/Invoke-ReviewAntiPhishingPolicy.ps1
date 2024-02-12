function Invoke-ReviewAntiPhishingPolicy
{
    <#
    .SYNOPSIS
        Review that an e-mail anti-phishing policy has been created.
    .DESCRIPTION
        Get all phishing policies and check if they are configured corretly.
    .EXAMPLE
        Invoke-ReviewAntiPhishingPolicy;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Defender' -Message 'Getting anti-phishing e-mail policies' -Level Debug;

        # Get anti-phishing e-mail policies.
        $antiPhishPolicies = Get-AntiPhishPolicy;
    }
    PROCESS
    {
        # Object array to store policies.
        $settings = New-Object System.Collections.ArrayList;

        # Foreach anti-phishing e-mail policy.
        foreach ($antiPhishPolicy in $antiPhishPolicies)
        {
            # Boolean if configured correctly.
            $configuredCorrect = $true;

            # If the policy is not enabled.
            if ($false -eq $antiPhishPolicy.Enabled)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # Phishing threshold level at least 2.
            if($antiPhishPolicy.PhishThresholdLevel -lt 2)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If mailbox intelligence protection is not enabled.
            if($false -eq $antiPhishPolicy.EnableMailboxIntelligenceProtection)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If mailbox intelligence is not enabled.
            if($false -eq $antiPhishPolicy.EnableMailboxIntelligence)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If spoof intelligence is not enabled.
            if($false -eq $antiPhishPolicy.EnableSpoofIntelligence)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # Add to object array.
            $settings += [PSCustomObject]@{
                Guid                           = $antiPhishPolicy.Guid;
                Id                             = $antiPhishPolicy.Id;
                Name                           = $antiPhishPolicy.Name;
                ConfiguredCorrect              = $configuredCorrect;
                Enabled                        = $antiPhishPolicy.Enabled;
                PhishThresholdLevel            = $antiPhishPolicy.PhishThresholdLevel;
                EnableMailboxIntelligenceProtection = $antiPhishPolicy.EnableMailboxIntelligenceProtection;
                EnableMailboxIntelligence      = $antiPhishPolicy.EnableMailboxIntelligence;
                EnableSpoofIntelligence        = $antiPhishPolicy.EnableSpoofIntelligence;
            };
        }
    }
    END
    {
        # Return object.
        return $settings;
    }
}

