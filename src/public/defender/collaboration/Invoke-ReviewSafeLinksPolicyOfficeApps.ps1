function Invoke-ReviewSafeLinksPolicyOfficeApps
{
    <#
    .SYNOPSIS
        Review that Safe Links for Office Applications is enabled.
    .DESCRIPTION
        Check if Safe Links policies is cofigured correctly for Office applications.
    .EXAMPLE
        Invoke-ReviewSafeLinksPolicyOfficeApps;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Defender' -Message 'Getting SafeLinks policies' -Level debug;

        # Get all SafeLinks policies.
        $safeLinksPolicies = Get-SafeLinksPolicy;

        # Object array to store policies.
        $policies = @();
    }
    PROCESS
    {
        # Foreach SafeLink policy.
        foreach ($safeLinksPolicy in $safeLinksPolicies)
        {
            # Boolean to check if the policy configured correctly.
            $configuredCorrect = $true;

            # If the SafeLinks is disabled for email.
            if ($safeLinksPolicy.EnableSafeLinksForEmail -eq $false)
            {   
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If the SafeLinks is disabled for Teams.
            if ($safeLinksPolicy.EnableSafeLinksForTeams -eq $false)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If the SafeLinks is disabled for Office.
            if ($safeLinksPolicy.EnableSafeLinksForOffice -eq $false)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If track click is disabled.
            if ($safeLinksPolicy.TrackClicks -eq $false)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If allow click through is enabled.
            if ($safeLinksPolicy.AllowClickThrough -eq $true)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If scan urls is disabled.
            if ($safeLinksPolicy.ScanUrls -eq $false)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If enable for internal senders is disabled.
            if ($safeLinksPolicy.EnableForInternalSenders -eq $false)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If deliver message after scan is disabled.
            if ($safeLinksPolicy.DeliverMessageAfterScan -eq $false)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If disable url rewrite is enabled.
            if ($safeLinksPolicy.DisableUrlRewrite -eq $true)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If the policy is configured correctly.
            if ($configuredCorrect -eq $true)
            {
                # Write to log.
                Write-Log -Category 'Defender' -Message "SafeLinks policy '{0}' is configured correct" -Level debug;
            }
            # Else the policy is not configured correctly.
            else
            {
                # Write to log.
                Write-Log -Category 'Defender' -Message "SafeLinks policy '{0}' is not configured correct" -Level debug;
            }

            # Add to object array.
            $policies += [pscustomobject]@{
                Guid                     = $safeLinksPolicy.Guid;
                Id                       = $safeLinksPolicy.Id;
                Name                     = $safeLinksPolicy.Name;
                ConfiguredCorrect        = $configuredCorrect;
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
        # Return the object array.
        return $policies;
    }
}
