function Invoke-ReviewDefenderAntiSpamNotifyAdmin
{
    <#
    .SYNOPSIS
        Review Exchange Online Spam Policies are set to notify administrators.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewDefenderAntiSpamNotifyAdmin;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Microsoft Defender' -Subcategory 'Policy' -Message 'Getting outbound e-mail spam policies' -Level Debug;

        # Get outbound e-mail spam policies.
        $outboundSpamFilterPolicies = Get-HostedOutboundSpamFilterPolicy;
    }
    PROCESS
    {
        # Object array to store policies.
        $settings = New-Object System.Collections.ArrayList;

        # Foreach outbound e-mail spam policy.
        foreach ($outboundSpamFilterPolicy in $outboundSpamFilterPolicies)
        {
            # Boolean if configured correctly.
            $valid = $true;

            # If bcc suspicious outbound email is not enabled.
            if ($false -eq $outboundSpamFilterPolicy.BccSuspiciousOutboundMail)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If notify outbound spam is not enabled.
            if ($false -eq $outboundSpamFilterPolicy.NotifyOutboundSpam)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If no recipient.
            if ($null -eq $outboundSpamFilterPolicy.NotifyOutboundSpamRecipients)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If the policy is not enabled.
            if ($false -eq $outboundSpamFilterPolicy.Enabled)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If not valid.
            if ($valid -eq $false)
            {
                # Write to log.
                Write-Log -Category 'Microsoft Defender' -Subcategory 'Policy' -Message ('Outbound e-mail spam policy {0} is not set to notify administrators' -f $outboundSpamFilterPolicy.Name) -Level Debug;
            }

            # Create object.
            $settings += [PSCustomObject]@{
                Guid                         = $outboundSpamFilterPolicy.Guid;
                Id                           = $outboundSpamFilterPolicy.Id;
                Name                         = $outboundSpamFilterPolicy.Name;
                Valid                        = $valid;
                BccSuspiciousOutboundMail    = $outboundSpamFilterPolicy.BccSuspiciousOutboundMail;
                NotifyOutboundSpam           = $outboundSpamFilterPolicy.NotifyOutboundSpam;
                NotifyOutboundSpamRecipients = $outboundSpamFilterPolicy.NotifyOutboundSpamRecipients;
                Enabled                      = $outboundSpamFilterPolicy.Enabled;
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
        $review.Id = 'a019303a-3b0a-4f42-999d-0d76b528ae28';
        $review.Category = 'Microsoft 365 Defender';
        $review.Subcategory = 'Email and collaboration';
        $review.Title = 'Ensure Exchange Online Spam Policies are set to notify administrators';
        $review.Data = $settings;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}

