function Invoke-ReviewEntraIdIdleSessionTimeout
{
    <#
    .SYNOPSIS
        Review the idle session timeout policy for Entra ID.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewEntraIdIdleSessionTimeout;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get idle session timeout.
        $idleSessionPolicies = Get-TenantIdleSessionTimeout;

        # Get conditional access that enforce application restrictions.
        $conditionalAccessPolicies = Get-EntraIdConditionalAccessEnforceAppRestriction;

        # Object array to store results.
        $data = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # If idleSessionPolicies is higher than 180 minutes (3 hours).
        $idleSessionPolicy = $idleSessionPolicies | Where-Object { $_.IdleTimeoutInMinutes -gt 180 -and $_.IsOrganizationDefault -eq $true};

        # Foreach idle policy.
        foreach ($policy in $idleSessionPolicies)
        {
            # Add to results.
            $data += [PSCustomObject]@{
                Type = 'IdleTimeoutPolicy';
                Id   = $policy.Id;
                Name = $policy.DisplayName;
                Value = $policy.IdleTimeoutInMinutes;
            };
        }

        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Policy' -Message ('Idle session policy allows session for more than 3 hours') -Level Debug;

        # If there is no conditional access policies enforcing this.
        if ($null -eq $conditionalAccessPolicies)
        {
            # Write to log.
            Write-Log -Category 'Entra' -Subcategory 'Policy' -Message 'No conditional access policies enforcing app restrictions found' -Level Debug;
        }

        # Foreach conditional access policy.
        foreach ($policy in $conditionalAccessPolicies)
        {
            # Add to results.
            $data += [PSCustomObject]@{
                Type = 'ConditionalAccess';
                Id   = $policy.Id;
                Name = $policy.DisplayName;
                Value = $policy.State;
            };
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($null -ne $idleSessionPolicy -or
            $null -eq $conditionalAccessPolicies)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '645b1886-5437-43e5-8b8a-84c033173ff3';
        $review.Category = 'Microsoft 365 Admin Center';
        $review.Subcategory = 'Settings';
        $review.Title = "Ensure 'Idle session timeout' is set to '3 hours (or less)' for unmanaged devices";
        $review.Data = $data;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}
