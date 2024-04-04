function Invoke-ReviewExoMailboxAuditEnabled
{
    <#
    .SYNOPSIS
        Check mailbox auditing for users is enabled.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewExoMailboxAuditEnabled;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name;

        # Write to log.
        Write-CustomLog -Category 'Exchange Online' -Subcategory 'Audit' -Message 'Getting all mailboxes' -Level Verbose;

        # Get all mailboxes.
        $mailboxes = Get-Mailbox -ResultSize Unlimited;

        # Object array with mailboxes where auditing is disabled.
        $mailboxesAuditDisabled = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach mailbox.
        foreach ($mailbox in $mailboxes)
        {
            # If mailbox auditing is disabled.
            if ($mailbox.AuditEnabled -eq $false)
            {
                # Add to the list.
                $mailboxesAuditDisabled += $mailbox;
            }
        }

        # Write to log.
        Write-CustomLog -Category 'Exchange Online' -Subcategory 'Audit' -Message ("Found {0} with audit disabled" -f $mailboxesAuditDisabled.Count) -Level Verbose;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($mailboxesAuditDisabled.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '2b849f34-8991-4a13-a6f1-9f7d0ea4bcef';
        $review.Category = 'Microsoft Exchange Admin Center';
        $review.Subcategory = 'Audit';
        $review.Title = 'Ensure mailbox auditing for users is Enabled';
        $review.Data = $mailboxesAuditDisabled | Select-Object -Property Name, Alias, UserPrincipalName, PrimarySmtpAddress, AuditEnabled;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand -Completed;

        # Return object.
        return $review;
    }
}