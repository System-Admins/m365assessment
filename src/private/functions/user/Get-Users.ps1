function Get-UsersWithAdminRole
{
    <#
    .SYNOPSIS
        Get users with admin roles.
    .DESCRIPTION
        Get all users with admin roles and returns object array
    .EXAMPLE
        $usersWithAdminRoles = Get-UsersWithAdminRole;
    #>
    [cmdletBinding()]
    param
    ( 
    )

    BEGIN
    {
        # Object array to store users with admin roles.
        $usersWithAdminRoles = New-Object System.Collections.ArrayList;

        # Get all users.
        $users = Get-MgUser -All;

        # Get all roles.
        $roles = Get-MgDirectoryRole -All;
    }
    PROCESS
    {
        # Foreach role.
        foreach ($role in $roles)
        {
            # Get role members.
            $roleMembers = Get-MgDirectoryRoleMember -DirectoryRoleId $role.Id;

            # Foreach role member.
            foreach ($roleMember in $roleMembers)
            {
                # Get user.
                $user = $users | Where-Object { $_.Id -eq $roleMember.Id };

                # If user is null.
                if ($null -eq $user)
                {
                    # Continue to next role member.
                    continue;
                }

                # If user is not already in the list.
                if ($usersWithAdminRoles -notcontains $user)
                {
                    # Cloud native.
                    [bool]$cloudOnly = $false;

                    # If the user is cloud only.
                    if ($null -eq $user.OnPremisesSyncEnabled)
                    {
                        # Set cloud only to true.
                        $cloudOnly = $true;
                    }

                    # Write to log.
                    Write-Log -Message ("User '{0}' have the role '{1}'" -f $user.UserPrincipalName, $role.DisplayName) -Level Debug;

                    # Add user to list.
                    $usersWithAdminRoles += [PSCustomObject]@{
                        Id                = $user.Id;
                        DisplayName       = $user.DisplayName;
                        UserPrincipalName = $user.UserPrincipalName;
                        CloudOnly         = $cloudOnly;
                        RoleDisplayName   = $role.DisplayName;
                        RoleId            = $role.Id;
                    };
                }
            }
        }
    }
    END
    {
        # Return users with admin roles.
        return $usersWithAdminRoles;
    }
}


function Get-UserLicenses
{
    <#
    .SYNOPSIS
        Get one or all users with a license.
    .DESCRIPTION
        Get one or all users with a license and return object array.
    .EXAMPLE
        # Retrieve all users and return the licenses.
        $userLicenses = Get-UserLicenses;
    .EXAMPLE
        # Retrieve a specific user and return the licenses.
        $userLicenses = Get-UserLicenses -UserPrincipalName 'user@domain';
    #>
    [CmdletBinding()]
    Param
    (
        # UserPrincipalName for the user.
        [Parameter(Mandatory = $false)]
        [string[]]$UserPrincipalName
    )
    BEGIN
    {
        # Object array to store users with licenses.
        $userLicenses = New-Object System.Collections.ArrayList;

        # Write to log.
        Write-Log -Message ('Getting all users') -Level Debug;
            
        # Get all users.
        $users = Get-MgUser -All -Select Id, UserPrincipalName, DisplayName, AssignedLicenses;

        # Download the license translation table from Microsoft.
        $translationTable = Get-LicenseTranslationTable;
    }
    PROCESS
    {
        # Foreach user.
        foreach ($user in $users)
        {
            # If UserPrincipalName is not empty.
            if ($UserPrincipalName.Count -gt 0)
            {
                # If the user is not in the list.
                if ($UserPrincipalName -notcontains $user.UserPrincipalName)
                {
                    # Continue to next user.
                    continue;
                }
            }

            # Write to log.
            Write-Log -Message ("Getting license information for user '{0}'" -f $user.UserPrincipalName) -Level Debug;

            # Get user license details.
            $licenseDetails = Get-MgUserLicenseDetail -UserId $user.Id -All -PageSize 500;

            # Foreach license details.
            foreach ($licenseDetail in $licenseDetails)
            {
                # Foreach service plan.
                foreach ($servicePlan in $licenseDetail.ServicePlans)
                {
                    # Match license from translation table.
                    $license = $translationTable | Where-Object { $_.GUID -eq $licenseDetail.SkuId -and $_.Service_Plan_Id -eq $servicePlan.ServicePlanId };

                    # Foreach license from the translation table.
                    foreach ($license in $translationTable)
                    {
                        # If the license SkuId dont match.
                        if ($licenseDetail.SkuId -ne $license.GUID)
                        {
                            # Continue to next license.
                            continue;
                        }

                        # If the service plan dont match.
                        if ($servicePlan.ServicePlanId -ne $license.Service_Plan_Id)
                        {
                            # Continue to next license.
                            continue;
                        }

                        # If license is not null.
                        if ($null -ne $license)
                        {
                            # Add object to array.
                            $userLicenses += [PSCustomObject]@{
                                UserId                        = $user.Id;
                                UserPrincipalName             = $user.UserPrincipalName;
                                UserDisplayName               = $user.DisplayName;
                                LicenseSkuId                  = $licenseDetail.SkuId;
                                LicenseName                   = $license.Product_Display_Name;
                                LicenseSkuPartNumber          = $licenseDetail.SkuPartNumber;
                                ServicePlanId                 = $servicePlan.ServicePlanId;
                                ServicePlanName               = $servicePlan.ServicePlanName;
                                ServicePlanProvisioningStatus = $servicePlan.ProvisioningStatus;
                                ServicePlanFriendlyName       = $license.Service_Plans_Included_Friendly_Names;
                            };
                        }
                    }
                }
            }
            
        }
    }
    END
    {
        # If the user license array is not empty.
        if ($userLicenses.Count -gt 0)
        {
            # Return the user license array.
            return $userLicenses;
        }
    }
}

function Get-GuestUsers
{
    <#
    .SYNOPSIS
        Returns all guest users.
    .DESCRIPTION
        Get all guest users and returns object array with information like last login date.
    .EXAMPLE
        $guestUsers = Get-GuestUsers;
    #>
    [cmdletBinding()]
    param
    ( 
    )

    BEGIN
    {
        # Properties to get.
        $property = @(
            "Id",
            "UserPrincipalName",
            "GivenName",
            "Surname",
            "DisplayName",
            "SignInActivity",
            "CreatedDateTime",
            "AccountEnabled"
        );
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Message ('Getting all guest users') -Level Debug;

        # Get all users
        $guestUsers = Get-MgUser -All -Filter { userType eq 'Guest' } -Property $property;

        # Write to log.
        Write-Log -Message ('Found {0} guest users' -f $guestUsers.Count) -Level Debug;
    }
    END
    {
        # Return guest users.
        return $guestUsers;
    }
}