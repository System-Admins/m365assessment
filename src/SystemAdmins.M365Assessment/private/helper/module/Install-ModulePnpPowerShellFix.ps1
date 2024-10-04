function Install-ModulePnpPowerShellFix
{
    <#
    .SYNOPSIS
        Due to the PowerShell module Pnp.PowerShell uses an old Microsoft.Graph.Core DLL, we need to replace it.
    .DESCRIPTION
        Copy files from the Microsoft.Graph.Authentication module into Pnp.PowerShell and replacing existing required DLLs.
        See status of the bug here:
        https://github.com/pnp/powershell/issues/3637
    .EXAMPLE
        Install-ModulePnpPowerShellFix
    #>
    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-CustomLog -Category 'Module' -Subcategory "Pnp.PowerShell" -Message 'Removing modules "Microsoft.Graph.Authentication" and "PnP.PowerShell" from current session' -Level Verbose;

        # Remove modules from current session.
        Remove-Module -Name Microsoft.Graph.Authentication -Force -ErrorAction SilentlyContinue;
        Remove-Module -Name PnP.PowerShell -Force -ErrorAction SilentlyContinue;
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category 'Module' -Subcategory "Pnp.PowerShell" -Message 'Copying DLLs from "Microsoft.Graph.Authentication" to "PnP.PowerShell"' -Level Verbose;

        # Get modules.
        $moduleMgGraphAuthentication = Get-Module -Name Microsoft.Graph.Authentication -ListAvailable | Select-Object -First 1;
        $modulePnpPowerShell = Get-Module -Name PnP.PowerShell -ListAvailable | Select-Object -First 1;

        # Path for DLLs.
        $sourceCoreDll = Join-Path -Path $moduleMgGraphAuthentication.ModuleBase -ChildPath 'Dependencies/Core/Microsoft.Graph.Core.dll';
        $sourceClientDll = Join-Path -Path $moduleMgGraphAuthentication.ModuleBase -ChildPath 'Dependencies/Core/Microsoft.Identity.Client.dll';
        $destinationCoreDll = Join-Path -Path $modulePnpPowerShell.ModuleBase -ChildPath 'Core/Microsoft.Graph.Core.dll';
        $destinationClientDll = Join-Path -Path $modulePnpPowerShell.ModuleBase -ChildPath 'Core/Microsoft.Identity.Client.dll';

        # Copy the files.
        Copy-Item -Path $sourceCoreDll -Destination $destinationCoreDll -Force -Confirm:$false;
        Copy-Item -Path $sourceClientDll -Destination $destinationClientDll -Force -Confirm:$false;
    }
    END
    {
        # Write to log.
        Write-CustomLog -Category 'Module' -Subcategory "Pnp.PowerShell" -Message 'Importing module "Microsoft.Graph.Authentication" and "PnP.PowerShell" again' -Level Verbose;

        # Import modules again.
        Import-Module -Name Microsoft.Graph.Authentication -Force;
        Import-Module -Name PnP.PowerShell -Force;
    }
}