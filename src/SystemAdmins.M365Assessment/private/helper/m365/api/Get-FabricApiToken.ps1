function Get-FabricApiToken
{
    <#
    .SYNOPSIS
        Get access token to Microsoft Fabric API.
    .DESCRIPTION
        Requires the module "Az.Accounts".
    .NOTES
        Requires the following modules:
        - Az.Accounts
    .EXAMPLE
        Get-FabricApiToken;
    #>
    [cmdletbinding()]
    param
    (
    )
    BEGIN
    {
        # Variable to store access token.
        [string]$accessToken = '';

        # Resource URI for the Fabric API.
        $uri = 'https://api.fabric.microsoft.com';
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category 'API' -Subcategory 'Microsoft Fabric' -Message ('Getting access token') -Level Verbose;

        # Get Azure token for Microsoft Fabric.
        $accessToken = (Get-AzAccessToken -AsSecureString -WarningAction SilentlyContinue -ResourceUrl $uri).Token | ConvertFrom-SecureString -AsPlainText;

        # If the access token is null.
        if ([string]::IsNullOrEmpty($accessToken))
        {
            # Throw exception.
            throw ('Something went wrong getting the access token');
        }
    }
    END
    {
        # Return the token.
        return $accessToken;
    }
}