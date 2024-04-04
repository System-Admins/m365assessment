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
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name;

        # Get module for Exchange Online (not compliance).
        $eopModule = Get-ConnectionInformation | Where-Object {$_.IsEopSession -eq $false};

        # If the module is not found.
        if ($null -eq $eopModule)
        {
            # Write to log.
            Write-CustomLog -Category 'Microsoft Purview' -Subcategory 'Audit' -Message 'No Exchange Online module found' -Level Error;

            # Return.
            return;
        }

        # Get module name such as "tmpEXO_xxsjbomi.0bi".
        $eopModuleName = ($eopModule.ModuleName.Split("\"))[-1];
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category 'Microsoft Purview' -Subcategory 'Audit' -Message 'Getting unified audit log configuration' -Level Verbose;

        # Construct command.
        $command = ("{0}\Get-AdminAuditLogConfig" -f $eopModuleName);

        # Get the unified audit log configuration (using the Exchange Online PowerShell session and not compliance module).
        # See the important note at "https://learn.microsoft.com/en-us/purview/audit-log-enable-disable?tabs=microsoft-purview-portal#verify-the-auditing-status-for-your-organization" for more information.
        $adminAuditLogConfig = Invoke-Expression -Command $command;

        # Write to log.
        Write-CustomLog -Category 'Microsoft Purview' -Subcategory 'Audit' -Message ("Unified audit log enable status is '{0}'" -f $adminAuditLogConfig.UnifiedAuditLogIngestionEnabled) -Level Verbose;
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

        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}