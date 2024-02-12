function Get-EntraIdIamApiToken
{
    <#
    .SYNOPSIS
        Get access token to Entra ID IAM API.
    .DESCRIPTION
        Using undocumented API to get access token to Entra ID IAM API.
    .NOTES
        Requires the following modules:
        - Az.Accounts
    .EXAMPLE
        Get-EntraIdIamApiToken;
    #>
    [cmdletbinding()]
    param
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
            Write-Log -Category 'Authentication' -Message 'Could not get Azure context, a connection need to be established using the "Connect-AzAccount" cmdlet' -Level Error;
        }

        # Try to get access token.
        try
        {
            # Write to log.
            Write-Log -Category 'Authentication' -Message ('Getting access token for Entra ID IAM API') -Level 'Debug';

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

            # Write to log.
            Write-Log -Category 'Authentication' -Message ('Successfully got access token for Entra ID IAM API') -Level Debug;
        }
        # Something went wrong getting token.
        catch
        {
            # Throw execption.
            Write-Log -Category 'Authentication' -Message ("Something went wrong getting access token for Entra ID IAM API, execption is '{0}'" -f $_) -Level Error;
        }

        # If the access token is null.
        if ($null -eq $jwtToken.AccessToken)
        {
            # Throw execption.
            Write-Log -Category 'Authentication' -Message ('Access token for Entra ID IAM API is not valid') -Level Error;
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