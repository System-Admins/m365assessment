function Invoke-ReviewTeamApprovedCloudStorage
{
    <#
    .SYNOPSIS
        Review external file sharing in Teams is enabled for only approved cloud storage services.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - MicrosoftTeams
    .EXAMPLE
        Invoke-ReviewTeamApprovedCloudStorage;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Microsoft Teams' -Subcategory 'Teams' -Message ('Getting client configuration') -Level Debug;

        # Get Teams client configuration.
        $teamsClientConfig = Get-CsTeamsClientConfiguration;

        # Bool external cloud providers valid setting.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # Check if any of the approved cloud storage services are enabled.
        if ($teamsClientConfig.AllowDropbox -eq $false -and
            $teamsClientConfig.AllowBox -eq $false -and
            $teamsClientConfig.AllowGoogleDrive -eq $false -and
            $teamsClientConfig.AllowShareFile -eq $false -and
            $teamsClientConfig.AllowEgnyte -eq $false)
        {
            # Set bool to false.
            $valid = $true;
        }

        # Get list of approved cloud storage services.
        $authorizedCloudProviders = [PSCustomObject]@{
            Dropbox     = $teamsClientConfig.AllowDropbox;
            Box         = $teamsClientConfig.AllowBox;
            GoogleDrive = $teamsClientConfig.AllowGoogleDrive;
            ShareFile   = $teamsClientConfig.AllowShareFile;
            Egnyte      = $teamsClientConfig.AllowEgnyte;
        };
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
        $review.Id = '36016fe3-30fe-4070-a446-441ae23cfe95';
        $review.Category = 'Microsoft Teams Admin Center';
        $review.Subcategory = 'Teams';
        $review.Title = 'Ensure external file sharing in Teams is enabled for only approved cloud storage services';
        $review.Data = $authorizedCloudProviders;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}