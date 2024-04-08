function Invoke-ReviewDefenderSafeLinksPolicyOfficeApp
{
    <#
    .SYNOPSIS
        Review that Safe Links for Office Applications is enabled.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewDefenderSafeLinksPolicyOfficeApp;
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
        Write-CustomLog -Category 'Microsoft Defender' -Subcategory 'Policy' -Message 'Getting SafeLinks policies' -Level Verbose;

        # Get all SafeLinks policies.
        $safeLinksPolicies = Get-SafeLinksPolicy;

        # Object array to store policies.
        $policies = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach SafeLink policy.
        foreach ($safeLinksPolicy in $safeLinksPolicies)
        {
            # Boolean to check if the policy configured correctly.
            $valid = $true;

            # If the SafeLinks is disabled for email.
            if ($safeLinksPolicy.EnableSafeLinksForEmail -eq $false)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If the SafeLinks is disabled for Teams.
            if ($safeLinksPolicy.EnableSafeLinksForTeams -eq $false)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If the SafeLinks is disabled for Office.
            if ($safeLinksPolicy.EnableSafeLinksForOffice -eq $false)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If track click is disabled.
            if ($safeLinksPolicy.TrackClicks -eq $false)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If allow click through is enabled.
            if ($safeLinksPolicy.AllowClickThrough -eq $true)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If scan urls is disabled.
            if ($safeLinksPolicy.ScanUrls -eq $false)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If enable for internal senders is disabled.
            if ($safeLinksPolicy.EnableForInternalSenders -eq $false)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If deliver message after scan is disabled.
            if ($safeLinksPolicy.DeliverMessageAfterScan -eq $false)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If disable url rewrite is enabled.
            if ($safeLinksPolicy.DisableUrlRewrite -eq $true)
            {
                # Set the boolean to false.
                $valid = $false;
            }

            # If the policy is configured correctly.
            if ($valid -eq $true)
            {
                # Write to log.
                Write-CustomLog -Category 'Microsoft Defender' -Subcategory 'Policy' -Message "SafeLinks policy '{0}' is configured correct" -Level Verbose;
            }
            # Else the policy is not configured correctly.
            else
            {
                # Write to log.
                Write-CustomLog -Category 'Microsoft Defender' -Subcategory 'Policy' -Message "SafeLinks policy '{0}' is not configured correct" -Level Verbose;
            }

            # Add to object array.
            $policies += [PSCustomObject]@{
                Guid                     = $safeLinksPolicy.Guid;
                Id                       = $safeLinksPolicy.Id;
                Name                     = $safeLinksPolicy.Name;
                Valid                    = $valid;
                EnableSafeLinksForEmail  = $safeLinksPolicy.EnableSafeLinksForEmail;
                EnableSafeLinksForTeams  = $safeLinksPolicy.EnableSafeLinksForTeams;
                EnableSafeLinksForOffice = $safeLinksPolicy.EnableSafeLinksForOffice;
                TrackClicks              = $safeLinksPolicy.TrackClicks;
                AllowClickThrough        = $safeLinksPolicy.AllowClickThrough;
                ScanUrls                 = $safeLinksPolicy.ScanUrls;
                EnableForInternalSenders = $safeLinksPolicy.EnableForInternalSenders;
                DeliverMessageAfterScan  = $safeLinksPolicy.DeliverMessageAfterScan;
                DisableUrlRewrite        = $safeLinksPolicy.DisableUrlRewrite;
            }
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($policies | Where-Object {
                ($_.Valid -eq $false -and $_.Name -ne 'Built-In Protection Policy') -or `
                $policies.Count -eq 0
            })
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'b29a3b32-4042-4ce6-86f6-eb85b183b4b5';
        $review.Category = 'Microsoft 365 Defender';
        $review.Subcategory = 'Email and collaboration';
        $review.Title = 'Ensure Safe Links for Office Applications is Enabled';
        $review.Data = $policies;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}
