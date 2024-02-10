function Invoke-ReviewTeamMeetingOrganizerPresent
{
    <#
    .SYNOPSIS
        Review if only organizers and co-organizers can present.
    .DESCRIPTION
        Return object with a valid flag if configured correct, the object also contains current setting.
    .EXAMPLE
        Invoke-ReviewTeamMeetingOrganizerPresent;
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
        # If only organizers and co-organizers can present.
        if ($meetingPolicy.DesignatedPresenterRoleMode -eq 'OrganizerOnlyUserOverride')
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
            DesignatedPresenterRoleMode = $meetingPolicy.DesignatedPresenterRoleMode;
        }
    } 
}