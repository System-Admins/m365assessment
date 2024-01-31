function Get-EntraIdB2BPolicy
{
    <#
    .SYNOPSIS
        Get the B2B Entra ID collaboration settings.
    .DESCRIPTION
        Returns object with settings
    .EXAMPLE
        Get-EntraIdB2BPolicy;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # URI.
        $uri = "https://main.iam.ad.ext.azure.com/api/B2B/b2bPolicy"
    }
    PROCESS
    {
        # Invoke the request.
        $policies = Invoke-EntraIdIamApi -Uri $uri -Method Get;
    }
    END
    {
        # Return policies.
        return $policies;
    }
}