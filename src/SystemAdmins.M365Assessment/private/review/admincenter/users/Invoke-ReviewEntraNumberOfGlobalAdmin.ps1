function Invoke-ReviewEntraNumberOfGlobalAdmin
{
    <#
    .SYNOPSIS
        If there is between two and four global admins are designated in Entra ID.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewEntraNumberOfGlobalAdmin;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # Get all users with admin roles.
        $usersWithAdminRole = Get-EntraIdUserAdminRole;

        # Global admin threshold.
        $minimumThreshold = 2;
        $maximumThreshold = 4;

        # Object array for global administrators.
        $globalAdmins = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach user with admin role.
        foreach ($userWithAdminRole in $usersWithAdminRole)
        {
            # If user is global admin.
            if ($userWithAdminRole.RoleDisplayName -eq 'Global Administrator')
            {
                # Write to log.
                Write-CustomLog -Category 'Entra' -Subcategory 'User' -Message ("User '{0}' have the role '{1}'" -f $userWithAdminRole.UserPrincipalName, $userWithAdminRole.RoleDisplayName) -Level Verbose;

                # Add to object array.
                $null = $globalAdmins.Add($userWithAdminRole);
            }
        }

        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'User' -Message ('Found {0} with the role Global Administrator' -f $globalAdmins.Count) -Level Verbose;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($globalAdmins.Count -lt $minimumThreshold -or $globalAdmins.Count -gt $maximumThreshold)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'd106f228-2f57-4009-a4c1-8d309a97c4f3';
        $review.Category = 'Microsoft 365 Admin Center';
        $review.Subcategory = 'Users';
        $review.Title = 'Ensure that between two and four global admins are designated';
        $review.Data = $globalAdmins;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}