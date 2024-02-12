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
        Write-Log -Category 'Authentication' -Message ('Getting access token for Microsoft Fabric API') -Level Debug;

        # Get Azure token for Microsoft Fabric.
        $azToken = Get-AzAccessToken -ResourceUrl $uri;

        # If the access token is null.
        if ($null -eq $azToken.Token)
        {
            # Throw execption.
            Write-Log -Category 'Authentication' -Message ('Something went wrong getting access token for Microsoft Fabric API') -Level Error;
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