function Invoke-ReviewTeamMeetingChatAnonymousUser
{
    <#
    .SYNOPSIS
        Review if meeting chat does not allow anonymous users.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - MicrosoftTeams
    .EXAMPLE
        Invoke-ReviewTeamMeetingChatAnonymousUser;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Microsoft Teams' -Subcategory 'Meetings' -Message ('Getting meeting policies') -Level Debug;

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

        # Write to log.
        Write-Log -Category 'Microsoft Teams' -Subcategory 'Meetings' -Message ("Meetings anonymous chat is set to '{0}'" -f $meetingPolicy.MeetingChatEnabledType) -Level Debug;
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
        $review.Id = '61b9c972-bb4e-4768-8db4-89a62fc09877';
        $review.Category = 'Microsoft Teams Admin Center';
        $review.Subcategory = 'Meetings';
        $review.Title = 'Ensure meeting chat does not allow anonymous users';
        $review.Data = $meetingPolicy | Select-Object -Property MeetingChatEnabledType;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}