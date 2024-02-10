function Invoke-ReviewTeamMeetingAnonymousJoin
{
    <#
    .SYNOPSIS
        Review anonymous users can't join a meeting.
    .DESCRIPTION
        Return true if anonymous is NOT allowed to join a meeting, otherwise false.
    .EXAMPLE
        Invoke-ReviewTeamMeetingAnonymousJoin;
    #>

    [CmdletBinding()]
    Param
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
        # If anonymous users can't join a meeting.
        if ($meetingPolicy.AllowAnonymousUsersToJoinMeeting -eq $false)
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