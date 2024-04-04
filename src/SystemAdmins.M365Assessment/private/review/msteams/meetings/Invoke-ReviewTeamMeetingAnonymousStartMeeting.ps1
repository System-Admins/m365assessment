function Invoke-ReviewTeamMeetingAnonymousStartMeeting
{
    <#
    .SYNOPSIS
        Review anonymous users and dial-in callers can't start a meeting.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - MicrosoftTeams
    .EXAMPLE
        Invoke-ReviewTeamMeetingAnonymousStartMeeting;
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
        # If anonymous users and dial-in callers can't start a meeting.
        if ($meetingPolicy.AllowAnonymousUsersToStartMeeting -eq $false)
        {
            # Set valid flag.
            $valid = $true;
        }

        # Write to log.
        Write-CustomLog -Category 'Microsoft Teams' -Subcategory 'Meetings' -Message ("Anonymous users and dial-in callers start a meeting is set to '{0}'" -f $meetingPolicy.AllowAnonymousUsersToStartMeeting) -Level Verbose;
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
        $review.Id = '963797c1-0f06-4ae9-9446-7856eef4f7d7';
        $review.Category = 'Microsoft Teams Admin Center';
        $review.Subcategory = 'Teams';
        $review.Title = "Ensure anonymous users and dial-in callers can't start a meeting";
        $review.Data = $meetingPolicy | Select-Object -Property AllowAnonymousUsersToStartMeeting;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        #Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}