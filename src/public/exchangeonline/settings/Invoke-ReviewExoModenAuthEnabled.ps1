function Invoke-ReviewExoModenAuthEnabled
{
    <#
    .SYNOPSIS
        If modern authentication is enabled.
    .DESCRIPTION
        Return true if enabled otherwise false.
    .EXAMPLE
        Invoke-ReviewExoModenAuthEnabled;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get all organization settings.
        $organizationSettings = Get-OrganizationConfig;
    }
    PROCESS
    {
        # Get modern authentication settings.
        $modernAuthSettings = $organizationSettings.OAuth2ClientProfileEnabled;
    }
    END
    {
        # Return bool.
        return [bool]$modernAuthSettings;
    } 
}