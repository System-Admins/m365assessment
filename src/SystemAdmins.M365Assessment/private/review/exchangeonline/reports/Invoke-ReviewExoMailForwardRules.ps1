function Invoke-ReviewExoMailForwardRules
{
    <#
    .SYNOPSIS
        Check mail forwarding rules in mailboxes.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewExoMailForwardRules;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Exchange Online' -Subcategory 'Reports' -Message 'Getting all mailboxes' -Level Debug;
        
        # Get all mailboxes.
        $mailboxes = Get-Mailbox -ResultSize Unlimited;

        # List of mailboxes with mail forwarding rules.
        $mailboxesWithForwardRule = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach mailbox.
        foreach ($mailbox in $mailboxes)
        {
            # Write to log.
            Write-Log -Category 'Exchange Online' -Subcategory 'Reports' -Message ("Getting inbox rules for '{0}'" -f $mailbox.PrimarySmtpAddress) -Level Debug;

            # Get all inbox rules.
            $inboxRules = Get-InboxRule -Mailbox $mailbox.Identity -ErrorAction SilentlyContinue;

            # Foreach inbox rule.
            foreach ($inboxRule in $inboxRules)
            {
                # If mail forwarding is enabled.
                if ($null -ne $inboxRule.ForwardTo -or
                    $null -ne $inboxRule.RedirectTo -or
                    $null -ne $inboxRule.ForwardAsAttachmentTo)
                {
                    # Write to log.
                    Write-Log -Category 'Exchange Online' -Subcategory 'Reports' -Message ("Mail forward is enabled for mailbox '{0}' in inbox rule '{1}'" -f $mailbox.PrimarySmtpAddress, $inboxRule.Name) -Level Debug;
        
                    # Return object.
                    $mailboxesWithForwardRule += [PSCustomObject]@{
                        Id                    = $mailbox.Id;
                        PrimarySmtpAddress    = $mailbox.PrimarySmtpAddress;
                        Alias                 = $mailbox.Alias;
                        RuleId                = $inboxRule.Id;
                        RuleName              = $inboxRule.Name;
                        RuleEnabled           = $inboxRule.Enabled;
                        ForwardTo             = $inboxRule.ForwardTo;
                        RedirectTo            = $inboxRule.RedirectTo;
                        ForwardAsAttachmentTo = $inboxRule.ForwardAsAttachmentTo;
                    };
                }
            }
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($mailboxesWithForwardRule.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                                     
        # Create new review object to return.
        [Review]$review = [Review]::new();
                                             
        # Add to object.
        $review.Id = 'b2798cfb-c5cc-41d4-9309-d1bd932a4a91';
        $review.Category = 'Microsoft Exchange Admin Center';
        $review.Subcategory = 'Reports';
        $review.Title = 'Ensure mail forwarding rules are reviewed at least weekly';
        $review.Data = $mailboxesWithForwardRule;
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    } 
}