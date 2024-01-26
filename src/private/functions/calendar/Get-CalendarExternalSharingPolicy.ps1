function Get-CalendarExternalSharingPolicy
{
    <#
    .SYNOPSIS
        Review if external calendar sharing policy is enabled.
    .DESCRIPTION
        Return all sharing policies that is sharing externally.
    .EXAMPLE
        Get-CalendarExternalSharingPolicy;
    #>
    [CmdletBinding()]
    Param
    (
    )
    BEGIN
    {
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
                # Continue to next policy.
                continue;
            }

            # If calendar sharing is disabled.
            if ($sharingPolicy.Domains -notlike '*CalendarSharing*')
            {
                # Continue to next policy.
                continue;
            }

            # Add to array.
            $calendarSharingPolicies += [PSCustomObject]@{
                Guid                           = $sharingPolicy.Guid;
                Id                             = $sharingPolicy.Id;
                Name                           = $sharingPolicy.Name;
                Default                        = $sharingPolicy.Default;
                Enabled                        = $sharingPolicy.Enabled;
                ExternalCalendarSharingEnabled = $true;
                Domains                        = $sharingPolicy.Domains -join '|';
            };
        }
    }
    END
    {
        # If there is sharing policies.
        if ($null -ne $calendarSharingPolicies)
        {
            # Write to log.
            Write-Log -Message 'External calendar sharing is enabled' -Level Debug;

            # Return policies.
            return $calendarSharingPolicies;
        }
    }
}