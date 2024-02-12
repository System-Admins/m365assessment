function Invoke-ReviewOneDriveSyncRestrictedUnmanagedDevices
{
    <#
    .SYNOPSIS
        Review if OneDrive sync is restricted for unmanaged devices.
    .DESCRIPTION
        Return true if enabled, otherwise false.
    .EXAMPLE
        Invoke-ReviewOneDriveSyncRestrictedUnmanagedDevices;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get tenant settings.
        $tenantSettings = Invoke-PnPSPRestMethod -Method Get -Url '/_api/SPOInternalUseOnly.Tenant';

        # Setting is valid.
        [bool]$oneDriveSyncValid = $false;
    }
    PROCESS
    {
        # If setting set to allow syncing only on computers joined to specifc domains.
        if ($tenantSettings.AllowedDomainListForSyncClient.Count -gt 0)
        {
            # Return object.
            $oneDriveSyncValid = $true;
        }
    }
    END
    {
        # Return object.
        return [bool]$oneDriveSyncValid;
    } 
}