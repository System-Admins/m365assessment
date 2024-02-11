function Invoke-ReviewCalendarExternalSharing
{
    <#
    .SYNOPSIS
        Review if external calendar sharing policy is enabled.
    .DESCRIPTION
        Return all sharing policies that is sharing externally.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewCalendarExternalSharing;
    #>
    [CmdletBinding()]
    Param
    (
    )
    BEGIN
    {
        # Write to log.
        Write-Log -Category 'ExchangeOnline' -Message 'Getting all sharing policies' -Level Debug;
        
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
                Write-Log -Category 'ExchangeOnline' -Message ("Sharing policy '{0}' is disabled" -f $sharingPolicy.Name) -Level Debug;

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
            Write-Log -Category 'ExchangeOnline' -Message ("External calendar sharing is enabled in the sharing policy '{0}'" -f $sharingPolicy.Name) -Level Debug;

            # Add to array.
            $calendarSharingPolicies += $sharingPolicy
        }
    }
    END
    {
        # Return policies.
        return $calendarSharingPolicies;
    }
}