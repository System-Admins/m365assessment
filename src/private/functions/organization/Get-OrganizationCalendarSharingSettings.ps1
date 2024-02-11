function Get-OrganizationCalendarSharingSettings
{
    <#
    .SYNOPSIS
        Get the organization calendar sharing settings.
    .DESCRIPTION
        Return the settings of the organization sharing settings.
    .EXAMPLE
        Get-OrganizationCalendarSharing;
    #>
    [CmdletBinding()]
    Param
    (
    )
    BEGIN
    {
        # URL to Office 365 Management API for getting the setting.
        [string]$uri = 'https://admin.microsoft.com/admin/api/settings/apps/calendarsharing';
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category "Organization" -Message "Getting calendar sharing settings" -Level Debug;

        # Invoke the API.
        $response = Invoke-Office365ManagementApi -Uri $uri -Method 'GET';

        # If the response is null.
        if ($null -eq $response)
        {
            # Throw execption.
            Write-Log -Category "Organization" -Message ("Something went wrong getting calendar sharing, execption is '{0}'" -f $_) -Level Error;
        }
    }
    END
    {
        # Return the value.
        return $response;
    }
}