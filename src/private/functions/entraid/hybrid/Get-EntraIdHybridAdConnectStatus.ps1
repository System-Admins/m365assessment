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

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # URI.
        $uri = "https://main.iam.ad.ext.azure.com/api/Directories/ADConnectStatus"
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