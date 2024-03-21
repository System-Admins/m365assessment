function Invoke-ReviewEntraPublicGroup
{
    <#
    .SYNOPSIS
        Get all Microsoft 365 groups with public visibility.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Groups
    .EXAMPLE
        Invoke-ReviewEntraPublicGroup;
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

            # Write to log.
            Write-Log -Category 'Entra' -Subcategory 'Group' -Message ("Public group '{0}' have public visibility" -f $group.DisplayName) -Level Debug;

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
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($publicVisibilityGroups.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                       
        # Create new review object to return.
        [Review]$review = [Review]::new();
               
        # Add to object.
        $review.Id = '90295b64-2528-4c22-aa96-a606633bc705';
        $review.Category = 'Microsoft 365 Admin Center';
        $review.Subcategory = 'Teams and groups';
        $review.Title = 'Ensure that only organizationally managed/approved public groups exist';
        $review.Data = $publicVisibilityGroups;
        $review.Review = $reviewFlag;
        $review.Category = 'Microsoft 365 Admin Center';

        # Print result.
        $review.PrintResult();
               
        # Return object.
        return $review;
    }
}