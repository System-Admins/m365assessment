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
        [switch]$OnlyUnload
    )

    BEGIN
    {
        # Write to log.
        Write-CustomLog -Category 'Module' -Message 'Getting all installed modules' -Level Verbose;

        # Get all installed modules.
        $installedModules = Get-InstalledModule;
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category 'Module' -Message ('Found {0} installed modules' -f $installedModules.Count) -Level Verbose;

        # Foreach module installed.
        foreach ($installedModule in $installedModules)
        {
            # Write to log.
            Write-CustomLog -Category 'Module' -Subcategory $installedModule.Name -Message 'Getting all versions' -Level Verbose;

            # Get all versions.
            $moduleVersions = Get-InstalledModule -Name $installedModule.Name -AllVersions;

            # If only unload.
            if ($false -eq $OnlyUnload)
            {
                # Write to log.
                Write-CustomLog -Category 'Module' -Subcategory $installedModule.Name -Message ('Uninstalling {0} versions of the module' -f $moduleVersions.Count) -Level Verbose;

                # Uninstall all versions of module.
                Uninstall-Module -Name $installedModule.Name -AllVersions -Force -Confirm:$false -WarningAction SilentlyContinue -ErrorAction SilentlyContinue;
            }
        }
    }
    END
    {
        # Write to log.
        Write-CustomLog -Category 'Module' -Message 'Finished removing all user installed modules' -Level Verbose;
    }
}