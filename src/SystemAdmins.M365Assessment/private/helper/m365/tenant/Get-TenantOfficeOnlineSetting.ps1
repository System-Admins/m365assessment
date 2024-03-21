function Get-TenantOfficeOnlineSetting
{
    <#
    .SYNOPSIS
        Get the organization "Microsoft 365 On the Web" settings.
    .DESCRIPTION
        Return the settings of the organization "Microsoft 365 On the Web" settings.
    .EXAMPLE
        Get-MicrosoftFormsSettings;
    #>
    [cmdletbinding()]
    param
    (
    )
    BEGIN
    {
        # URL for "Let users open files stored in third-party storage services in Microsoft 365 on the web".
        [string]$thirdPartyStorageUri = 'https://admin.microsoft.com/admin/api/settings/apps/officeonline';
    }
    PROCESS
    {
        # Invoke the API.
        $thirdPartyStorage = Invoke-Office365ManagementApi -Uri $thirdPartyStorageUri -Method 'GET';

        # Create a custom object.
        $response = [PSCustomObject]@{
            thirdPartyStorageEnabled = $thirdPartyStorage.Enabled;
        };
    }
    END
    {
        # Return the value.
        return $response;
    }
}