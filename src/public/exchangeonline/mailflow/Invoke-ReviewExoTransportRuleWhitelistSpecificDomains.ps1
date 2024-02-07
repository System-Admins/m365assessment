function Invoke-ReviewExoTransportRuleWhitelistSpecificDomains
{
    <#
    .SYNOPSIS
        Check if mail transport rules do not whitelist specific domains.
    .DESCRIPTION
        Return object if any rules is found.
    .EXAMPLE
        Invoke-ReviewExoTransportRuleWhitelistSpecificDomains;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
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
                # Add to list.
                $transportRulesWithWhitelistSpecificDomains.Add($transportRule) | Out-Null;
            }
        }
    }
    END
    {
        # Return object.
        return $transportRulesWithWhitelistSpecificDomains;
    } 
}