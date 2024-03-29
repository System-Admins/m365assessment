function Invoke-ReviewCalendarSharingPolicy
{
    <#
    .SYNOPSIS
        Return all policies that have calendar sharing enabled.
    .DESCRIPTION
        Return a list of policies.
    .EXAMPLE
        Invoke-ReviewCalendarSharingPolicy;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
    }
    PROCESS
    {
        # Get calendar sharing policies.
        $policies = Get-CalendarSharingPolicy;
    }
    END
    {
        # Return the policies.
        return $policies;
    }
}