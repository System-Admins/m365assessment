function Invoke-ReviewPasswordPolicy
{
    <#
    .SYNOPSIS
        Review the password policy.
    .DESCRIPTION
        Get all password policies for the domains, returns object array.
    .EXAMPLE
        Invoke-ReviewPasswordPolicy;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Object array to store the password policies.
        $passwordPolicies = New-Object System.Collections.ArrayList;

        # Get all domains.
        $domains = Get-MgDomain -All;
    }
    PROCESS
    {
        # Foreach domain.
        foreach ($domain in $domains)
        {
            # Boolean for password never expire.
            $passwordNeverExpire = $false;

            # If the policy is set to never.
            if ($domain.PasswordValidityPeriodInDays -eq 2147483647 -or $null -eq $domain.PasswordValidityPeriodInDays)
            {
                # Set boolean to true.
                $passwordNeverExpire = $true;
            }

            # Add to object array.
            $passwordPolicies += [PSCustomObject]@{
                Name                   = $domain.Id;
                PasswordNeverExpire    = $passwordNeverExpire;
                PasswordValidityInDays = $domain.PasswordValidityPeriodInDays;
            };
        }
    }
    END
    {
        # Return password policies.
        return $passwordPolicies;
    }
}