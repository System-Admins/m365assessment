function Invoke-ReviewExoAuditEnabled
{
    <#
    .SYNOPSIS
        Check if 'AuditDisabled' organizationally is set to 'False'.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewExoAuditEnabled;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Exchange Online' -Subcategory 'Audit' -Message 'Getting organization configuration' -Level Debug;

        # Get organization config.
        $organizationConfig = Get-OrganizationConfig;

        # Boolean if enabled.
        [bool]$enabled = $false;
    }
    PROCESS
    {
        # If 'AuditDisabled' is set to 'False'.
        if ($organizationConfig.AuditDisabled -eq $false)
        {
            # Set to true.
            $enabled = $true;
        }

        # Write to log.
        Write-Log -Category 'Exchange Online' -Subcategory 'Audit' -Message ("Audit feature is set to '{0}'" -f $enabled) -Level Debug;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $enabled)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '7cf11de7-eeb9-4e96-b406-7e69c232a9c0';
        $review.Category = 'Microsoft Exchange Admin Center';
        $review.Subcategory = 'Audit';
        $review.Title = "Ensure 'AuditDisabled' organizationally is set to 'False'";
        $review.Data = [PSCustomObject]@{
            Enabled = $enabled;
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}