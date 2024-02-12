function Invoke-ReviewExoMailboxAuditEnabled
{
    <#
    .SYNOPSIS
        Check mailbox auditing for users is enabled.
    .DESCRIPTION
        Return list of users with mailbox auditing disabled.
    .EXAMPLE
        Invoke-ReviewExoMailboxAuditEnabled;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
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
    }
    END
    {
        # Return list.
        return $mailboxesAuditDisabled;
    }
}