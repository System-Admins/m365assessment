function Get-EntraIdApplicationDirectorySettings
{
    <#
    .SYNOPSIS
        Get the directory setting (consent).
    .DESCRIPTION
        Returns directory settings as PSCustomObject.
    .EXAMPLE
        Get-EntraIdApplicationDirectorySettings;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get directory settings.
        $directorySettings = Get-MgBetaDirectorySetting -All;

        # Settings to return.
        $settings = [PSCustomObject]@{};
    }
    PROCESS
    {
        # Foreach value.
        foreach ($directorySetting in $directorySettings.Values)
        {
            # Add the setting to the object.
            $settings | Add-Member -MemberType NoteProperty -Name $directorySetting.Name -Value $directorySetting.Value -Force;
        }
    }
    END
    {
        # Return object.
        return $settings;
    }
}