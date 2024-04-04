function Get-M365Module
{
    <#
    .SYNOPSIS
        Check if modules is installed required by the module.
    .DESCRIPTION
        Returns true or false based the required modules are installed.
    .EXAMPLE
        Get-M365Module
    #>
    [cmdletbinding()]
    [OutputType([System.Collections.ArrayList])]
    param
    (
        # Modules to check.
        [Parameter(Mandatory = $false)]
        [PSCustomObject]$Modules = $Script:Modules
    )

    BEGIN
    {
        # Get all installed modules.
        $installedModules = Get-Module -ListAvailable;

        # Object array for valid modules.
        $validModules = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Loop through all required modules.
        foreach ($module in $modules.PSObject.Properties)
        {
            # Get module name and version.
            $moduleName = $module.Name;
            $moduleVersion = $module.Value;

            # Variables to check version installed.
            $installedVersion = $null;
            $targetVersion = $null;
            $valid = $false;

            # Get latest module version from PowerShell Gallery.
            $psGalleryModule = Find-Module -Name $moduleName -Repository PSGallery -ErrorAction SilentlyContinue;

            # Find module if installed.
            $installedModule = $installedModules | Where-Object -FilterScript { $_.Name -eq $moduleName };

            # If module is installed.
            if ($null -ne $installedModule)
            {
                # Get installed version.
                $installedVersion = $installedModule.Version;

                # Write to log.
                Write-CustomLog -Category 'Module' -Subcategory $moduleName -Message ('Module is installed') -Level Verbose;
            }
            else
            {
                # Write to log.
                Write-CustomLog -Category 'Module' -Subcategory $moduleName -Message ('Module is not installed') -Level Verbose;
            }

            # If target version is latest.
            if ('latest' -eq $moduleVersion)
            {
                # Set target version to latest version from PowerShell Gallery.
                $targetVersion = $psGalleryModule.Version;
            }
            # Else set target version to the version specified.
            else
            {
                # Set target version to the version specified.
                $targetVersion = $moduleVersion;
            }

            # If installed version and target version is the same.
            if ($null -ne $installedModule -and $installedVersion -eq $targetVersion)
            {
                # Set valid to false.
                $valid = $true;

                # Write to log.
                Write-CustomLog -Category 'Module' -Subcategory $moduleName -Message ('Module is installed in correct version') -Level Verbose;
            }
            # Else if installed version and target version is not the same.
            elseif ($null -ne $installedModule -and $installedVersion -ne $targetVersion)
            {
                # Write to log.
                Write-CustomLog -Category 'Module' -Subcategory $moduleName -Message ('Module is installed in incorrect version') -Level Verbose;
            }

            # Add to object array.
            $null = $validModules.Add([PSCustomObject]@{
                    Name             = $moduleName;
                    Version          = $moduleVersion;
                    InstalledVersion = $installedVersion;
                    TargetVersion    = $targetVersion;
                    LatestVersion    = $psGalleryModule.Version;
                    Valid            = $valid;
                }
            );
        }
    }
    END
    {
        # Not correct modules.
        $missingModules = $validModules | Where-Object { $_.Valid -eq $false };

        # If there are missing modules.
        if ($missingModules | Where-Object { $_.Valid -eq $false })
        {
            # Foreach missing module.
            foreach ($missingModule in $missingModules)
            {
                # Write to log.
                Write-CustomLog -Category 'Module' -Subcategory $missingModule.Name -Message ('Module not installed or correct version') -Level Verbose;
            }
        }

        # Return modules.
        return $validModules;
    }
}