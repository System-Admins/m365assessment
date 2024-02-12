function Invoke-ReviewExoMailForwardRules
{
    <#
    .SYNOPSIS
        Check mailforwarding rules in mailboxes.
    .DESCRIPTION
        Return object if any rules is found.
    .EXAMPLE
        Invoke-ReviewExoMailForwardRules;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
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
            # Get all inbox rules.
            $inboxRules = Get-InboxRule -Mailbox $mailbox.Identity -ErrorAction SilentlyContinue;

            # Foreach inbox rule.
            foreach ($inboxRule in $inboxRules)
            {
                # If mail forwarding is enabled.
                if ($inboxRule.ForwardTo -ne $null -or
                    $inboxRule.RedirectTo -ne $null -or
                    $inboxRule.ForwardAsAttachmentTo -ne $null)
                {
                    # Return object.
                    $mailboxesWithForwardRule += [PSCustomObject]@{
                        Id = $mailbox.Id;
                        PrimarySmtpAddress = $mailbox.PrimarySmtpAddress;
                        Alias = $mailbox.Alias;
                        RuleId = $inboxRule.Id;
                        RuleName = $inboxRule.Name;
                        RuleEnabled = $inboxRule.Enabled;
                        ForwardTo = $inboxRule.ForwardTo;
                        RedirectTo = $inboxRule.RedirectTo;
                        ForwardAsAttachmentTo = $inboxRule.ForwardAsAttachmentTo;
                    } | Out-Null;
                }
            }
        }
    }
    END
    {
        # If there is any mailboxes with mail forwarding rules.
        if ($mailboxesWithForwardRule.Count -gt 0)
        {
            # Return object.
            return $mailboxesWithForwardRule;
        }
    } 
}