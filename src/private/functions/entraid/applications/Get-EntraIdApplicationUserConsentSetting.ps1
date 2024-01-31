function Get-EntraIdApplicationUserConsentSetting
{
    <#
    .SYNOPSIS
        Return the state of the user consent to apps.
    .DESCRIPTION
        Returns either "Do not allow user consent", "Allow user consent for apps from verified publishers, for selected permissions (Recommended)" or "Allow user consent for apps".
    .EXAMPLE
        Get-EntraIdApplicationUserConsentSetting;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get auth policy.
        $authorizationPolicy = Get-MgPolicyAuthorizationPolicy;

        # Current state.
        [string]$setting = '';
    }
    PROCESS
    {
        # If "Allow user consent for apps".
        if ($authorizationPolicy.DefaultUserRolePermissions.PermissionGrantPoliciesAssigne -eq 'ManagePermissionGrantsForSelf.microsoft-user-default-legacy')
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
        elseif ($authorizationPolicy.DefaultUserRolePermissions.PermissionGrantPoliciesAssigned.Count -eq 0)
        {
            # Set the state.
            $setting = 'DoNotAllowUserConsent';
        }
    }
    END
    {
        # Return state.
        return $setting;
    }
}