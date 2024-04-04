function Invoke-ReviewOneDriveSyncRestrictedUnmanagedDevice
{
    <#
    .SYNOPSIS
        Review if OneDrive sync is restricted for unmanaged devices.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Pnp.PowerShell
    .EXAMPLE
        Invoke-ReviewOneDriveSyncRestrictedUnmanagedDevice;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name;

        # Write to log.
        Write-CustomLog -Category 'SharePoint Online' -Subcategory 'Settings' -Message ('Getting SharePoint tenant configuration') -Level Verbose;

        # Get tenant settings.
        $tenantSettings = Invoke-PnPSPRestMethod -Method Get -Url '/_api/SPOInternalUseOnly.Tenant';

        # Get hybrid AD connect status.
        $hybridAdConnectStatus = Get-EntraIdHybridAdConnectStatus;

        # Setting is valid.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If setting set to allow syncing only on computers joined to specific domains.
        if ($tenantSettings.AllowedDomainListForSyncClient.Count -gt 0)
        {
            # Return object.
            $valid = $true;

            # Write to log.
            Write-CustomLog -Category 'SharePoint Online' -Subcategory 'Settings' -Message ("OneDrive sync is restricted for unmanaged devices") -Level Verbose;
        }
    }
    END
    {
         # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $valid -and $hybridAdConnectStatus.dirSyncEnabled -eq $true)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'd1412fb3-33a5-4b8f-a7c1-9a491b121d21';
        $review.Category = 'Microsoft SharePoint Admin Center';
        $review.Subcategory = 'Settings';
        $review.Title = 'Ensure OneDrive sync is restricted for unmanaged devices';
        $review.Data = $tenantSettings | Select-Object @{Name='AllowedDomainListForSyncClient';Expression={$_.AllowedDomainListForSyncClient -join ', '}};
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}