function Invoke-ReviewTeamMeetingDialInBypassLobby
{
    <#
    .SYNOPSIS
        Review if users dialing in can't bypass the lobby.
    .DESCRIPTION
        Return true if configured correct, otherwise return false.
    .EXAMPLE
        Invoke-ReviewTeamMeetingDialInBypassLobby;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get meeting policy.
        $meetingPolicy = Get-CsTeamsMeetingPolicy -Identity Global;

        # Valid flag.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If users dialing in can't bypass the lobby.
        if ($meetingPolicy.AllowPSTNUsersToBypassLobby -eq $false)
        {
            # Set valid flag.
            $valid = $true;
        }
    }
    END
    {
        # Return bool.
        return $valid;
    } 
}