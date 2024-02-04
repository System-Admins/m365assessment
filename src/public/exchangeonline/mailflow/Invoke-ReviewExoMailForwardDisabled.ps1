function Invoke-ReviewExoMailForwardDisabled
{
    <#
    .SYNOPSIS
        Check if all forms of mail forwarding are blocked and/or disabled.
    .DESCRIPTION
        Return object if any rules is found.
    .EXAMPLE
        Invoke-ReviewExoMailForwardDisabled;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get all transport rules.
        $transportRules = Get-TransportRule -ResultSize Unlimited;

        # List of transport rules with forward/redirect/blindcopy actions.
        $transportRulesWithForward = @();

        # Get all out-bound anti-spam policies.
        $outboundSpamFilterPolicies = Get-HostedOutboundSpamFilterPolicy;

        # List of out-bound anti-spam policies with mail forwarding enabled.
        $outboundSpamFilterPoliciesWithForward = @();
    }
    PROCESS
    {
        # Foreach transport rule.
        foreach ($transportRule in $transportRules)
        {
            # If mail forwarding is enabled.
            if ($transportRule.Actions.ForwardTo -ne $null -or
                $transportRule.Actions.RedirectTo -ne $null -or
                $transportRule.Actions.BlindCopyTo -ne $null)
            {
                # Add to list.
                $transportRulesWithForward += $transportRule;
            }
        }

        # Foreach anti-spam policy.
        foreach ($outboundSpamFilterPolicy in $outboundSpamFilterPolicies)
        {
            # If mail forwarding is enabled.
            if($outboundSpamFilterPolicy.AutoForwardingMode -ne 'Off')
            {
                # Add to list.
                $outboundSpamFilterPoliciesWithForward += $outboundSpamFilterPolicy;
            }
        }
    }
    END
    {
        # If there is any forwarding rules or policies.
        if ($transportRulesWithForward.Count -gt 0 -or $outboundSpamFilterPoliciesWithForward.Count -gt 0)
        {
            # Return object.
            return [PSCustomObject]@{
                TransportRules = $transportRulesWithForward;
                OutboundSpamFilterPolicies = $outboundSpamFilterPoliciesWithForward;
            };
        }
    } 
}