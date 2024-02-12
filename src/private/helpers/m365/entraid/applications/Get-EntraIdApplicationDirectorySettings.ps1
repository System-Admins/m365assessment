function Get-EntraIdApplicationDirectorySettings
{
    <#
    .SYNOPSIS
        Get the directory settings.
    .DESCRIPTION
        Returns directory settings as PSCustomObject.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Beta.Identity.DirectoryManagement
    .EXAMPLE
        Get-EntraIdApplicationDirectorySettings;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Entra ID' -Message 'Getting directory settings' -Level Debug;

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