function Invoke-ReviewTeamMeetingAnonymousJoin
{
    <#
    .SYNOPSIS
        Review anonymous users can't join a meeting.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - MicrosoftTeams
    .EXAMPLE
        Invoke-ReviewTeamMeetingAnonymousJoin;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # Write to log.
        Write-CustomLog -Category 'Microsoft Teams' -Subcategory 'Meetings' -Message ('Getting meeting policies') -Level Verbose;

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

        # Write to log.
        Write-CustomLog -Category 'Microsoft Teams' -Subcategory 'Meetings' -Message ("Anonymous users cant join a meeting is set to '{0}'" -f $meetingPolicy.AllowAnonymousUsersToJoinMeeting) -Level Verbose;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $valid)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '087cd766-1d44-444d-a572-21312ddfb804';
        $review.Category = 'Microsoft Teams Admin Center';
        $review.Subcategory = 'Meetings';
        $review.Title = "Ensure anonymous users can't join a meeting";
        $review.Data = $meetingPolicy | Select-Object -Property AllowAnonymousUsersToJoinMeeting;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}