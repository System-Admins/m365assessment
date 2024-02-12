function Invoke-ReviewTeamMeetingChatAnonymousUsers
{
    <#
    .SYNOPSIS
        Review if meeting chat does not allow anonymous users.
    .DESCRIPTION
        Return object with a valid flag if configured correct, the object also contains current setting.
    .EXAMPLE
        Invoke-ReviewTeamMeetingChatAnonymousUsers;
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
        # If anonymous users can't start a meeting.
        if ($meetingPolicy.MeetingChatEnabledType -eq 'EnabledExceptAnonymous')
        {
            # Set valid flag.
            $valid = $true;
        }
    }
    END
    {
        # Return object.
        return [PSCustomObject]@{
            Valid = $valid;
            MeetingChatEnabledType = $meetingPolicy.MeetingChatEnabledType;
        }
    } 
}