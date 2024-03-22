function Invoke-ReviewPurviewUnifiedAuditLogIsEnabled
{
    <#
    .SYNOPSIS
        Review Microsoft Purview audit log search is Enabled.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewPurviewUnifiedAuditLogIsEnabled;
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
        Write-Log -Category 'Microsoft Purview' -Subcategory 'Audit' -Message 'Getting unified audit log configuration' -Level Debug;

        # Get the unified audit log configuration.
        $adminAuditLogConfig = Get-AdminAuditLogConfig;

        # Write to log.
        Write-Log -Category 'Microsoft Purview' -Subcategory 'Audit' -Message ("Unified audit log enable status is '{0}'" -f $adminAuditLogConfig.UnifiedAuditLogIngestionEnabled) -Level Debug;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $adminAuditLogConfig.UnifiedAuditLogIngestionEnabled)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '55299518-ad01-4532-aa35-422fd962c881';
        $review.Category = 'Microsoft Purview';
        $review.Subcategory = 'Audit';
        $review.Title = 'Ensure Microsoft 365 audit log search is Enabled';
        $review.Data = [PSObject]@{
            'Enabled' = $adminAuditLogConfig.UnifiedAuditLogIngestionEnabled;
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}