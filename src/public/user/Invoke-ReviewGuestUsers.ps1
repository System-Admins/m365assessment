function Invoke-ReviewGuestUsers
{
    <#
    .SYNOPSIS
        Get guests for review.
    .DESCRIPTION
        Retrieves all guest accounts for review.
    .EXAMPLE
        Invoke-ReviewGuestUsers;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Object array to store guest accounts.
        $reviewAccounts = New-Object System.Collections.ArrayList;
        
        # Get all guest accounts.
        $guestUsers = Get-GuestUsers;

        # Get all users with admin roles.
        $usersWithAdminRole = Get-UsersWithAdminRole;
    }
    PROCESS
    {
        # Foreach guest account.
        foreach ($guestUser in $guestUsers)
        {
            # Get all roles for the guest account.
            $roles = ($usersWithAdminRole | Where-Object { $_.UserPrincipalName -eq $guestUser.UserPrincipalName }).RoleDisplayName;

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
        # Return guest accounts to review.
        return $reviewAccounts;
    }
}