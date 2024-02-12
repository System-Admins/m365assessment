function Invoke-ReviewSharedMailboxSignInAllowed
{
    <#
    .SYNOPSIS
        Get shared mailboxes and check if sign-in is allowed.
    .DESCRIPTION
        Return list of mailboxes that are allowed to sign-in.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
        - Microsoft.Graph.Users
    .EXAMPLE
        Invoke-ReviewSharedMailboxSignInAllowed;
    #>
    [cmdletbinding()]
    param
    (
    )
    BEGIN
    {
        # Object array to store shared mailbox review.
        $reviewSharedMailbox = New-Object System.Collections.ArrayList;
        
        # Write to log.
        Write-Log -Category 'Exchange Online' -Subcategory 'Mailbox' -Message 'Getting shared mailboxes' -Level Debug;

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

        # Write to log.
        Write-Log -Category 'Entra ID' -Subcategory 'User' -Message 'Getting all users' -Level Debug;

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

                # Write to log.
                Write-Log -Category 'Exchange Online' -Subcategory 'Mailbox' -Message ("Shared mailbox '{0}' is allowed to login" -f $sharedMailbox.PrimarySmtpAddress) -Level Debug;

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
            Write-Log -Category 'Exchange Online' -Subcategory 'Mailbox' -Message ('There are {0} shared mailboxes where sign-in is allowed' -f $reviewSharedMailbox.Count) -Level Debug;

            # Return shared mailboxes to review.
            return $reviewSharedMailbox;
        }
    }
}