function Invoke-ReviewEntraExternalCollaborationDomain
{
    <#
    .SYNOPSIS
        Check that collaboration invitations are sent to allowed domains only.
   .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewEntraExternalCollaborationDomain;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # Get the B2B policy.
        $policy = Get-EntraIdB2BPolicy;

        # Boolean for the settings is correct.
        [bool]$valid = $true;

    }
    PROCESS
    {
        # If the policy is not a allow list.
        if ($false -eq $policy.isAllowlist)
        {
            # Set bool.
            $valid = $false;
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $valid)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '54848e5b-7bb0-4a70-aeb1-63a1e54562d6';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity';
        $review.Title = 'Ensure that collaboration invitations are sent to allowed domains only';
        $review.Data = $policy | Select-Object isAllowlist, @{ Name = 'targetedDomains'; Expression = { $_.targetedDomains -join ', ' } };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        #Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}