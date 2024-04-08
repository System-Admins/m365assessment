function Invoke-ReviewExoMailForwardDisabled
{
    <#
    .SYNOPSIS
        Check if all forms of mail forwarding are blocked and/or disabled.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewExoMailForwardDisabled;
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

        # List of transport rules with forward/redirect/blind copy actions.
        $transportRulesWithForward = New-Object System.Collections.ArrayList;

        # Write to log.
        Write-CustomLog -Category 'Exchange Online' -Subcategory 'Mail Flow' -Message 'Getting outbound spam filter policies' -Level Verbose;

        # Get all out-bound anti-spam policies.
        $outboundSpamFilterPolicies = Get-HostedOutboundSpamFilterPolicy;

        # List of out-bound anti-spam policies with mail forwarding enabled.
        $outboundSpamFilterPoliciesWithForward = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach transport rule.
        foreach ($transportRule in $transportRules)
        {
            # If mail forwarding is enabled.
            if ($null -ne $transportRule.Actions.ForwardTo -or
                $null -ne $transportRule.Actions.RedirectTo -or
                $null -ne $transportRule.Actions.BlindCopyTo)
            {
                # Write to log.
                Write-CustomLog -Category 'Exchange Online' -Subcategory 'Mail Flow' -Message ("Transport rule '{0}' have enabled mailforwarding" -f $transportRule.Name) -Level Verbose;

                # Add to list.
                $transportRulesWithForward += $transportRule;
            }
        }

        # Foreach anti-spam policy.
        foreach ($outboundSpamFilterPolicy in $outboundSpamFilterPolicies)
        {
            # If mail forwarding is enabled.
            if ($outboundSpamFilterPolicy.AutoForwardingMode -ne 'Off')
            {
                # Write to log.
                Write-CustomLog -Category 'Exchange Online' -Subcategory 'Mail Flow' -Message ("Outbound spam filter policy '{0}' have enabled mailforwarding" -f $outboundSpamFilterPolicy.Name) -Level Verbose;

                # Add to list.
                $outboundSpamFilterPoliciesWithForward += $outboundSpamFilterPolicy;
            }
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($transportRulesWithForward.Count -gt 0 -or $outboundSpamFilterPoliciesWithForward.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '45887263-5f2f-4306-946d-8f36acfb3691';
        $review.Category = 'Microsoft Exchange Admin Center';
        $review.Subcategory = 'Mail Flow';
        $review.Title = 'Ensure all forms of mail forwarding are blocked and/or disabled';
        $review.Data = [PSCustomObject]@{
            TransportRules             = ($transportRulesWithForward).Name -join ', ';
            OutboundSpamFilterPolicies = ($outboundSpamFilterPoliciesWithForward).Name -join ', ';
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}