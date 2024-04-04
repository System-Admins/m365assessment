function Invoke-ReviewEntraIdPasswordPolicy
{
    <#
    .SYNOPSIS
        If the 'Password expiration policy' is set to 'Set passwords to never expire (recommended)'.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Beta.Identity.DirectoryManagement
    .EXAMPLE
        Invoke-ReviewEntraIdPasswordPolicy;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name;

        # Object array to store the password policies.
        $passwordPolicies = New-Object System.Collections.ArrayList;

        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Domains' -Message ("Getting all domains") -Level Verbose;

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

            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'Password Policy' -Message ("Password never expire is set to {0} for domain '{1}'" -f $passwordNeverExpire, $domain.id) -Level Verbose;

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
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If there is any password policies with password never expire.
        if ($passwordPolicies | Where-Object { $_.PasswordNeverExpire -eq $false })
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '7ccac596-ee68-4f28-abe7-713c2b75a39e';
        $review.Category = 'Microsoft 365 Admin Center';
        $review.Subcategory = 'Settings';
        $review.Title = "Ensure the 'Password expiration policy' is set to 'Set passwords to never expire (recommended)'";
        $review.Data = $passwordPolicies;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}