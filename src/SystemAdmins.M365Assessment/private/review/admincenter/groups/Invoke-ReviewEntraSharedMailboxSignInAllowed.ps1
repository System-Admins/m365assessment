function Invoke-ReviewEntraSharedMailboxSignInAllowed
{
    <#
    .SYNOPSIS
        Get shared mailboxes and check if sign-in is allowed.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
        - Microsoft.Graph.Users
    .EXAMPLE
        Invoke-ReviewEntraSharedMailboxSignInAllowed;
    #>
    [cmdletbinding()]
    param
    (
    )
    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name;

        # Object array to store shared mailbox review.
        $reviewSharedMailbox = New-Object System.Collections.ArrayList;

        # Write to log.
        Write-CustomLog -Category 'Exchange Online' -Subcategory 'Mailbox' -Message 'Getting shared mailboxes' -Level Verbose;

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
        Write-CustomLog -Category 'Entra' -Subcategory 'User' -Message 'Getting all users' -Level Verbose;

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
                Write-CustomLog -Category 'Exchange Online' -Subcategory 'Mailbox' -Message ("Shared mailbox '{0}' is allowed to login" -f $sharedMailbox.PrimarySmtpAddress) -Level Verbose;

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

        # Write to log.
        Write-CustomLog -Category 'Exchange Online' -Subcategory 'Mailbox' -Message ('There are {0} shared mailboxes where sign-in is allowed' -f $reviewSharedMailbox.Count) -Level Verbose;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If there is any accounts.
        if ($reviewSharedMailbox.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'dc6727fe-333d-46ad-9ad6-f9b0ae23d03b';
        $review.Category = 'Microsoft 365 Admin Center';
        $review.Subcategory = 'Teams and groups';
        $review.Title = 'Ensure sign-in to shared mailboxes is blocked';
        $review.Data = $reviewSharedMailbox | Select-Object -First 20;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}