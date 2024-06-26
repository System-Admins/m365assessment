function Get-EntraIdApplicationDirectorySetting
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
        Get-EntraIdApplicationDirectorySetting;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Application' -Message 'Getting directory settings' -Level Verbose;

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