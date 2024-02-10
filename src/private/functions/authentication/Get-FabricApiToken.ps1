function Get-FabricApiToken
{
    <#
    .SYNOPSIS
        Get access token to Microsoft Fabric API.
    .DESCRIPTION
        Requires the module "Az.Accounts".
    .EXAMPLE
        Get-EntraIdIamApiToken;
    #>
    [CmdletBinding()]
    Param
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
        # Get Azure token for Microsoft Fabric.
        $azToken = Get-AzAccessToken -ResourceUrl $uri;

        # If the access token is null.
        if ($null -eq $azToken.Token)
        {
            # Throw execption.
            Write-Log -Category 'Authentication' -Message ("Something went wrong getting access token for Microsoft Fabric API, execption is '{0}'" -f $_) -Level 'Error';
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