function Invoke-ReviewEntraHybridPasswordHashSync
{
    <#
    .SYNOPSIS
        Check that password hash sync is enabled for hybrid deployments.
    .DESCRIPTION
        Return true if configured correct otherwise false.
    .EXAMPLE
        Invoke-ReviewEntraHybridPasswordHashSync;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
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
        # Return bool.
        return $valid;
    }
}