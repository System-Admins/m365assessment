function Get-TenantOfficeFormSetting
{
    <#
    .SYNOPSIS
        Get the organization Microsoft Forms settings.
    .DESCRIPTION
        Return the settings of the organization Microsoft Forms settings.
    .EXAMPLE
        Get-MicrosoftFormsSettings;
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
        # Invoke the API.
        $response = Invoke-Office365ManagementApi -Uri $uri -Method 'GET';

        # If the response is null.
        if ($null -eq $response)
        {
            # Throw execption.
            Write-Log -Category "Organization" -Message ("Something went wrong getting organization Microsoft Form settings, execption is '{0}'" -f $_) -Level 'Error';
        }
    }
    END
    {
        # Return the value.
        return $response;
    }
}