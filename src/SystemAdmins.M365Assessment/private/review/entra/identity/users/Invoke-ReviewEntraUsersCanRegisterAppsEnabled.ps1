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

    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Identity' -Message ('Getting if users can register apps') -Level Debug;

        # Get auth policy.
        $authorizationPolicy = Get-MgPolicyAuthorizationPolicy;

        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Identity' -Message ("Register apps per user is set to '{0}'" -f $authorizationPolicy.DefaultUserRolePermissions.AllowedToCreateApps) -Level Debug;
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

        # Return object.
        return $review;
    }
}