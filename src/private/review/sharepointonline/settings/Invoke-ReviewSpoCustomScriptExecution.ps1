function Invoke-ReviewSpoCustomScriptExecution
{
    <#
    .SYNOPSIS
        Review custom script execution is restricted on site collections.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Pnp.PowerShell
    .EXAMPLE
        Invoke-ReviewSpoCustomScriptExecution;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Settings' -Message ('Getting all SharePoint sites') -Level Debug;

        # Get all SharePoint sites.
        $sites = Get-PnPTenantSite;

        # Sites with custom script execution disabled.
        $sitesWithCustomScriptExecution = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach site.
        foreach ($site in $sites)
        {
            # If site is not OneDrive.
            if ($site.Template -like 'SPSPERS*')
            {
                # Skip site.
                continue;
            }

            # If "deny add and customize pages" is set to false.
            if ($site.DenyAddAndCustomizePages -eq $false)
            {
                # Write to log.
                Write-Log -Category 'SharePoint Online' -Subcategory 'Settings' -Message ("The SharePoint site '{0}' is set to allow custom script execution" -f $site.Url) -Level Debug;

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
        $review.Id = '6339c889-76d7-450b-855d-b9e22869c94f';
        $review.Category = 'Microsoft SharePoint Admin Center';
        $review.Subcategory = 'Settings';
        $review.Title = 'Ensure custom script execution is restricted on site collections';
        $review.Data = $sitesWithCustomScriptExecution;
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    } 
}