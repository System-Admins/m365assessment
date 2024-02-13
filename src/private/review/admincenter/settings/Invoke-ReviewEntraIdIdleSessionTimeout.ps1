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
    }
    PROCESS
    {
        # If idleSessionPolicies is higher than 180 minutes (3 hours).
        $idleSessionPolicies = $idleSessionPolicies | Where-Object { $_.IdleTimeoutInMinutes -gt 180 };

        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Policy' -Message ('Found {0} idle session policies that which allows session for more than 3 hours' -f $idleSessionPolicies.Count) -Level Debug;

        # If there is no conditional access policies enforcing this.
        if ($null -eq $conditionalAccessPolicies)
        {
            # Write to log.
            Write-Log -Category 'Entra' -Subcategory 'Policy' -Message 'No conditional access policies enforcing app restrictions found' -Level Debug;
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($idleSessionPolicies.Count -gt 0 -or $null -eq $conditionalAccessPolicies)
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
        $review.Data = [PSCustomObject]@{
            IdleSessionPolicies       = $idleSessionPolicies;
            ConditionalAccessPolicies = $conditionalAccessPolicies;
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();
                            
        # Return object.
        return $review;
    }
}
