function Invoke-ReviewEntraGuestDynamicGroup
{
    <#
    .SYNOPSIS
        Review that a dynamic group for guest users is created.
    .DESCRIPTION
        Return a list of dynamic groups that contain guest users.
    .EXAMPLE
        Invoke-ReviewEntraGuestDynamicGroup;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get all dynamic groups.
        $groups = Get-MgGroup -Filter "groupTypes/any(c:c eq 'DynamicMembership')" -All;

        # Results to store groups.
        $results = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach dynamic group.
        foreach ($group in $groups)
        {
            # If group contains guest users.
            if ($group.MembershipRule -eq '(user.userType -eq "Guest")')
            {
                # Add group to results.
                $results.Add($group) | Out-Null;
            }
        }
    }
    END
    {
        # Return results.
        return $results
    }
}