function Invoke-ReviewCalendarExternalSharing
{
    <#
    .SYNOPSIS
        Return true or false if calendar external sharing is enabled.
    .DESCRIPTION
        Uses Office 365 Management API to get the setting.
    .EXAMPLE
        Invoke-ReviewCalendarExternalSharing;
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
        # Get the organization calendar settings.
        $settings = Get-CalendarSharingSettings;
    }
    END
    {
        # Return enable calendar sharing setting.
        return [bool]$settings.EnableCalendarSharing;
    }
}