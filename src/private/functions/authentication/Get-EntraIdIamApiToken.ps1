function Get-EntraIdIamApiToken
{
    <#
    .SYNOPSIS
        Get access token to Entra ID IAM API.
    .DESCRIPTION
        Using undocumented API to get access token to Entra ID IAM API.
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

        # Known resource ID for Azure PowerShell.
        $resourceId = '74658136-14ec-4630-ad9b-26e160ff0fc6';
    }
    PROCESS
    {
        # Get the current Azure context.
        $azContext = Get-AzContext;

        # If the context is null.
        if ($null -eq $azContext)
        {
            # Throw execption.
            Write-Log -Category 'Authentication' -Message 'Could not get Azure context, a connection need to be established using the "Connect-AzAccount" cmdlet' -Level 'Error';
        }

        

        # Construct (JTW) access token.
        $jwtToken = [Microsoft.Azure.Commands.Common.Authentication.AzureSession]::Instance.AuthenticationFactory.Authenticate(
            $azContext.Account,
            $azContext.Environment,
            $azContext.Tenant.Id.ToString(),
            $null,
            [Microsoft.Azure.Commands.Common.Authentication.ShowDialog]::Never,
            $null,
            $resourceId
        );

        # If the access token is null.
        if ($null -eq $jwtToken.AccessToken)
        {
            # Throw execption.
            Write-Log -Category 'Authentication' -Message ("Something went wrong getting access token for Entra ID IAM API, execption is '{0}'" -f $_) -Level 'Error';
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