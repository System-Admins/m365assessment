function Get-EntraIdConditionalAccessEnforceAppRestriction
{
    <#
    .SYNOPSIS
        Get all conditional access policies that is set to enforce app restriction.
    .DESCRIPTION
        Returns list of policies that are set to enforce app restrictions.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Identity.SignIns
    .EXAMPLE
        Get-EntraIdConditionalAccessEnforceAppRestriction;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Policy' -Message 'Getting all conditional access policies' -Level Debug;

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
                # Write to log.
                Write-Log -Category 'Entra' -Subcategory 'Policy' -Message ("Conditional access policy '{0}' disabled" -f $conditionalAccessPolicy.DisplayName) -Level Debug;

                # Set condition.
                $policyEnabled = $false;
            }

            # If the policy is not applied to all users.
            if ($conditionalAccessPolicy.Conditions.Users.IncludeUsers -ne 'All')
            {
                # Write to log.
                Write-Log -Category 'Entra' -Subcategory 'Policy' -Message ("Conditional access policy '{0}' is not applied to all users" -f $conditionalAccessPolicy.DisplayName) -Level Debug;

                # Set condition.
                $policyAppliedToAllUsers = $false;
            }
    
            # Else if the policy is excluded from all users.
            if ($conditionalAccessPolicy.Conditions.Users.ExcludeUsers -eq 'All')
            {
                # Write to log.
                Write-Log -Category 'Entra' -Subcategory 'Policy' -Message ("Conditional access policy '{0}' have excluded all users" -f $conditionalAccessPolicy.DisplayName) -Level Debug;

                # Set condition.
                $policyAppliedToAllUsers = $false;
            }

            # If the policy is not applied to the Office 365 cloud app.
            if ($conditionalAccessPolicy.Conditions.Applications.IncludeApplications -ne 'Office365')
            {
                # Write to log.
                Write-Log -Category 'Entra' -Subcategory 'Policy' -Message ("Conditional access policy '{0}' is not applied to Office 365 app" -f $conditionalAccessPolicy.DisplayName) -Level Debug;

                # Set condition.
                $policyAppliedToCloudApp = $false;
            }

            # Else if the policy is excluded from the Office 365 cloud app.
            if ($conditionalAccessPolicy.Conditions.Applications.ExcludeApplications -eq 'Office365')
            {
                # Write to log.
                Write-Log -Category 'Entra' -Subcategory 'Policy' -Message ("Conditional access policy '{0}' have excluded the Office 365 app" -f $conditionalAccessPolicy.DisplayName) -Level Debug;

                # Set condition.
                $policyAppliedToCloudApp = $false;
            }

            # If the policy is not applied to the browser client app.
            if ($conditionalAccessPolicy.Conditions.ClientAppTypes -notcontains 'browser')
            {
                # Write to log.
                Write-Log -Category 'Entra' -Subcategory 'Policy' -Message ("Conditional access policy '{0}' do not have the browser as a client app" -f $conditionalAccessPolicy.DisplayName) -Level Debug;

                # Set condition.
                $policyAppliedConditionClientApp = $false;
            }

            # If the session control is not set to enforce application restrictions.
            if ($false -eq $conditionalAccessPolicy.SessionControls.ApplicationEnforcedRestrictions.IsEnabled)
            {
                # Write to log.
                Write-Log -Category 'Entra' -Subcategory 'Policy' -Message ("Conditional access policy '{0}' session control do not have application enforce restriction set" -f $conditionalAccessPolicy.DisplayName) -Level Debug;

                # Set condition.
                $policyAppliedSessionAppEnforceRestrictions = $false;
            }

            # If conditions are met.
            if ($true -eq $policyEnabled -and
                $true -eq $policyAppliedToAllUsers -and
                $true -eq $policyAppliedToCloudApp -and
                $true -eq $policyAppliedConditionClientApp -and
                $true -eq $policyAppliedSessionAppEnforceRestrictions)
            {
                # Write to log.
                Write-Log -Category 'Entra' -Subcategory 'Policy' -Message ("Conditional access policy '{0}' is set to enforce session idle timeout" -f $conditionalAccessPolicy.DisplayName) -Level Debug;

                # Add to list.
                $policies += [PSCustomObject]@{
                    Id          = $conditionalAccessPolicy.Id;
                    DisplayName = $conditionalAccessPolicy.DisplayName;
                    Description = $conditionalAccessPolicy.Description;
                    State       = $conditionalAccessPolicy.State;
                }
            }

            # Write to log.
            Write-Log -Category 'Entra' -Subcategory 'Policy' -Message ('Found {0} that is set to enforce session idle timenout (enforce app restriction)' -f $policies.Count) -Level Debug;
        }
    }
    END
    {
        # Return policies.
        return $policies;
    }
}
