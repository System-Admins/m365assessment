function Invoke-ReviewOneDriveCustomScriptExecution
{
    <#
    .SYNOPSIS
        Review custom script execution is restricted on personal sites.
    .DESCRIPTION
        Return list of sites with script execution enabled.
    .EXAMPLE
        Invoke-ReviewOneDriveCustomScriptExecution;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get all SharePoint sites.
        $sites = Get-PnpTenantSite -IncludeOneDriveSites;

        # Sites with custom script execution disabled.
        $sitesWithCustomScriptExecution = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach site.
        foreach ($site in $sites)
        {
            # If site is not OneDrive.
            if ($site.Template -notlike "SPSPERS*")
            {
                # Skip site.
                continue;
            }

            # If "deny add and customize pages" is set to false.
            if ($site.DenyAddAndCustomizePages -eq $false)
            {
                # Add site to list.
                $sitesWithCustomScriptExecution.Add($site) | Out-Null;
            }
        }
    }
    END
    {
        # Return list.
        return $sitesWithCustomScriptExecution;
    } 
}