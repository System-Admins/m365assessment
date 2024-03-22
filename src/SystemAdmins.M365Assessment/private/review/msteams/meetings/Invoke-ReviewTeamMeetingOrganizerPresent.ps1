function Invoke-ReviewTeamMeetingOrganizerPresent
{
    <#
    .SYNOPSIS
        Review if only organizers and co-organizers can present.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - MicrosoftTeams
    .EXAMPLE
        Invoke-ReviewTeamMeetingOrganizerPresent;
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
        # If only organizers and co-organizers can present.
        if ($meetingPolicy.DesignatedPresenterRoleMode -eq 'OrganizerOnlyUserOverride')
        {
            # Set valid flag.
            $valid = $true;
        }

        # Write to log.
        Write-Log -Category 'Microsoft Teams' -Subcategory 'Meetings' -Message ("Designated presenter role mode is set to '{0}'" -f $meetingPolicy.DesignatedPresenterRoleMode) -Level Debug;
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
        $review.Id = '8cd7d1c7-6491-433d-9d5b-68f1bf7bcfc3';
        $review.Category = 'Microsoft Teams Admin Center';
        $review.Subcategory = 'Meetings';
        $review.Title = "Ensure only organizers and co-organizers can present";
        $review.Data = $meetingPolicy | Select-Object -Property DesignatedPresenterRoleMode;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}