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
        Write-Log -Category 'Module' -Message 'Getting all installed modules' -Level Debug;

        # Get all installed modules.
        $installedModules = Get-InstalledModule;
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'Module' -Message ('Found {0} installed modules' -f $installedModules.Count) -Level Debug;

        # Foreach module installed.
        foreach ($installedModule in $installedModules)
        {
            # Write to log.
            Write-Log -Category 'Module' -Subcategory $installedModule.Name -Message 'Getting all versions' -Level Debug;

            # Get all versions.
            $moduleVersions = Get-InstalledModule -Name $installedModule.Name -AllVersions;

            # Write to log.
            Write-Log -Category 'Module' -Subcategory $installedModule.Name -Message ('Found {0} versions of the module' -f $moduleVersions.Count) -Level Debug;

            # Uninstall all versions of module.
            Uninstall-Module -Name $installedModule.Name -AllVersions -Force -Confirm:$false -WarningAction SilentlyContinue -ErrorAction SilentlyContinue;
        }
    }
    END
    {
        # Write to log.
        Write-Log -Category 'Module' -Message 'Finished removing all user installed modules' -Level Debug;
    }
}