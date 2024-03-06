function Invoke-ReviewSpoLegacyAuthEnabled
{
    <#
    .SYNOPSIS
        If legacy authentication is enabled in SharePoint Online.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Pnp.PowerShell
    .EXAMPLE
        Invoke-ReviewSpoLegacyAuthEnabled;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ("Getting SharePoint tenant configuration") -Level Debug;

        # Get tenant settings.
        $tenantSettings = Get-PnPTenant;

        # Write to log.
        Write-Log -Category 'SharePoint Online' -Subcategory 'Policies' -Message ("Legacy authentication protocols is '{0}'" -f $tenantSettings.LegacyAuthProtocolsEnabled) -Level Debug;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($true -eq $tenantSettings.LegacyAuthProtocolsEnabled)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                                     
        # Create new review object to return.
        [Review]$review = [Review]::new();
                                             
        # Add to object.
        $review.Id = 'a8f1139f-9e08-4da9-bfea-1ddd811e6d68';
        $review.Category = 'Microsoft SharePoint Admin Center';
        $review.Subcategory = 'Policies';
        $review.Title = "Ensure modern authentication for SharePoint applications is required";
        $review.Data = $tenantSettings | Select-Object -Property LegacyAuthProtocolsEnabled;
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    }
}