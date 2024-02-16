function Invoke-ReviewExoMailboxAuditBypassDisabled
{
    <#
    .SYNOPSIS
        Check if 'AuditBypassEnabled' is not enabled on mailboxes.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewExoMailboxAuditBypassDisabled;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Exchange Online' -Subcategory 'Audit' -Message 'Getting mailbox audit bypass associations' -Level Debug;

        # Get all mailboxes.
        $mailboxes = Get-MailboxAuditBypassAssociation -ResultSize Unlimited -WarningAction SilentlyContinue;

        # Object array with mailboxes where auditing bypass is enabled.
        $mailboxesAuditBypassEnabled = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach mailbox.
        foreach ($mailbox in $mailboxes)
        {
            # If mailbox auditing bypass is enabled.
            if ($mailbox.AuditBypassEnabled -eq $true)
            {
                # Add to the list.
                $mailboxesAuditBypassEnabled += $mailbox;
            }
        }

        # Write to log.
        Write-Log -Category 'Exchange Online' -Subcategory 'Audit' -Message ("Found {0} mailboxes with audit bypass enabled" -f $mailboxesAuditBypassEnabled) -Level Debug;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($mailboxesAuditBypassEnabled.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                                     
        # Create new review object to return.
        [Review]$review = [Review]::new();
                                             
        # Add to object.
        $review.Id = 'a2c3a619-df82-4e0b-ac98-47ff51ea8c2a';
        $review.Category = 'Microsoft Exchange Admin Center';
        $review.Subcategory = 'Audit';
        $review.Title = "Ensure 'AuditBypassEnabled' is not enabled on mailboxes";
        $review.Data = $mailboxesAuditBypassEnabled;
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    }
}