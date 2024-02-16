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
        # Write to log.
        Write-Log -Category 'Microsoft Teams' -Subcategory 'Meetings' -Message ('Getting meeting policies') -Level Debug;

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
            # Write to log.
            Write-Log -Category 'Microsoft Teams' -Subcategory 'Meetings' -Message ("Anonymous users and dial-in callers can't start a meeting") -Level Debug;

            # Set valid flag.
            $valid = $true;
        }
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
        $review.Data = $meetingPolicy.AllowAnonymousUsersToStartMeeting;
        $review.Review = $reviewFlag;
                                      
        # Print result.
        $review.PrintResult();
                                                     
        # Return object.
        return $review; 
    } 
}