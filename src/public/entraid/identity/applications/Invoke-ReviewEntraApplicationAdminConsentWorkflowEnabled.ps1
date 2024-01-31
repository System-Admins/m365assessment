function Invoke-ReviewEntraApplicationAdminConsentWorkflowEnabled
{
    <#
    .SYNOPSIS
        If the admin consent workflow is enabled.
    .DESCRIPTION
        Return true or false.
    .EXAMPLE
        Invoke-ReviewEntraApplicationAdminConsentWorkflowEnabled;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get admin consent setting.
        $adminConsentSetting = Get-EntraIdApplicationDirectorySettings;

        # Boolean if enabled.
        $enabled = $false;
    }
    PROCESS
    {
        # If the admin consent workflow is enabled.
        if ($adminConsentSetting.EnableAdminConsentRequests -eq $true)
        {
            # Set enabled to true.
            $enabled = $true;
        }
    }
    END
    {
        # Return state.
        return $enabled;
    }
}