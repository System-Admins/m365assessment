function Invoke-ReviewEntraHideKeepMeSignedIn
{
    <#
    .SYNOPSIS
        If "Show keep user signed in" is enabled in Entra ID.
    .DESCRIPTION
        Return true or false.
    .EXAMPLE
        Invoke-ReviewEntraHideKeepMeSignedIn;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # URI to the API.
        $uri = 'https://main.iam.ad.ext.azure.com/api/LoginTenantBrandings/0';   
    }
    PROCESS
    {
        # Get the Entra ID property settings.
        $entraIdProperties = Invoke-EntraIdIamApi -Uri $uri -Method 'GET';
    }
    END
    {
        # Return state.
        return [bool]$entraIdProperties.hideKeepMeSignedIn;
    }
}