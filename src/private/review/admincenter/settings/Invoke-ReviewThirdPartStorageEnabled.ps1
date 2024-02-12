function Invoke-ReviewThirdPartStorageEnabled
{
    <#
    .SYNOPSIS
        Ensure 'third-party storage services' are restricted in 'Microsoft 365 on the web'
    .DESCRIPTION
        Check if "third-party storage services" is enabled.
        Return true if it's enabled, otherwise false.
    .EXAMPLE
        Invoke-ReviewThirdPartStorageEnabled;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
    }
    PROCESS
    {
        # Get settings.
        $settings = Get-TenantOfficeOnlineSetting;
    }
    END
    {
        # Return value.
        return $settings.thirdPartyStorageEnabled;
    }
}