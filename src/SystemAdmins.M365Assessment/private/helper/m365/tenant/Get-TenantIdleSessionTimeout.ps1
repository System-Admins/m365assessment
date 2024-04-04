function Get-TenantIdleSessionTimeout
{
    <#
    .SYNOPSIS
        Review the idle session timeout policy.
    .DESCRIPTION
        Get all idle session timeout policies and return them.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Identity.SignIns
    .EXAMPLE
        Get-TenantIdleSessionTimeout;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Store all idle session policies.
        $idleSessionPolicies = New-Object System.Collections.ArrayList;

        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Policy' -Message 'Getting all activity based timeout policies' -Level Verbose;

        # Get idle session timeout policy.
        $activityBasedTimeoutPolicies = Get-MgPolicyActivityBasedTimeoutPolicy -All;
    }
    PROCESS
    {
        # Foreach policy.
        foreach ($activityBasedTimeoutPolicy in $activityBasedTimeoutPolicies)
        {
            # Get application policies.
            $applicationPolicies = ($activityBasedTimeoutPolicy.Definition | ConvertFrom-Json).ActivityBasedTimeoutPolicy.ApplicationPolicies;

            # Convert time span to minutes.
            [timespan]$totalMinutes = $applicationPolicies.WebSessionIdleTimeout;

            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'Policy' -Message ("Found idle session policy '{0}' with timeout {1} minutes" -f $activityBasedTimeoutPolicy.DisplayName, $totalMinutes.TotalMinutes) -Level Verbose;

            # Add to array.
            $idleSessionPolicies += [PSCustomObject]@{
                Id                    = $activityBasedTimeoutPolicy.Id;
                DisplayName           = $activityBasedTimeoutPolicy.DisplayName;
                IsOrganizationDefault = $activityBasedTimeoutPolicy.IsOrganizationDefault;
                IdleTimeoutInMinutes  = $totalMinutes.TotalMinutes;
            };
        }

        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Policy' -Message ('Found {0} activity based timeout policies' -f $idleSessionPolicies.Count) -Level Verbose;
    }
    END
    {
        # Return idle session policies.
        return $idleSessionPolicies;
    }
}
