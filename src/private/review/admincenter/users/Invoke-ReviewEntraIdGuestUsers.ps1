function Invoke-ReviewEntraIdGuestUsers
{
    <#
    .SYNOPSIS
        Review guest users in Entra ID.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewEntraIdGuestUsers;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
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
            Write-Log -Category 'Entra ID' -Subcategory 'User' -Message ("Found guest user '{0}'" -f $guestUser.UserPrincipalName) -Level Debug;

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
        $review = [Review]::new();
        
        # Add to object.
        $review.Id = '7fe4d30e-42bd-44d4-8066-0b732dcbda4c';
        $review.Title = 'Ensure Guest Users are reviewed';
        $review.Data = $reviewAccounts;
        $review.Review = $reviewFlag;
        
        # Return object.
        return $review;
    }
}