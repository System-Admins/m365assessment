function Invoke-ReviewPurviewDlpPolicyEnabled
{
    <#
    .SYNOPSIS
        Check if DLP policies are enabled.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewPurviewDlpPolicyEnabled;
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
        $dlpPolicies = Get-DlpCompliancePolicy;
    }
    PROCESS
    {
        # Get only enabled policies.
        $enabledPolicies = $dlpPolicies | Where-Object { $_.Enabled -eq $true };

        # Write to log.
        Write-Log -Category 'Microsoft Purview' -Subcategory 'Data Loss Prevention' -Message ("Found {0} enabled DLP policies" -f $enabledPolicies.Count) -Level Debug;
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
        $review.Id = 'b9caf88c-0c9c-42a8-b6be-14953a8b76c3';
        $review.Category = 'Microsoft Purview';
        $review.Subcategory = 'Data Loss Prevention';
        $review.Title = 'Ensure DLP policies are enabled';
        $review.Data = $dlpPolicies;
        $review.Review = $reviewFlag;
        
        # Print result.
        $review.PrintResult();
                       
        # Return object.
        return $review;
    }
}