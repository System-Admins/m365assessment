function Invoke-ReviewPurviewInformationProtectionLabelPolicy
{
    <#
    .SYNOPSIS
        Check if SharePoint Online Information Protection policies are set up and used.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewPurviewInformationProtectionLabelPolicy;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Microsoft Purview' -Subcategory 'Information Protection' -Message ("Getting label policies") -Level Debug;

        # Get all label policies.
        $labelPolicies = Get-LabelPolicy;

        # Object array for storing policies.
        $policies = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach label policy.
        foreach ($labelPolicy in $labelPolicies)
        {
            # Boolean if the label policy valid.
            $valid = $true;

            # If the label policy is not enabled.
            if($false -eq $labelPolicy.Enabled)
            {
                # Set the policy to invalid.
                $valid = $false;
            }

            # If mode is not set to enforce.
            if('Enforce' -ne $labelPolicy.Mode)
            {
                # Set the policy to invalid.
                $valid = $false;
            }

            # If label policy is valid.
            if($true -eq $valid)
            {
                # Write to log.
                Write-Log -Category 'Microsoft Purview' -Subcategory 'Information Protection' -Message ("Label policy '{0}' is valid" -f $labelPolicy.Name) -Level Debug;

                # Add the policy to the list.
                $policies.Add($labelPolicy) | Out-Null;
            }
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($policies.Count -eq 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                               
        # Create new review object to return.
        [Review]$review = [Review]::new();
                       
        # Add to object.
        $review.Id = 'b01a1187-5921-4b29-95fd-73e1af3c5285';
        $review.Category = 'Microsoft Purview';
        $review.Subcategory = 'Information Protection';
        $review.Title = 'Ensure SharePoint Online Information Protection policies are set up and used';
        $review.Data = $policies;
        $review.Review = $reviewFlag;
        
        # Print result.
        $review.PrintResult();
                       
        # Return object.
        return $review;
    }
}