function Invoke-ReviewEntraHybridPasswordHashSync
{
    <#
    .SYNOPSIS
        Check that password hash sync is enabled for hybrid deployments.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewEntraHybridPasswordHashSync;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # Get the hybrid AD connect status.
        $adConnectStatus = Get-EntraIdHybridAdConnectStatus;

        # Get the hybrid AD connect password sync status.
        $adConnectPasswordSyncStatus = Get-EntraIdHybridAdConnectPasswordSyncStatus;

        # Boolean for the settings is correct.
        [bool]$valid = $true;
    }
    PROCESS
    {
        # If the AD connect is enabled.
        if ($true -eq $adConnectStatus.dirSyncEnabled)
        {
            # If the AD connect password sync is disabled.
            if ($false -eq $adConnectPasswordSyncStatus)
            {
                # Set bool.
                $valid = $false;
            }
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
        $review.Id = 'ac82d275-9102-4df6-bf3c-ca012a74a306';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity';
        $review.Title = 'Ensure that password hash sync is enabled for hybrid deployments';
        $review.Data = [PSCustomObject]@{
            dirSyncEnabled      = $adConnectStatus.dirSyncEnabled;
            passwordSyncEnabled = $adConnectPasswordSyncStatus;
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}