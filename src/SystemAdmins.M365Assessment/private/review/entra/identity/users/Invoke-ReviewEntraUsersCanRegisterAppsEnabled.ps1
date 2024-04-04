function Invoke-ReviewEntraUsersCanRegisterAppsEnabled
{
    <#
    .SYNOPSIS
        If users are allowed to register apps in Entra ID.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Identity.SignIns
    .EXAMPLE
        Invoke-ReviewEntraUsersCanRegisterAppsEnabled;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Identity' -Message ('Getting if users can register apps') -Level Verbose;

        # Get auth policy.
        $authorizationPolicy = Get-MgPolicyAuthorizationPolicy;

        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Identity' -Message ("Register apps per user is set to '{0}'" -f $authorizationPolicy.DefaultUserRolePermissions.AllowedToCreateApps) -Level Verbose;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($true -eq $authorizationPolicy.DefaultUserRolePermissions.AllowedToCreateApps)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '3caa1bff-bce3-4744-8898-00b0ebc49ff7';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity';
        $review.Title = 'Ensure third-party integrated applications are not allowed';
        $review.Data = [PSCustomObject]@{
            AllowedToCreateApps = $authorizationPolicy.DefaultUserRolePermissions.AllowedToCreateApps;
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