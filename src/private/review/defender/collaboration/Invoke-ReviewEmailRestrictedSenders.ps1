function Invoke-ReviewEmailRestrictedSenders
{
    <#
    .SYNOPSIS
        Review the users who is restricted by sending e-mail.
    .DESCRIPTION
        Return a list of user accounts restricted from sending e-mail.
    .EXAMPLE
        Invoke-ReviewEmailRestrictedSenders;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
 
    }
    PROCESS
    {
        
        # Get restricted senders.
        $restrictedSenders = Get-BlockedSenderAddress;
    }
    END
    {
        # Return object array.
        return $restrictedSenders;
    }
}