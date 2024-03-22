function Invoke-ReviewExoCalendarExternalSharing
{
    <#
    .SYNOPSIS
        Review if external calendar sharing policy is enabled.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewExoCalendarExternalSharing;
    #>
    [cmdletbinding()]
    param
    (
    )
    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Exchange Online' -Subcategory 'Policy' -Message 'Getting all sharing policies' -Level Debug;

        # Get all sharing policies.
        $sharingPolicies = Get-SharingPolicy;

        # Object array to store calendar sharing policies.
        $calendarSharingPolicies = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach sharing policy.
        foreach ($sharingPolicy in $sharingPolicies)
        {
            # If policy is disabled.
            if ($false -eq $sharingPolicy.Enabled)
            {
                # Write to log.
                Write-Log -Category 'Exchange Online' -Subcategory 'Policy' -Message ("Sharing policy '{0}' is disabled" -f $sharingPolicy.Name) -Level Debug;

                # Continue to next policy.
                continue;
            }

            # If calendar sharing is disabled.
            if ($sharingPolicy.Domains -notlike '*CalendarSharing*')
            {
                # Continue to next policy.
                continue;
            }

            # Write to log.
            Write-Log -Category 'Exchange Online' -Subcategory 'Policy' -Message ("External calendar sharing is enabled in the sharing policy '{0}'" -f $sharingPolicy.Name) -Level Debug;

            # Add to array.
            $calendarSharingPolicies += [PSCustomObject]@{
                Name = $sharingPolicy.Name;
                Domains = $sharingPolicy.Domains -join '|';
                Enabled = $sharingPolicy.Enabled;
                Default = $sharingPolicy.Default;
            };
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($calendarSharingPolicies.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '489b0b3d-cf78-46a5-8366-84908dc05d5a';
        $review.Category = 'Microsoft 365 Admin Center';
        $review.Subcategory = 'Settings';
        $review.Title = "Ensure 'External sharing' of calendars is not available";
        $review.Data = $calendarSharingPolicies;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}