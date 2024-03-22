function Get-EntraIdApplicationUserConsentSetting
{
    <#
    .SYNOPSIS
        Return the state of the setting 'user consent to apps'.
    .DESCRIPTION
        Returns either "Do not allow user consent", "Allow user consent for apps from verified publishers, for selected permissions (Recommended)" or "Allow user consent for apps".
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Identity.SignIns
    .EXAMPLE
        Get-EntraIdApplicationUserConsentSetting;
    #>

    [cmdletbinding()]
    [OutputType([string])]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Policy' -Message 'Getting user consent setting' -Level Debug;

        # Get auth policy.
        $authorizationPolicy = Get-MgPolicyAuthorizationPolicy;

        # Current state.
        [string]$setting = '';
    }
    PROCESS
    {
        # If "Allow user consent for apps".
        if ($authorizationPolicy.DefaultUserRolePermissions.PermissionGrantPoliciesAssigned -eq 'ManagePermissionGrantsForSelf.microsoft-user-default-legacy')
        {
            # Set the state.
            $setting = 'AllowUserConsentForApps';
        }
        # Else if "Allow user consent for apps from verified publishers, for selected permissions".
        elseif ($authorizationPolicy.DefaultUserRolePermissions.PermissionGrantPoliciesAssigned -eq 'ManagePermissionGrantsForSelf.microsoft-user-default-low')
        {
            # Set the state.
            $setting = 'AllowUserConsentForSelectedPermissions';
        }
        # Else if "Do not allow user consent".
        else
        {
            # Set the state.
            $setting = 'DoNotAllowUserConsent';
        }

        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Policy' -Message ("User consent setting is '{0}'" -f $setting) -Level Debug;
    }
    END
    {
        # Return state.
        return $setting;
    }
}