function Invoke-ReviewDefenderSafeAttachmentPolicyEnabled
{
    <#
    .SYNOPSIS
        Review the Safe Attachment Policy is enabled and is set to block.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewDefenderSafeAttachmentPolicyEnabled;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Microsoft Defender' -Subcategory 'Policy' -Message 'Getting safe attachment policies' -Level Debug;

        # Get safe attachment policies.
        $safeAttachmentPolicies = Get-SafeAttachmentPolicy;

        # Object array to store policies.
        $policies = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach safe attachment policy.
        foreach ($safeAttachmentPolicy in $safeAttachmentPolicies)
        {
            # Boolean if safe attachment policy is correctly configured.
            $valid = $true;

            # If safe attachment policy is enabled.
            if ($safeAttachmentPolicy.Enable -eq $false)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If action is not block.
            if ($safeAttachmentPolicy.Action -ne 'Block')
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If not valid.
            if ($valid -eq $false)
            {
                # Write to log.
                Write-Log -Category 'Microsoft Defender' -Subcategory 'Policy' -Message ('Safe attachment policy {0} is not correctly configured' -f $safeAttachmentPolicy.Name) -Level Debug;
            }

            # Add to object array.
            $policies += [PSCustomObject]@{
                Guid   = $safeAttachmentPolicy.Guid;
                Id     = $safeAttachmentPolicy.Id;
                Name   = $safeAttachmentPolicy.Name;
                Valid  = $valid;
                Enable = $safeAttachmentPolicy.Enable;
                Action = $safeAttachmentPolicy.Action;
            };
        }
    }
    END
    {
         # Bool for review flag.
         [bool]$reviewFlag = $false;
                    
         # If review flag should be set.
         if ($policies | Where-Object { $_.Valid -eq $false })
         {
             # Should be reviewed.
             $reviewFlag = $true;
         }
                        
         # Create new review object to return.
         [Review]$review = [Review]::new();
                
         # Add to object.
         $review.Id = '383ea8f2-48e1-4a1f-bcc7-626fbeb0f331';
         $review.Category = 'Microsoft 365 Defender';
         $review.Subcategory = 'Email and collaboration';
         $review.Title = 'Ensure Safe Attachments policy is enabled';
         $review.Data = $policies;
         $review.Review = $reviewFlag;
 
         # Print result.
         $review.PrintResult();
                
         # Return object.
         return $review;
    }
}