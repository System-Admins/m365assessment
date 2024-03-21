
function Get-EntraIdGuest
{
    <#
    .SYNOPSIS
        Returns all guest users.
    .DESCRIPTION
        Get all guest users and returns object array with information like last login date.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Users
    .EXAMPLE
        Get-EntraIdGuest;
    #>
    [cmdletbinding()]
    param
    ( 
    )

    BEGIN
    {
        # Properties to get.
        $property = @(
            "Id",
            "UserPrincipalName",
            "GivenName",
            "Surname",
            "DisplayName",
            "SignInActivity",
            "CreatedDateTime",
            "AccountEnabled"
        );
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'User' -Message ('Getting all guest users') -Level Debug;

        # Get all users
        $guestUsers = Get-MgUser -All -Filter { userType eq 'Guest' } -Property $property;

        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'User' -Message ('Found {0} guest users' -f $guestUsers.Count) -Level Debug;
    }
    END
    {
        # Return guest users.
        return $guestUsers;
    }
}