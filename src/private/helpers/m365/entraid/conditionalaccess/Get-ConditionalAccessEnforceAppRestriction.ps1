function Get-ConditionalAccessEnforceAppRestriction
{
    <#
    .SYNOPSIS
        Review in conditional access is configured to enforce app restrictions.
    .DESCRIPTION
        Run through every conditional access and check if it's fulfilled.
    .EXAMPLE
        Get-ConditionalAccessEnforceAppRestriction;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get all policies.
        $conditionalAccessPolicies = Get-MgIdentityConditionalAccessPolicy -All;

        # Store policies that are set to enforce session idle timeout.
        $policies = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach policy.
        foreach ($conditionalAccessPolicy in $conditionalAccessPolicies)
        {
            # Booleans for various conditions.
            [bool]$policyEnabled = $true;
            [bool]$policyAppliedToAllUsers = $true;
            [bool]$policyAppliedToCloudApp = $true;
            [bool]$policyAppliedConditionClientApp = $true;
            [bool]$policyAppliedSessionAppEnforceRestrictions = $true;

            # If the policy is not enabled.
            if ($conditionalAccessPolicy.State -ne 'enabled')
            {
                # Set condition.
                $policyEnabled = $false;
            }

            # If the policy is not applied to all users.
            if ($conditionalAccessPolicy.Conditions.Users.IncludeUsers -ne 'All')
            {
                # Set condition.
                $policyAppliedToAllUsers = $false;
            }
    
            # Else if the policy is excluded from all users.
            if ($conditionalAccessPolicy.Conditions.Users.ExcludeUsers -eq 'All')
            {
                # Set condition.
                $policyAppliedToAllUsers = $false;
            }

            # If the policy is not applied to the Office 365 cloud app.
            if ($conditionalAccessPolicy.Conditions.Applications.IncludeApplications -ne 'Office365')
            {
                # Set condition.
                $policyAppliedToCloudApp = $false;
            }

            # Else if the policy is excluded from the Office 365 cloud app.
            if ($conditionalAccessPolicy.Conditions.Applications.ExcludeApplications -eq 'Office365')
            {
                # Set condition.
                $policyAppliedToCloudApp = $false;
            }

            # If the policy is not applied to the browser client app.
            if ($conditionalAccessPolicy.Conditions.ClientAppTypes -notcontains 'browser')
            {
                # Set condition.
                $policyAppliedConditionClientApp = $false;
            }

            # If the session control is not set to enforce application restrictions.
            if ($false -eq $conditionalAccessPolicy.SessionControls.ApplicationEnforcedRestrictions.IsEnabled)
            {
                # Set condition.
                $policyAppliedSessionAppEnforceRestrictions = $false;
            }

            # If conditions are met.
            if ($policyEnabled -and $policyAppliedToAllUsers -and $policyAppliedToCloudApp -and $policyAppliedConditionClientApp -and $policyAppliedSessionAppEnforceRestrictions)
            {
                # Write to log.
                Write-Log -Category "Security" -Message ("Conditional access policy '{0}' is set to enforce session idle timeout" -f $conditionalAccessPolicy.DisplayName) -Level Debug;

                # Add to list.
                $policies += [PSCustomObject]@{
                    Id          = $conditionalAccessPolicy.Id;
                    DisplayName = $conditionalAccessPolicy.DisplayName;
                    Description = $conditionalAccessPolicy.Description;
                    State       = $conditionalAccessPolicy.State;
                }
            }
        }
    }
    END
    {
        # If there is enforced application restrictions.
        if ($policies.Count -gt 0)
        {
            # Return policies.
            return $policies;
        }
    }
}
