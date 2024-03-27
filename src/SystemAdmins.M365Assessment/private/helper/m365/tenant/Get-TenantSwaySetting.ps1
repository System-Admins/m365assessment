function Get-TenantSwaySetting
{
    <#
    .SYNOPSIS
        Get the organization Microsoft Sway settings.
    .DESCRIPTION
        Return the settings of the organization Microsoft Sway settings.
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
        [string]$uri = 'https://admin.microsoft.com/admin/api/settings/apps/Sway';
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category "Microsoft Sway" -Subcategory "Settings" -Message ("Getting Microsoft Sway settings") -Level Debug;

        # Invoke the API.
        $response = Invoke-Office365ManagementApi -Uri $uri -Method 'GET';

        # If the response is null.
        if ($null -eq $response)
        {
            # Throw exception.
            throw ("Something went wrong getting organization Microsoft Sway settings");
        }
    }
    END
    {
        # Return the value.
        return $response;
    }
}