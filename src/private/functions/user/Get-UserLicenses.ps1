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