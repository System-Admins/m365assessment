function Invoke-ReviewEntraGuestUser
{
    <#
    .SYNOPSIS
        Review guest users in Entra ID.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewEntraGuestUser;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # Object array to store guest accounts.
        $reviewAccounts = New-Object System.Collections.ArrayList;

        # Get all guest accounts.
        $guestUsers = Get-EntraIdGuest;

        # Get all users with admin roles.
        $usersWithAdminRole = Get-EntraIdUserAdminRole;
    }
    PROCESS
    {
        # Foreach guest account.
        foreach ($guestUser in $guestUsers)
        {
            # Get all roles for the guest account.
            $roles = ($usersWithAdminRole | Where-Object { $_.UserPrincipalName -eq $guestUser.UserPrincipalName }).RoleDisplayName;

            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'User' -Message ("Found guest user '{0}'" -f $guestUser.UserPrincipalName) -Level Verbose;

            # Add to object array.
            $reviewAccounts += [PSCustomObject]@{
                Id                = $guestUser.Id;
                UserPrincipalName = $guestUser.UserPrincipalName;
                GivenName         = $guestUser.GivenName;
                Surname           = $guestUser.Surname;
                DisplayName       = $guestUser.DisplayName;
                Roles             = $roles;
                CreatedDateTime   = $guestUser.CreatedDateTime;
                LastSignIn        = $guestUser.SignInActivity.LastSignInDateTime;
                AccountEnabled    = $guestUser.AccountEnabled;
            };
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($reviewAccounts.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '7fe4d30e-42bd-44d4-8066-0b732dcbda4c';
        $review.Category = 'Microsoft 365 Admin Center';
        $review.Subcategory = 'Users';
        $review.Title = 'Ensure Guest Users are reviewed';
        $review.Data = $reviewAccounts | Select-Object -First 20;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}