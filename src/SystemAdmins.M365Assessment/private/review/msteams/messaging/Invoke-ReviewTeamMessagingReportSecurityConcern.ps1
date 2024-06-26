function Invoke-ReviewTeamMessagingReportSecurityConcern
{
    <#
    .SYNOPSIS
        Review if users can report security concerns in Teams.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - MicrosoftTeams
    .EXAMPLE
        Invoke-ReviewTeamMessagingReportSecurityConcern;
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
        Write-CustomLog -Category 'Microsoft Teams' -Subcategory 'Messaging' -Message ('Getting meeting policies') -Level Verbose;

        # Get messaging policy.
        $messagingPolicy = Get-CsTeamsMessagingPolicy -Identity Global;

        # Write to log.
        Write-CustomLog -Category 'Microsoft Teams' -Subcategory 'Messaging' -Message ('Getting report submission policies') -Level Verbose;

        # Get report submission policy.
        $reportSubmissionPolicy = Get-ReportSubmissionPolicy;

        # Valid flag.
        [bool]$valid = $true;
    }
    PROCESS
    {
        # If users are not allowed to report security concerns.
        if ($messagingPolicy.AllowSecurityEndUserReporting -eq $false)
        {
            # Set valid flag.
            $valid = $false;
        }

        # If submission settings are not configured correctly.
        if ($reportSubmissionPolicy.ReportJunkToCustomizedAddress -ne $true -and
            $reportSubmissionPolicy.ReportNotJunkToCustomizedAddress -ne $true -and
            $reportSubmissionPolicy.ReportPhishToCustomizedAddress -ne $true -and
            $reportSubmissionPolicy.ReportJunkAddresses.Count -eq 0 -and
            $reportSubmissionPolicy.ReportNotJunkAddresses.Count -eq 0 -and
            $reportSubmissionPolicy.ReportPhishAddresses.Count -eq 0 -and
            $reportSubmissionPolicy.ReportChatMessageEnabled -ne $false -and
            $reportSubmissionPolicy.ReportChatMessageToCustomizedAddressEnabled -ne $true)
        {
            # Set valid flag.
            $valid = $false;

            # Write to log.
            Write-CustomLog -Category 'Microsoft Teams' -Subcategory 'Messaging' -Message ('Report submission settings are not configured correctly') -Level Verbose;
        }

        # Create object.
        $settings = [PSCustomObject]@{
            Valid                                       = $valid;
            AllowSecurityEndUserReporting               = $messagingPolicy.AllowSecurityEndUserReporting;
            ReportJunkToCustomizedAddress               = $reportSubmissionPolicy.ReportJunkToCustomizedAddress;
            ReportNotJunkToCustomizedAddress            = $reportSubmissionPolicy.ReportNotJunkToCustomizedAddress;
            ReportPhishToCustomizedAddress              = $reportSubmissionPolicy.ReportPhishToCustomizedAddress;
            ReportJunkAddresses                         = $reportSubmissionPolicy.ReportJunkAddresses;
            ReportNotJunkAddresses                      = $reportSubmissionPolicy.ReportNotJunkAddresses;
            ReportPhishAddresses                        = $reportSubmissionPolicy.ReportPhishAddresses;
            ReportChatMessageEnabled                    = $reportSubmissionPolicy.ReportChatMessageEnabled;
            ReportChatMessageToCustomizedAddressEnabled = $reportSubmissionPolicy.ReportChatMessageToCustomizedAddressEnabled;
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
        $review.Id = '3a107b4e-9bef-4480-b5c0-4aedd7a4a0bc';
        $review.Category = 'Microsoft Teams Admin Center';
        $review.Subcategory = 'Messaging';
        $review.Title = 'Ensure users can report security concerns in Teams';
        $review.Data = $settings;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}