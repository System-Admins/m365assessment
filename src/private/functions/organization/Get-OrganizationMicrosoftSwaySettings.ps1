function Get-OrganizationMicrosoftSwaySettings
{
    <#
    .SYNOPSIS
        Get the organization Microsoft Sway settings.
    .DESCRIPTION
        Return the settings of the organization Microsoft Sway settings.
    .EXAMPLE
        Get-MicrosoftFormsSettings;
    #>
    [CmdletBinding()]
    Param
    (
    )
    BEGIN
    {
        # URL to Office 365 Management API for getting the setting.
        [string]$uri = 'https://admin.microsoft.com/admin/api/settings/apps/Sway';
    }
    PROCESS
    {
        # Invoke the API.
        $response = Invoke-Office365ManagementApi -Uri $uri -Method 'GET';

        # If the response is null.
        if ($null -eq $response)
        {
            # Throw execption.
            Write-Log -Category "Organization" -Message ("Something went wrong getting organization Microsoft Sway settings, execption is '{0}'" -f $_) -Level 'Error';
        }
    }
    END
    {
        # Return the value.
        return $response;
    }
}