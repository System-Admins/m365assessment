function Invoke-ReviewEntraGuestDynamicGroup
{
    <#
    .SYNOPSIS
        Review that a dynamic group for guest users is created.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Groups
    .EXAMPLE
        Invoke-ReviewEntraGuestDynamicGroup;
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
        Write-CustomLog -Category 'Entra' -Subcategory 'Identity' -Message ("Getting all dynamic created groups") -Level Verbose;

        # Get all dynamic groups.
        $groups = Get-MgGroup -Filter "groupTypes/any(c:c eq 'DynamicMembership')" -All;

        # Results to store groups.
        $results = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Identity' -Message ("Found {0} dynamic created groups" -f $groups.Count) -Level Verbose;

        # Foreach dynamic group.
        foreach ($group in $groups)
        {
            # If group contains guest users.
            if ($group.MembershipRule -eq '(user.userType -eq "Guest")')
            {
                Write-CustomLog -Category 'Entra' -Subcategory 'Identity' -Message ("Dynamic group '{0}' have matching membership rule '{1}'" -f $group.DisplayName, $group.MembershipRule) -Level Verbose;

                # Add group to results.
                $null = $results.Add($group);
            }
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($results.Count -eq 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'a15e2ff5-2a03-495d-a4f2-4935742395d5';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity';
        $review.Title = 'Ensure a dynamic group for guest users is created';
        $review.Data = $results | Select-Object Id, DisplayName, MembershipRule, MembershipRuleProcessingState;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}