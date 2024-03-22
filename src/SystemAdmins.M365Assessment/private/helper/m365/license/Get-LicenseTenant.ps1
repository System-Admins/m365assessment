function Get-LicenseTenant
{
    <#
    .SYNOPSIS
        Get licenses available in the Microsoft 365 tenant.
    .DESCRIPTION
        Returns list of licenses in the tenant.
    .EXAMPLE
        Get-LicenseTenant;
    #>

    [cmdletbinding()]
    [OutputType([System.Object[]])]
    param
    (

    )
    BEGIN
    {
        # Get all licenses.
        $licenses = Get-MgSubscribedSku -All;

        # Get license translations.
        $licenseTranslations = Get-LicenseTranslation;

        # Object array to get user friendly licenses.
        $licenseList = @();
    }
    PROCESS
    {
        # Foreach license.
        foreach ($license in $licenses)
        {
            # Foreach service plan.
            foreach ($servicePlan in $license.ServicePlans)
            {
                # Get the license translation.
                $licenseTranslation = $licenseTranslations | Where-Object { $_.GUID -eq $license.SkuId -and $_.Service_Plan_Id -eq $servicePlan.ServicePlanId };

                # If the license translation is not found.
                if ($null -eq $licenseTranslation)
                {
                    # Continue to the next service plan.
                    continue;
                }

                # Add to the license list.
                $licenseList += [PSCustomObject]@{
                    ProductDisplayName = $licenseTranslation.Product_Display_Name;
                    ProductSkuId = $licenseTranslation.GUID;
                    ProductSkuPartNumber = $licenseTranslation.String_Id;
                    ServicePlanDisplayName = $licenseTranslation.Service_Plans_Included_Friendly_Names;
                    ServicePlanId = $licenseTranslation.Service_Plan_Id;
                    ServicePlanName = $licenseTranslation.Service_Plan_Name;
                };
            }
        }
    }
    END
    {
        # Return licenses.
        return $licenseList;
    }
}