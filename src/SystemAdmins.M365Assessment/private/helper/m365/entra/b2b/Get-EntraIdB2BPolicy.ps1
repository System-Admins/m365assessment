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

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # URI.
        $uri = "https://main.iam.ad.ext.azure.com/api/B2B/b2bPolicy"
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Policy' -Message 'Getting B2B policy' -Level Verbose;

        # Invoke the request.
        $policies = Invoke-EntraIdIamApi -Uri $uri -Method Get;
    }
    END
    {
        # Return policies.
        return $policies;
    }
}