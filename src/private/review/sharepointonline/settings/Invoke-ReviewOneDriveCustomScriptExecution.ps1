function Invoke-ReviewOneDriveCustomScriptExecution
{
    <#
    .SYNOPSIS
        Review custom script execution is restricted on personal sites.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Pnp.PowerShell
    .EXAMPLE
        Invoke-ReviewOneDriveCustomScriptExecution;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Settings' -Message ('Getting all OneDrive sites') -Level Debug;

        # Get all SharePoint sites.
        $sites = Get-PnPTenantSite -IncludeOneDriveSites;

        # Sites with custom script execution disabled.
        $sitesWithCustomScriptExecution = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach site.
        foreach ($site in $sites)
        {
            # If site is not OneDrive.
            if ($site.Template -notlike 'SPSPERS*')
            {
                # Skip site.
                continue;
            }

            # If "deny add and customize pages" is set to false.
            if ($site.DenyAddAndCustomizePages -eq $false)
            {
                # Write to log.
                Write-Log -Category 'SharePoint Online' -Subcategory 'Settings' -Message ("The OneDrive site '{0}' is set to allow custom script execution" -f $site.Url) -Level Debug;

                # Add site to list.
                $sitesWithCustomScriptExecution.Add($site) | Out-Null;
            }
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($sitesWithCustomScriptExecution.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                                     
        # Create new review object to return.
        [Review]$review = [Review]::new();
                                             
        # Add to object.
        $review.Id = '2f538008-8944-4d45-9b79-4cd771851622';
        $review.Category = 'Microsoft SharePoint Admin Center';
        $review.Subcategory = 'Settings';
        $review.Title = 'Ensure custom script execution is restricted on personal sites';
        $review.Data = $sitesWithCustomScriptExecution | Select-Object -Property Url, DenyAddAndCustomizePages;
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    } 
}