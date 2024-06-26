function Get-TenantOfficeFormSetting
{
    <#
    .SYNOPSIS
        Get the Microsoft Forms tenant settings.
    .DESCRIPTION
        Return the settings of the tenant Microsoft Forms settings.
    .EXAMPLE
        Get-TenantOfficeFormSetting;
    #>
    [cmdletbinding()]
    param
    (
    )
    BEGIN
    {
        # URL to Office 365 Management API for getting the setting.
        [string]$uri = 'https://admin.microsoft.com/admin/api/settings/apps/officeforms';
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category 'Microsoft Forms' -Subcategory 'Policy' -Message ('Getting tenant settings') -Level Verbose;

        # Invoke the API.
        $settings = Invoke-Office365ManagementApi -Uri $uri -Method 'GET';

        # If the response is null.
        if ($null -eq $settings)
        {
            # Throw exception.
            throw ("Something went wrong getting organization Microsoft Form settings")
        }
    }
    END
    {
        # Return settings.
        return $settings;
    }
}