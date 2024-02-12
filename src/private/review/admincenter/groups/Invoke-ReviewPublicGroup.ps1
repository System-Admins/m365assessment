function Invoke-ReviewPublicGroup
{
    <#
    .SYNOPSIS
        Get all Microsoft 365 groups with public visibility.
    .DESCRIPTION
        Get all Microsoft 365 groups with public visibility and return object array.
    .EXAMPLE
        Invoke-ReviewPublicGroup;
    #>

    [cmdletbinding()]
    param
    (
    )
    BEGIN
    {
        # Object array to store groups with public visibility.
        $publicVisibilityGroups = New-Object System.Collections.ArrayList;

        # Get all groups.
        $groups = Get-MgGroup -All;
    }
    PROCESS
    {
        # Foreach group.
        foreach ($group in $groups)
        {
            # If group visibility is not public.
            if ($group.Visibility -ne 'Public')
            {
                # Continue to next group.
                continue;
            }

            # Add group to public visibility groups.
            $publicVisibilityGroups += [PSCustomObject]@{
                Id              = $group.Id;
                DisplayName     = $group.DisplayName;
                Visibility      = $group.Visibility;
                SecurityEnabled = $group.SecurityEnabled;
                Mail            = $group.Mail;
                CreatedDateTime = $group.CreatedDateTime;
            };
        }
    }
    END
    {
        # Return groups with public visibility.
        return $publicVisibilityGroups;
    }
}