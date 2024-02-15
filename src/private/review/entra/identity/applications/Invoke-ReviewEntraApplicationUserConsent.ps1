function Invoke-ReviewEntraApplicationUserConsent
{
    <#
    .SYNOPSIS
        If user consent to apps accessing company data on their behalf is not allowed in Entra ID.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Beta.Reports
    .EXAMPLE
        Invoke-ReviewEntraApplicationUserConsent;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get user consent setting.
        $userConsentSetting = Get-EntraIdApplicationUserConsentSettings; 

        # Boolean if valid. 
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If don't allow user consent.
        if ($userConsentSetting -eq 'DoNotAllowUserConsent')
        {
            # Set valid.
            $valid = $true;
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($false -eq $valid)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                     
        # Create new review object to return.
        [Review]$review = [Review]::new();
                             
        # Add to object.
        $review.Id = 'db353f34-1ee7-4e15-b6a5-d9f9a15e00c8';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity';
        $review.Title = 'Ensure user consent to apps accessing company data on their behalf is not allowed';
        $review.Data = $userConsentSetting;
        $review.Review = $reviewFlag;
              
        # Print result.
        $review.PrintResult();
                             
        # Return object.
        return $review;
    }
}