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

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # URI.
        $uri = "https://main.iam.ad.ext.azure.com/api/Directories/GetPasswordSyncStatus"
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Hybrid' -Message 'Getting hybrid AD connect password sync status' -Level Verbose;

        # Invoke the request.
        $status = Invoke-EntraIdIamApi -Uri $uri -Method Get;

        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Hybrid' -Message ("Hybrid AD connect password sync status is '{0}'" -f $status) -Level Verbose;
    }
    END
    {
        # Return status.
        return $status;
    }
}