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
        $azToken = Get-AzAccessToken -AsSecureString -WarningAction SilentlyContinue -ResourceUrl $uri | ConvertFrom-SecureString;

        # If the access token is null.
        if ($null -eq $azToken.Token)
        {
            # Throw exception.
            throw ('Something went wrong getting the access token');
        }

        # Save the token.
        $accessToken = $azToken.Token;
    }
    END
    {
        # Return the token.
        return $accessToken;
    }
}