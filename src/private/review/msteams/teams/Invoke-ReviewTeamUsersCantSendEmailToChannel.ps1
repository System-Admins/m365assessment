function Invoke-ReviewTeamUsersCantSendEmailToChannel
{
    <#
    .SYNOPSIS
        Review users can't send emails to a channel email address.
    .DESCRIPTION
        Return true if valid, otherwise false (allowed).
    .EXAMPLE
        Invoke-ReviewTeamUsersCantSendEmailToChannel;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get Teams client configuration.
        $teamsClientConfig = Get-CsTeamsClientConfiguration -Identity Global;

        # Valid flag.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If users are allowed to send emails to a channel.
        if ($teamsClientConfig.AllowEmailIntoChannel -eq $false)
        {
            # Set valid flag to true.
            $valid = $true;
        }
    }
    END
    {
        # Return bool.
        return $valid;
    } 
}