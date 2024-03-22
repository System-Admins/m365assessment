function Import-M365Module
{
    <#
    .SYNOPSIS
        Import PowerShell required modules.
    .DESCRIPTION
        Imports PowerShell modules from Microsoft required to run the project.
    .PARAMETER Modules
        Modules to import.
    .EXAMPLE
        # Import required modules.
        Import-M365Module;
    .EXAMPLE
        # Import required modules with specific versions.
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
        # Modules to install.
        [Parameter(Mandatory = $false)]
        [PSCustomObject]$Modules = $Script:Modules
    )

    BEGIN
    {
    }
    PROCESS
    {
        # Foreach module.
        foreach ($module in $Modules.PSObject.Properties)
        {
            # Get module name.
            $moduleName = $module.Name;
            $moduleVersion = $module.Version;

            # Try to import the module.
            try
            {
                # Write to log.
                Write-Log -Category 'Module' -Subcategory $moduleName -Message ("Importing PowerShell module with version '{0}'" -f $moduleVersion) -Level Debug;

                # If specific version is set.
                if ('latest' -ne $moduleVersion)
                {
                    # Import the module with specific version.
                    $null = Import-Module -Name $moduleName -RequiredVersion $moduleVersion -DisableNameChecking -Force -ErrorAction Stop -WarningAction SilentlyContinue -NoClobber;
                }
                # Else use latest.
                else
                {
                    # Import the module.
                    $null = Import-Module -Name $moduleName -DisableNameChecking -Force -ErrorAction Stop -WarningAction SilentlyContinue -NoClobber;
                }
            }
            # Something went wrong importing the module.
            catch
            {
                # If the error message is not 'Assembly with same name is already loaded'.
                if ($_.Exception.Message -notlike '*Assembly with same name is already loaded*')
                {
                    # Throw exception.
                    Write-Log -Category 'Module' -Subcategory $moduleName -Message ("Something went wrong while importing PowerShell module, exception is '{0}'" -f $_) -Level Error;
                }
                # If the error message is 'Assembly with same name is already loaded'.
                else
                {
                    # Write to log.
                    Write-Log -Category 'Module' -Subcategory $moduleName -Message ("Module '{0}' assembly with same name is already loaded" -f $moduleName) -Level Debug;
                }
            }
        }
    }
    END
    {
    }
}