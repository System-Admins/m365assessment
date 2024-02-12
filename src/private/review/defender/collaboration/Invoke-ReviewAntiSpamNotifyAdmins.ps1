function Invoke-ReviewAntiSpamNotifyAdmins
{
    <#
    .SYNOPSIS
        Review Exchange Online Spam Policies are set to notify administrators.
    .DESCRIPTION
        Get spam policy settings and check if they are configured correctly to notify administrators.
    .EXAMPLE
        Invoke-ReviewAntiSpamNotifyAdmins;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Defender' -Message 'Getting outbound e-mail spam policies' -Level Debug;

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
            $configuredCorrect = $true;

            # If bcc suspicous outbound email is not enabled.
            if ($false -eq $outboundSpamFilterPolicy.BccSuspiciousOutboundMail)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If notify outbound spam is not enabled.
            if ($false -eq $outboundSpamFilterPolicy.NotifyOutboundSpam)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If no recipient.
            if ($null -eq $outboundSpamFilterPolicy.NotifyOutboundSpamRecipients)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If the policy is not enabled.
            if ($false -eq $outboundSpamFilterPolicy.Enabled)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # Create object.
            $settings += [PSCustomObject]@{
                Guid                         = $outboundSpamFilterPolicy.Guid;
                Id                           = $outboundSpamFilterPolicy.Id;
                Name                         = $outboundSpamFilterPolicy.Name;
                ConfiguredCorrect            = $configuredCorrect;
                BccSuspiciousOutboundMail    = $outboundSpamFilterPolicy.BccSuspiciousOutboundMail;
                NotifyOutboundSpam           = $outboundSpamFilterPolicy.NotifyOutboundSpam;
                NotifyOutboundSpamRecipients = $outboundSpamFilterPolicy.NotifyOutboundSpamRecipients;
                Enabled                      = $outboundSpamFilterPolicy.Enabled;
            };
        }
    }
    END
    {
        # Return object.
        return $settings;
    }
}

