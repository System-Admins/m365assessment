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
        $modules = @{
            'Az.Accounts'                                       = 'latest';
            'Az.Resources'                                      = 'latest';    
            'Microsoft.Graph.Authentication'                    = 'latest';
            'Microsoft.Graph.Groups'                            = 'latest';
            'Microsoft.Graph.Users'                             = 'latest';
            'Microsoft.Graph.Identity.DirectoryManagement'      = 'latest';
            'Microsoft.Graph.Identity.SignIns'                  = 'latest';
            'Microsoft.Graph.Identity.Governance'               = 'latest';
            'Microsoft.Graph.Beta.Identity.DirectoryManagement' = 'latest';
            'Microsoft.Graph.Beta.Reports'                      = 'latest';
            'Microsoft.Graph.Reports'                           = 'latest';
            'ExchangeOnlineManagement'                          = 'latest';
            'PnP.PowerShell'                                    = 'latest';
            'MicrosoftTeams'                                    = 'latest';
        };

        # If we should reinstall the modules.
        if ($true -eq $Reinstall)
        {
            # Foreach module.
            foreach ($module in $modules.GetEnumerator())
            {
                # Try to uninstall.
                try
                {
                    # Write to log.
                    Write-Log -Category 'Module' -Subcategory $module.Key -Message ('Uninstalling PowerShell module') -Level Debug;

                    # Remove module from session.
                    Remove-Module -Name $module.Key -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null;

                    # Uninstall module.
                    Uninstall-Module -Name $module.Key -Force -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -AllVersions -Confirm:$false | Out-Null;
                }
                # Something went wrong removing the module.
                catch
                {
                    # Write warning.
                    Write-Log -Category 'Module' -Subcategory $module.Key -Message ('Something went wrong uninstalling PowerShell module') -Level Warning;
                }
            }
        }

        # Get all installed modules.
        $installedModules = Get-Module -ListAvailable;
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'Module' -Message ('Trusting PowerShell repository PSGallery') -Level Debug;

        # Trust the PSGallery.
        Set-PSRepository -InstallationPolicy Trusted -Name PSGallery | Out-Null;

        # Loop through all required modules.
        foreach ($module in $modules.GetEnumerator())
        {
            # Boolean to check if module is installed.
            $moduleInstalled = $false;

            # Loop through all installed modules.
            foreach ($installedModule in $installedModules)
            {
                # Check if module is installed.
                if ($installedModule.Name -eq $module.Key)
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
                    if ('latest' -eq $module.Value)
                    {
                        # Write to log.
                        Write-Log -Category 'Module' -Subcategory $module.Key -Message ('Trying to install PowerShell module') -Level Debug;

                        # Install module.
                        Install-Module -Name $module.Key `
                            -Force `
                            -Scope CurrentUser `
                            -AcceptLicense `
                            -SkipPublisherCheck `
                            -Confirm:$false `
                            -ErrorAction Stop `
                            -WarningAction SilentlyContinue | Out-Null;
                    }
                    # Else specific version should be installed.
                    else
                    {
                        # Write to log.
                        Write-Log -Category 'Module' -Subcategory $module.Key -Message ("Trying to install PowerShell module using version '{0}'" -f $module.Value) -Level Debug;

                        # Install module with specific version.
                        Install-Module -Name $module.Key `
                            -Force `
                            -Scope CurrentUser `
                            -AcceptLicense `
                            -SkipPublisherCheck `
                            -Confirm:$false `
                            -RequiredVersion $module.Value `
                            -ErrorAction Stop `
                            -WarningAction SilentlyContinue | Out-Null;
                    }

                    # Write to log.
                    Write-Log -Category 'Module' -Subcategory $module.Key -Message ('Successfully installed PowerShell module') -Level Debug;
                }
                # Something went wrong installing the module
                catch
                {
                    # Throw exception.
                    Write-Log -Category 'Module' -Subcategory $module.Key -Message ("Something went wrong while installing PowerShell module, exception is '{0}'" -f $_) -Level Error;
                }
            }
            # Module is installed.
            else
            {
                # Write to log.
                Write-Log -Category 'Module' -Subcategory $module.Key -Message ('PowerShell module is already installed') -Level Debug;
            }
        }
    }
    END
    {
        # Foreach module.
        foreach ($module in $modules.GetEnumerator())
        {
            # Try to import the module.
            try
            {
                # Write to log.
                Write-Log -Category 'Module' -Subcategory $module.Key -Message ('Importing PowerShell module') -Level Debug;

                # Import the module.
                Import-Module -Name $module.Key -DisableNameChecking -Force -ErrorAction Stop -WarningAction SilentlyContinue -NoClobber | Out-Null;
            }
            # Something went wrong importing the module.
            catch
            {
                # If the error message is not 'Assembly with same name is already loaded'.
                if ($_.Exception.Message -notlike '*Assembly with same name is already loaded*')
                {
                    # Throw exception.
                    Write-Log -Category 'Module' -Subcategory $module.Key -Message ("Something went wrong while importing PowerShell module, exception is '{0}'" -f $_) -Level Error;
                }
                # If the error message is 'Assembly with same name is already loaded'.
                else
                {
                    # Write to log.
                    Write-Log -Category 'Module' -Subcategory $module.Key -Message ("Module '{0}' assembly with same name is already loaded" -f $module.Key) -Level Debug;
                }
            }
        }

        # Implement fix for Pnp.Online
        Install-ModulePnpPowerShellFix;
    }
}