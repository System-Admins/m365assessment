function Get-MsAdminApiToken
{
    <#
    .SYNOPSIS
        Get access token to Microsoft Admin API.
    .DESCRIPTION
        Using undocumented API to get access token to Microsoft Admin API.
    .NOTES
        Requires the following modules:
        - Az.Accounts
    .EXAMPLE
        Get-MsAdminApiToken;
    #>
    [cmdletbinding()]
    param
    (
    )
    BEGIN
    {
        # Variable to store access token.
        [string]$accessToken = '';

        # Resource URL for the API.
        $resourceUrl = 'https://admin.microsoft.com/';
    }
    PROCESS
    {
        # Get the current Azure context.
        $azContext = Get-AzContext;

        # If the context is null.
        if ($null -eq $azContext)
        {
            # Throw exception.
            Write-Log -Category 'API' -Subcategory 'Admin API' -Message 'Could not get Azure context, a connection need to be established using the "Connect-AzAccount" cmdlet' -Level Error;
        }

        # Try to get access token.
        try
        {
            # Write to log.
            Write-Log -Category 'API' -Subcategory 'Admin API' -Message ('Getting access token for Microsoft Admin API') -Level Debug;

            # Get access token.
            $accessToken = (Get-AzAccessToken -ResourceUrl $resourceUrl).Token;

            # Write to log.
            Write-Log -Category 'API' -Subcategory 'Admin API' -Message ('Successfully got access token for Microsoft Admin API') -Level Debug;
        }
        # Something went wrong getting token.
        catch
        {
            # Throw exception.
            Write-Log -Category 'API' -Subcategory 'Admin API' -Message ("Something went wrong getting access token for Microsoft Admin API, exception is '{0}'" -f $_) -Level Error;
        }

        # If the access token is null.
        if ($null -eq $accessToken)
        {
            # Throw exception.
            Write-Log -Category 'API' -Subcategory 'Admin API' -Message ('Access token for Microsoft Admin API is not valid') -Level Error;
        }
    }
    END
    {
        # Return the token.
        return $accessToken;
    }
}