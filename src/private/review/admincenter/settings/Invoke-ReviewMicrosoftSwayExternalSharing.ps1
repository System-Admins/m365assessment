function Invoke-ReviewMicrosoftSwayExternalSharing
{
    <#
    .SYNOPSIS
        Review that Sway cannot be shared with people outside of your organization.
    .DESCRIPTION
        Check if "Let people in your organization share their sways with people outside your organization" is enabled.
        Return true if it's enabled, otherwise false.
    .EXAMPLE
        Invoke-ReviewMicrosoftSwayExternalSharingDisabled;
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
        $settings = Get-TenantSwaySetting;
    }
    END
    {
        # Return value.
        return $settings.ExternalSharingEnabled;
    }
}