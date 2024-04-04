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
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Identity' -Message ("Getting security defaults") -Level Verbose;

        # Get security defaults.
        $securityDefaults = Get-MgPolicyIdentitySecurityDefaultEnforcementPolicy;

        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Identity' -Message ("Security defaults is set to '{0}'" -f $securityDefaults.IsEnabled) -Level Verbose;
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
        $review.Id = 'bf8c7733-8ec0-4c86-9c4e-28bf4812a57a';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity';
        $review.Title = 'Ensure Security Defaults is disabled on Azure Active Directory';
        $review.Data = [PSCustomObject]@{
            Enabled = $securityDefaults.IsEnabled;
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        #Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}