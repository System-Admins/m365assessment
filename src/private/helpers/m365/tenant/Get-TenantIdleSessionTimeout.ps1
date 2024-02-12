function Get-TenantIdleSessionTimeout
{
    <#
    .SYNOPSIS
        Review the idle session timeout policy.
    .DESCRIPTION
        Get all idle session timeout policies and return them.
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
        Write-Log -Category 'Entra ID' -Subcategory 'Policy' -Message 'Getting all activity based timeout policies' -Level Debug;

        # Get idle session timeout policy.
        $activityBasedTimeoutPolicies = Get-MgPolicyActivityBasedTimeoutPolicy -All;
    }
    PROCESS
    {
        # If there is activity based timeout policies.
        if ($null -eq $activityBasedTimeoutPolicies)
        {
            # Write to log.
            Write-Log -Category 'Entra ID' -Subcategory 'Policy' -Message 'No activity based timeout policies found' -Level Debug;
        }
        # Else if there is one ore more policies.
        else
        {
            # Foreach policy.
            foreach ($activityBasedTimeoutPolicy in $activityBasedTimeoutPolicies)
            {
                # Review the policy.
                [bool]$reviewFlag = $true;

                # Get application policies.
                $applicationPolicies = ($activityBasedTimeoutPolicy.Definition | ConvertFrom-Json).ActivityBasedTimeoutPolicy.ApplicationPolicies;

                # Convert timespan to minutes.
                [timespan]$totalMinutes = $applicationPolicies.WebSessionIdleTimeout;

                # Write to log.
                Write-Log -Category 'Policy' -Message ("Found idle session policy '{0}' with timeout {1} minutes" -f $activityBasedTimeoutPolicy.DisplayName, $totalMinutes.TotalMinutes) -Level Debug;
            
                # Add to array.
                $idleSessionPolicies += [PSCustomObject]@{
                    Id                    = $activityBasedTimeoutPolicy.Id;
                    DisplayName           = $activityBasedTimeoutPolicy.DisplayName;
                    IsOrganizationDefault = $activityBasedTimeoutPolicy.IsOrganizationDefault;
                    IdleTimeoutInMinutes  = $totalMinutes.TotalMinutes;
                };
            }
        }
    }
    END
    {
        # If there are idle session policies.
        if ($idleSessionPolicies.Count -gt 0)
        {
            # Return idle session policies.
            return $idleSessionPolicies;
        }
    }
}
