function Get-EntraIdHybridAdConnectPasswordSyncStatus
{
    <#
    .SYNOPSIS
        Get the Entra ID hybrid AD connect password sync status.
    .DESCRIPTION
        Returns object with settings.
    .EXAMPLE
        Get-EntraIdHybridAdConnectPasswordSyncStatus;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # URI.
        $uri = "https://main.iam.ad.ext.azure.com/api/Directories/GetPasswordSyncStatus"
    }
    PROCESS
    {
        # Invoke the request.
        $status = Invoke-EntraIdIamApi -Uri $uri -Method Get;
    }
    END
    {
        # Return status.
        return $status;
    }
}