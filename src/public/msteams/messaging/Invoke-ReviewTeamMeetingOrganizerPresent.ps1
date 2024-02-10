function Invoke-ReviewTeamMessagingReportSecurityConcerns
{
    <#
    .SYNOPSIS
        Review if users can report security concerns in Teams.
    .DESCRIPTION
        Return object with a valid flag if configured correct, the object also contains current settings.
    .EXAMPLE
        Invoke-ReviewTeamMessagingReportSecurityConcerns;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get messaging policy.
        $messagingPolicy = Get-CsTeamsMessagingPolicy -Identity Global;

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
        # Return object.
        return $settings;
    }
} 