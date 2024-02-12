function Invoke-ReviewAdminAccountCloudOnly
{
    <#
    .SYNOPSIS
        Ensure Administrative accounts are separate and cloud-only.
    .DESCRIPTION
        Ensure administrative accounts are licensed without attached applications and cloud-only.
        Returns a list of administrative accounts that should be reviewed.
    .EXAMPLE
        # Ensure administrative accounts are separate and cloud-only.
        Invoke-ReviewAdminAccountCloudOnly;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Object array to store the admin accounts.
        $adminAccounts = New-Object System.Collections.ArrayList;

        # Object array to store the admin accounts that should be reviewed.
        $reviewAdminAccounts = New-Object System.Collections.ArrayList;

        # Allowed licenses for admin accounts.
        $allowedServicePlanName = @(
            'AAD_PREMIUM',
            'AAD_PREMIUM_P2'
        );

        # Get all users with admin roles.
        $usersWithAdminRole = Get-EntraIdUserAdminRole;
    }
    PROCESS
    {
        # Foreach user with admin role.
        foreach ($userWithAdminRole in $usersWithAdminRole)
        {
            # Get user from admin account.
            $adminAccount = $adminAccounts | Where-Object { $_.UserPrincipalName -eq $userWithAdminRole.UserPrincipalName };

            # If the users is not already in the list.
            if ($null -eq $adminAccount)
            {
                # Add to object array.
                $adminAccounts += [PSCustomObject]@{
                    Id                = $userWithAdminRole.Id;
                    UserPrincipalName = $userWithAdminRole.UserPrincipalName;
                    DisplayName       = $userWithAdminRole.DisplayName;
                    CloudOnly         = $userWithAdminRole.CloudOnly;
                    AccountEnabled    = $userWithAdminRole.AccountEnabled;
                    Roles             = @(
                        [PSCustomObject]@{
                            RoleId          = $userWithAdminRole.RoleId;
                            RoleDisplayName = $userWithAdminRole.RoleDisplayName;
                        }
                    );
                };
            }
            # If the user is already in the list.
            else
            {
                # Add to user roles.
                $adminAccounts[$adminAccounts.IndexOf($userWithAdminRole)].Roles += [PSCustomObject]@{
                    RoleId          = $userWithAdminRole.RoleId;
                    RoleDisplayName = $userWithAdminRole.RoleDisplayName;
                };
            }
        }

        # Get all licenses for the admin accounts.
        $userLicenses = Get-EntraIdUserLicense -UserPrincipalName ($adminAccounts.UserPrincipalName);

        # Foreach admin account.
        foreach ($adminAccount in $adminAccounts)
        {
            # Boolean to determine recommendations.
            [bool]$cloudOnly = $true;
            [bool]$licenseValid = $true;

            # If the admin account is not cloud only.
            if ($false -eq $adminAccount.CloudOnly)
            {
                # Set cloud only to false.
                $cloudOnly = $false;
            }

            # Foreach license.
            foreach ($userLicense in $userLicenses)
            {
                # If the user license is not for the admin account.
                if ($adminAccount.UserPrincipalName -ne $userLicense.UserPrincipalName)
                {
                    # Continue to next license.
                    continue;
                }

                # If license service is not enabled.
                if ($userLicense.ServicePlanProvisioningStatus -ne 'Success')
                {
                    # Continue to next license.
                    continue;
                }

                # If license is not on allowed list.
                if ($allowedServicePlanName -notcontains $userLicense.ServicePlanName)
                {
                    # Set license to be invalid.
                    $licenseValid = $false;
                } 
            }

            # If the recommendations is not fulfilled and account is enabled.
            if (($false -eq $cloudOnly -or $false -eq $licenseValid) -and
                $adminAccount.AccountEnabled -eq $true)
            {
                # Get all roles for the admin account.
                $roles = ($adminAccount.Roles | Select-Object -ExpandProperty RoleDisplayName -Unique) -join ',';

                # Get all licenses.
                $licenses = ($userLicenses | Where-Object { $_.UserPrincipalName -eq $adminAccount.UserPrincipalName } | Select-Object -ExpandProperty LicenseName -Unique);

                # Add to object array.
                $reviewAdminAccounts += [PSCustomObject]@{
                    Id                = $adminAccount.Id;
                    UserPrincipalName = $adminAccount.UserPrincipalName;
                    DisplayName       = $adminAccount.DisplayName;
                    CloudOnly         = $adminAccount.CloudOnly;
                    Roles             = $roles;
                    Licenses          = $licenses;
                    AccountEnabled    = $adminAccount.AccountEnabled;
                };
            }
        }
    }
    END
    {
        # If there are admin accounts that should be reviewed.
        if ($reviewAdminAccounts.Count -gt 0)
        {
            # Return admin accounts that should be reviewed.
            return $reviewAdminAccounts;
        }
    }
}