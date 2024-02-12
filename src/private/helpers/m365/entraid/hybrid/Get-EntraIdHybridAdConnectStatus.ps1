function Get-EntraIdHybridAdConnectStatus
{
    <#
    .SYNOPSIS
        Get the Entra ID hybrid AD connect status.
    .DESCRIPTION
        Returns object with settings.
    .EXAMPLE
        Get-EntraIdHybridAdConnectStatus;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # URI.
        $uri = "https://main.iam.ad.ext.azure.com/api/Directories/ADConnectStatus"
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'Entra ID' -Message 'Getting hybrid AD connect status' -Level Debug;

        # Invoke the request.
        $status = Invoke-EntraIdIamApi -Uri $uri -Method Get;

        # Write to log.
        Write-Log -Category 'Entra ID' -Message ("Hybrid AD connect status is '{0}'" -f $status.dirSyncEnabled) -Level Debug;
    }
    END
    {
        # Return status.
        return $status;
    }
}