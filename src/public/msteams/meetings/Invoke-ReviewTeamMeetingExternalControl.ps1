function Invoke-ReviewTeamMeetingExternalControl
{
    <#
    .SYNOPSIS
        Review if external participants can't give or request control.
    .DESCRIPTION
        Return true if configured correct, otherwise return false.
    .EXAMPLE
        Invoke-ReviewTeamMeetingExternalControl;
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
        # If external participants can't give or request control.
        if ($meetingPolicy.AllowExternalParticipantGiveRequestControl -eq $false)
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