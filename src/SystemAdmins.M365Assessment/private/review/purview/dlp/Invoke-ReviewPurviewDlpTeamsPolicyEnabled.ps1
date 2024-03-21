function Invoke-ReviewPurviewDlpTeamsPolicyEnabled
{
    <#
    .SYNOPSIS
        Check if DLP policies are enabled for Microsoft Teams.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewPurviewDlpTeamsPolicyEnabled;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Microsoft Purview' -Subcategory 'Data Loss Prevention' -Message ("Getting DLP policies") -Level Debug;
        
        # Get DLP policies.
        $dlpPolicies = Get-DlpCompliancePolicy -WarningAction SilentlyContinue;
    }
    PROCESS
    {
        # Get only enabled policies.
        $enabledPolicies = $dlpPolicies | Where-Object {$_.Mode -eq 'Enable' -and $_.Workload -like '*Teams*'};

        # Write to log.
        Write-Log -Category 'Microsoft Purview' -Subcategory 'Data Loss Prevention' -Message ("Found {0} enabled Microsoft Teams DLP policies" -f $enabledPolicies.Count) -Level Debug;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($enabledPolicies.Count -eq 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                               
        # Create new review object to return.
        [Review]$review = [Review]::new();
                       
        # Add to object.
        $review.Id = '48d970b5-a31b-41e9-9d66-eb8e02e0546d';
        $review.Category = 'Microsoft Purview';
        $review.Subcategory = 'Data Loss Prevention';
        $review.Title = 'Ensure DLP policies are enabled for Microsoft Teams';
        $review.Data = $dlpPolicies | Select-Object -Property Type, Name, DisplayName, Enabled, Workload;
        $review.Review = $reviewFlag;
        
        # Print result.
        $review.PrintResult();
                       
        # Return object.
        return $review;
    }
}