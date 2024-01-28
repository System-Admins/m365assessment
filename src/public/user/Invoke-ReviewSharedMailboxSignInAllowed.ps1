function Invoke-ReviewSharedMailboxSignInAllowed
{
    <#
    .SYNOPSIS
        Get shared mailboxes and check if sign-in is allowed.
    .DESCRIPTION
        Goes through all shared mailboxes and checks if login is allowed.
    .EXAMPLE
        Invoke-ReviewSharedMailboxSignInAllowed;
    #>
    [CmdletBinding()]
    Param
    (
    )
    BEGIN
    {
        # Object array to store shared mailbox review.
        $reviewSharedMailbox = New-Object System.Collections.ArrayList;
        
        # Get all shared mailboxes.
        $sharedMailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox -ResultSize Unlimited;

        # Properties to get.
        $property = @(
            'Id',
            'UserPrincipalName',
            'GivenName',
            'Surname',
            'DisplayName',
            'SignInActivity',
            'CreatedDateTime',
            'AccountEnabled',
            'OnPremisesSyncEnabled'
        );

        # Get all users.
        $users = Get-MgUser -All -Property $property;
    }
    PROCESS
    {
        # Foreach shared mailbox.
        foreach ($sharedMailbox in $sharedMailboxes)
        {
            # Foreach user.
            foreach ($user in $users)
            {
                # Boolean for cloud only.
                [bool]$cloudOnly = $false;
                
                # If the user principal name do not match the shared mailbox.
                if ($user.UserPrincipalName -ne $sharedMailbox.UserPrincipalName)
                {
                    # Continue to next user.
                    continue;
                }

                # If the user is disabled.
                if ($false -eq $user.AccountEnabled)
                {
                    # Continue to next user.
                    continue;
                }

                # Based on the on-premises sync enabled property.
                switch ($user.OnPremisesSyncEnabled)
                {
                    # If the user is cloud only.
                    $false
                    {
                        $cloudOnly = $true;
                    }
                    # If the user is synced from on-premises.
                    $true
                    {
                        $cloudOnly = $false;
                    }
                    # If the user is cloud only.
                    $null
                    {
                        $cloudOnly = $true;
                    }
                }

                # Add to object array.
                $reviewSharedMailbox += [PSCustomObject]@{
                    Id                 = $user.Id;
                    UserPrincipalName  = $user.UserPrincipalName;
                    GivenName          = $user.GivenName;
                    Surname            = $user.Surname;
                    DisplayName        = $user.DisplayName;
                    CreatedDateTime    = $user.CreatedDateTime;
                    LastSignIn         = $user.SignInActivity.LastSignInDateTime;
                    AccountEnabled     = $user.AccountEnabled;
                    PrimarySmtpAddress = $sharedMailbox.PrimarySmtpAddress;
                    CloudOnly          = $cloudOnly;
                };
            }
        }
    }
    END
    {
        # If there are shared mailboxes to review.
        if ($reviewSharedMailbox.Count -gt 0)
        {
            # Write to log.
            Write-Log  -Category "User" -Message ('There are {0} shared mailboxes where sign-in is allowed' -f $reviewSharedMailbox.Count) -Debug;

            # Return shared mailboxes to review.
            return $reviewSharedMailbox;
        }
    }
}