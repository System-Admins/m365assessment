function Invoke-ReviewEntraUsersAllowedToCreateTenant
{
    <#
    .SYNOPSIS
        If users are allowed to create tenants in Entra ID.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Identity.SignIns
    .EXAMPLE
        Invoke-ReviewEntraUsersAllowedToCreateTenant;
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
        Write-CustomLog -Category 'Entra' -Subcategory 'Identity' -Message ('Getting if users can create tenants') -Level Verbose;

        # Get auth policy.
        $authorizationPolicy = Get-MgPolicyAuthorizationPolicy;

        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Identity' -Message ("Users can create tenants is set to '{0}'" -f $authorizationPolicy.DefaultUserRolePermissions.AllowedToCreateTenants) -Level Verbose;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($true -eq $authorizationPolicy.DefaultUserRolePermissions.AllowedToCreateTenants)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'bf785c94-b3b4-4b1b-bf90-55031fdba42c';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity';
        $review.Title = "Ensure 'Restrict non-admin users from creating tenants' is set to 'Yes'";
        $review.Data = [PSCustomObject]@{
            AllowedToCreateTenants = $authorizationPolicy.DefaultUserRolePermissions.AllowedToCreateTenants;
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}