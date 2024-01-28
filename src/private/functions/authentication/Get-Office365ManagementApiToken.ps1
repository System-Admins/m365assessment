function Get-Office365ManagementApiToken
{
    <#
    .SYNOPSIS
        Get access token to Office 365 Manament Api.
    .DESCRIPTION
        Using undocumented API to get access token to Office 365 Management API.
        Requires the module "Az.Accounts".
    .EXAMPLE
        Get-Office365ManagementApiToken;
    #>
    [CmdletBinding()]
    Param
    (
    )
    BEGIN
    {
        # Variable to store access token.
        [string]$accessToken = '';
    }
    PROCESS
    {
        # Get the current Azure context.
        $azContext = Get-AzContext;

        # If the context is null.
        if ($null -eq $azContext)
        {
            # Throw execption.
            Write-Log -Category "Authentication" -Message 'Could not get Azure context, a connection need to be established using the "Connect-AzAccount" cmdlet' -Level 'Error';
        }

        # Construct (JTW) access token.
        $jwtToken = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory.Authenticate(
            $azContext.Account,
            $azContext.Environment,
            $azContext.Tenant.Id.ToString(),
            $null,
            [Microsoft.Azure.Commands.Common.Authentication.ShowDialog]::Auto,
            $null,
            'https://admin.microsoft.com'
        );

        # If the access token is null.
        if ($null -eq $jwtToken.AccessToken)
        {
            # Throw execption.
            Write-Log -Category "Authentication" -Message ("Something went wrong getting access token for Office 365 Management API, execption is '{0}'" -f $_) -Level 'Error';
        }

        # Save the token.
        $accessToken = $jwtToken.AccessToken;
    }
    END
    {
        # Return the token.
        return $accessToken;
    }
}