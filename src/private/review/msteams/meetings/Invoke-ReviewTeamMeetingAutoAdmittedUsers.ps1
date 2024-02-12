function Invoke-ReviewTeamMeetingAutoAdmittedUsers
{
    <#
    .SYNOPSIS
        Review only people in my org can bypass the lobby.
    .DESCRIPTION
        Return object with a valid flag and current setting if only people in the organization can bypass the lobby.
    .EXAMPLE
        Invoke-ReviewTeamMeetingAutoAdmittedUsers;
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
        # If only people in my org can bypass the lobby.
        if ($meetingPolicy.AutoAdmittedUsers -eq 'EveryoneInCompanyExcludingGuests')
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
            AutoAdmittedUsers = $meetingPolicy.AutoAdmittedUsers;
        };
    } 
}