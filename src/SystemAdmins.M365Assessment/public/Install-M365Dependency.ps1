function Install-M365Dependency
{
    <#
    .SYNOPSIS
        Install PowerShell required modules.
    .DESCRIPTION
        Install PowerShell modules from Microsoft required to run the project.
    .PARAMETER Reinstall
        If the modules should be forced reinstalled.
    .PARAMETER Modules
        Modules to install.
    .EXAMPLE
        # Install required modules.
        Install-M365Dependency;
    .EXAMPLE
        # Dont reinstall required modules.
        Install-M365Dependency -Reinstall $false;
    .EXAMPLE
        # Install required modules with specific versions.
        Install-M365Dependency -Modules ([PSCustomObject]@{
            'Microsoft.Graph.Authentication'                    = '1.2.0';
            'Microsoft.Graph.Groups'                            = '1.0.0';
            'Microsoft.Graph.Users'                             = '3.0.0';
            'Microsoft.Graph.Identity.DirectoryManagement'      = 'latest';
            'Microsoft.Graph.Identity.SignIns'                  = '1.0.5';
        });
    #>
    [cmdletbinding()]
    param
    (
        # If the modules should be reinstalled.
        [Parameter(Mandatory = $false)]
        [bool]$Reinstall = $true,

        # Modules to install.
        [Parameter(Mandatory = $false)]
        [PSCustomObject]$Modules = $Script:Modules
    )

    BEGIN
    {
        # If we should reinstall the modules.
        if ($true -eq $Reinstall)
        {
            # Foreach module.
            foreach ($module in $Modules.PSObject.Properties)
            {
                # Get module name.
                $moduleName = $module.Name;

                # Try to uninstall.
                try
                {
                    # Write to log.
                    Write-CustomLog -Category 'Module' -Subcategory $moduleName -Message ('Uninstalling PowerShell module') -Level Verbose;

                    # Remove module from session.
                    $null = Remove-Module -Name $moduleName -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue;

                    # Uninstall module.
                    $null = Uninstall-Module -Name $moduleName -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -AllVersions -Confirm:$false;
                }
                # Something went wrong removing the module.
                catch
                {
                    # Write warning.
                    Write-CustomLog -Category 'Module' -Subcategory $moduleName -Message ('Something went wrong uninstalling PowerShell module') -Level Warning;
                }
            }
        }

        # Get all installed modules.
        $installedModules = Get-Module -ListAvailable;
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category 'Module' -Message ('Trusting PowerShell repository PSGallery') -Level Verbose;

        # Trust the PSGallery.
        $null = Set-PSRepository -InstallationPolicy Trusted -Name PSGallery;

        # Loop through all required modules.
        foreach ($module in $Modules.PSObject.Properties)
        {
            # Get module name and version.
            $moduleName = $module.Name;
            $moduleVersion = $module.Value;

            # Boolean to check if module is installed.
            $moduleInstalled = $false;

            # Loop through all installed modules.
            foreach ($installedModule in $installedModules)
            {
                # Check if module is installed.
                if ($installedModule.Name -eq $moduleName)
                {
                    # Set boolean.
                    $moduleInstalled = $true;

                    # Break foreach loop.
                    break;
                }
            }

            # If module is not installed.
            if ($false -eq $moduleInstalled)
            {
                # Try to install the module.
                try
                {
                    # If latest version should be installed.
                    if ('latest' -eq $moduleVersion)
                    {
                        # Write to log.
                        Write-CustomLog -Category 'Module' -Subcategory $moduleName -Message ('Trying to install PowerShell module') -Level Verbose;

                        # Install module.
                        $null = Install-Module -Name $moduleName `
                            -Force `
                            -AllowClobber:$true `
                            -Scope CurrentUser `
                            -AcceptLicense `
                            -SkipPublisherCheck `
                            -Confirm:$false `
                            -ErrorAction Stop `
                            -WarningAction SilentlyContinue;
                    }
                    # Else specific version should be installed.
                    else
                    {
                        # Write to log.
                        Write-CustomLog -Category 'Module' -Subcategory $moduleName -Message ("Trying to install PowerShell module using version '{0}'" -f $moduleVersion) -Level Verbose;

                        # Install module with specific version.
                        $null = Install-Module -Name $moduleName `
                            -Force `
                            -AllowClobber:$true `
                            -Scope CurrentUser `
                            -AcceptLicense `
                            -SkipPublisherCheck `
                            -Confirm:$false `
                            -RequiredVersion $moduleVersion `
                            -ErrorAction Stop `
                            -WarningAction SilentlyContinue;
                    }

                    # Write to log.
                    Write-CustomLog -Category 'Module' -Subcategory $moduleName -Message ('Successfully installed PowerShell module') -Level Verbose;
                }
                # Something went wrong installing the module
                catch
                {
                    # Throw exception.
                    throw ("Something went wrong while installing PowerShell module, exception is '{0}'" -f $_);
                }
            }
            # Module is installed.
            else
            {
                # Write to log.
                Write-CustomLog -Category 'Module' -Subcategory $moduleName -Message ('PowerShell module is already installed') -Level Verbose;
            }
        }
    }
    END
    {
        # Implement fix for Pnp.Online
        Install-ModulePnpPowerShellFix;
    }
}