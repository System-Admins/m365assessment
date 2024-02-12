function Uninstall-ModuleAll
{
    <#
    .SYNOPSIS
        Uninstall all user installed modules.
    .DESCRIPTION
        Get all user installed modules and uninstall them.
    .EXAMPLE
        Uninstall-ModuleAll
    #>

    [cmdletbinding()]
    param
    (
    )
    
    BEGIN
    {
        # Write to log.
        Write-Log -Category "Module" -Message "Getting all installed modules";

        # Get all installed modules.
        $installedModules = Get-InstalledModule;
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category "Module" -Message ("Found {0} installed modules" -f $installedModules.Count);

        # Foreach module installed.
        foreach ($installedModule in $installedModules)
        {
            # Write to log.
            Write-Log -Category "Module" -Subcategory $installedModule.Name -Message "Getting all versions";

            # Get all versions.
            $moduleVersions = Get-InstalledModule -Name $installedModule.Name -AllVersions;

            # Write to log.
            Write-Log -Category "Module" -Subcategory $installedModule.Name -Message ("Found {0} versions of the module" -f $moduleVersions.Count);

            # Foreach version.
            foreach($moduleVersion in $moduleVersions)
            {
                # Write to log.
                Write-Log -Category "Module" -Subcategory $installedModule.Name -Message ("Removing version '{0}' from current session" -f $moduleVersion.Version);

                # Remove module from the current session.
                Remove-Module -Name $moduleVersion.Name -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue;

                # Write to log.
                Write-Log -Category "Module" -Subcategory $installedModule.Name -Message ("Uninstalling version '{0}'" -f $moduleVersion.Version);

                # Uninstall module.
                Uninstall-Module -Name $moduleVersion.Name -AllVersions -Force -Confirm:$false -ErrorAction SilentlyContinue -WarningAction SilentlyContinue;
            }
        }
    }
    END
    {
        # Write to log.
        Write-Log -Category "Module" -Message "Finished removing all user installed modules";
    }
}