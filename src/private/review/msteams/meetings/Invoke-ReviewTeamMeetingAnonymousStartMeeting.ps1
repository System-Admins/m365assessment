function Invoke-ReviewTeamMeetingAnonymousStartMeeting
{
    <#
    .SYNOPSIS
        Review anonymous users and dial-in callers can't start a meeting.
    .DESCRIPTION
        Return true if anonymous or dial in users cant start meetings, otherwise false.
    .EXAMPLE
        Invoke-ReviewTeamMeetingAnonymousStartMeeting;
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
        # If anonymous users and dial-in callers can't start a meeting.
        if ($meetingPolicy.AllowAnonymousUsersToStartMeeting -eq $false)
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