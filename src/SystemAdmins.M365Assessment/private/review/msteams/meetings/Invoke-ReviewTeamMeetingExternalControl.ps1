function Invoke-ReviewTeamMeetingExternalControl
{
    <#
    .SYNOPSIS
        Review if external participants can't give or request control.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - MicrosoftTeams
    .EXAMPLE
        Invoke-ReviewTeamMeetingExternalControl;
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
        # If external participants can't give or request control.
        if ($meetingPolicy.AllowExternalParticipantGiveRequestControl -eq $false)
        {
            # Set valid flag.
            $valid = $true;
        }

        # Write to log.
        Write-CustomLog -Category 'Microsoft Teams' -Subcategory 'Meetings' -Message ("External participants give or request control is set to '{0}'" -f $meetingPolicy.AllowExternalParticipantGiveRequestControl) -Level Verbose;
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
        $review.Id = '89773e80-9004-4d41-bf8b-80d4dcbb141b';
        $review.Category = 'Microsoft Teams Admin Center';
        $review.Subcategory = 'Meetings';
        $review.Title = "Ensure external participants can't give or request control";
        $review.Data = $meetingPolicy | Select-Object -Property AllowExternalParticipantGiveRequestControl;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        #Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}