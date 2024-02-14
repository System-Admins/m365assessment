function Install-Modules
{
    <#
    .SYNOPSIS
        Install PowerShell required modules.
    .DESCRIPTION
        Install PowerShell modules from Microsoft required to run the project.
    .EXAMPLE
        Install-Modules
    #>
    [cmdletbinding()]
    param
    (
        # If the modules should be reinstalled.
        [Parameter(Mandatory = $false)]
        [switch]$Reinstall
    )
    
    BEGIN
    {                
        # Modules to install.
        $modules = @(
            'Az.Accounts',
            'Az.Resources',
            'Microsoft.Graph.Authentication',
            'Microsoft.Graph.Groups'
            'Microsoft.Graph.Users',
            'Microsoft.Graph.Identity.DirectoryManagement',
            'Microsoft.Graph.Identity.SignIns'
            'ExchangeOnlineManagement',
            'PnP.PowerShell',
            'MicrosoftTeams'
        );

        # If we should reinstall the modules.
        if ($true -eq $Reinstall)
        {
            # Foreach module.
            foreach ($module in $modules)
            {
                # Try to uninstall.
                try
                {
                    # Write to log.
                    Write-Log -Category 'Module' -Subcategory $module -Message ('Uninstalling PowerShell module') -Level Debug;

                    # Remove module from session.
                    Remove-Module -Name $module -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null;

                    # Uninstall module.
                    Uninstall-Module -Name $module -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -AllVersions -Confirm:$false | Out-Null;
                }
                # Something went wrong removing the module.
                catch
                {
                    # Write warning.
                    Write-Log -Category 'Module' -Subcategory $module -Message ('Something went wrong uninstalling PowerShell module') -Level Warning;
                }
            }
        }

        # Get all installed modules.
        $installedModules = Get-Module -ListAvailable;
    }
    PROCESS
    {
        # Loop through all required modules.
        foreach ($module in $modules)
        {
            # Boolean to check if module is installed.
            $moduleInstalled = $false;

            # Loop through all installed modules.
            foreach ($installedModule in $installedModules)
            {
                # Check if module is installed.
                if ($installedModule.Name -eq $module)
                {
                    # Set boolean.
                    $moduleInstalled = $true;

                    # Break loop.
                    break;
                }
            }

            # If module is not installed.
            if ($false -eq $moduleInstalled)
            {
                # Try to install the module.
                try
                {
                    # Write to log.
                    Write-Log -Category 'Module' -Subcategory $module -Message ('Trying to install PowerShell module') -Level Debug;

                    # Install module.
                    Install-Module -Name $module -Force -Scope CurrentUser -AcceptLicense -SkipPublisherCheck -Confirm:$false -ErrorAction Stop -WarningAction SilentlyContinue | Out-Null;

                    # Write to log.
                    Write-Log -Category 'Module' -Subcategory $module -Message ('Succesfully installed PowerShell module') -Level Debug;
                }
                # Something went wrong installing the module
                catch
                {
                    # Throw execption.
                    Write-Log -Category 'Module' -Subcategory $module -Message ("Something went wrong while installing PowerShell module, excepction is '{0}'" -f $_) -Level Error;
                }
            }
            # Module is installed.
            else
            {
                # Write to log.
                Write-Log -Category 'Module' -Subcategory $module -Message ('PowerShell module is already installed') -Level Debug;
            }
        }
    }
    END
    {
        # Foreach module.
        foreach ($module in $modules)
        {
            # Try to import the module.
            try
            {
                # Write to log.
                Write-Log -Category 'Module' -Subcategory $module -Message ('Importing PowerShell module') -Level Debug;

                # Import the module.
                Import-Module -Name $module -DisableNameChecking -Force -ErrorAction Stop -WarningAction SilentlyContinue | Out-Null;
            }
            # Something went wrong importing the module.
            catch
            {
                # Throw execption.
                Write-Log -Category 'Module' -Subcategory $module -Message ("Something went wrong while importing PowerShell module, excepction is '{0}'" -f $_) -Level Error;
            }
        }

        # Implement fix for Pnp.Online
        Install-ModulePnpPowerShellFix;
    }
}