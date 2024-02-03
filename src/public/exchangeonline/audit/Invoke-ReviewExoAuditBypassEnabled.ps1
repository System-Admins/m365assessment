function Invoke-ReviewExoMailboxAuditBypassDisabled
{
    <#
    .SYNOPSIS
        Check if 'AuditBypassEnabled' is not enabled on mailboxes.
    .DESCRIPTION
        Return list of users with mailbox audit bypass enabled.
    .EXAMPLE
        Invoke-ReviewExoMailboxAuditBypassDisabled;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get all mailboxes.
        $mailboxes = Get-MailboxAuditBypassAssociation -ResultSize unlimited -WarningAction SilentlyContinue;

        # Object array with mailboxes where auditing bypass is enabled.
        $mailboxesAuditBypassEnabled = @();
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
    }
    END
    {
        # Return list.
        return $mailboxesAuditBypassEnabled;
    }
}