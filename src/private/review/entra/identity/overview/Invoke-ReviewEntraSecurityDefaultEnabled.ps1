function Invoke-ReviewEntraSecurityDefaultEnabled
{
    <#
    .SYNOPSIS
        Get if security defaults are enabled.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Identity.SignIns
    .EXAMPLE
        Invoke-ReviewEntraSecurityDefaultEnabled;
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
        Write-Log -Category 'Entra' -Subcategory 'Identity' -Message ("Getting security defaults") -Level Debug;

        # Get security defaults.
        $securityDefaults = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy;

        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Identity' -Message ("Security defaults is set to '{0}'" -f $securityDefaults.IsEnabled) -Level Debug;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($true -eq $securityDefaults.IsEnabled)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                               
        # Create new review object to return.
        [Review]$review = [Review]::new();
                       
        # Add to object.
        $review.Id = '48d970b5-a31b-41e9-9d66-eb8e02e0546d';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity';
        $review.Title = 'Ensure Security Defaults is disabled on Azure Active Directory';
        $review.Data = $securityDefaults.IsEnabled;
        $review.Review = $reviewFlag;
        
        # Print result.
        $review.PrintResult();
                       
        # Return object.
        return $review;
    }
}