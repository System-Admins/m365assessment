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
            throw ('Could not get Azure context, a connection need to be established using the "Connect-AzAccount" cmdlet');
        }

        # Try to get access token.
        try
        {
            # Write to log.
            Write-CustomLog -Category 'API' -Subcategory 'Admin API' -Message ('Getting access token for Microsoft Admin API') -Level Verbose;

            # Get access token.
            $accessToken = (Get-AzAccessToken -AsSecureString -WarningAction SilentlyContinue -ResourceUrl $resourceUrl).Token | ConvertFrom-SecureString;

            # Write to log.
            Write-CustomLog -Category 'API' -Subcategory 'Admin API' -Message ('Successfully got access token for Microsoft Admin API') -Level Verbose;
        }
        # Something went wrong getting token.
        catch
        {
            # Throw exception.
            throw ("Something went wrong getting access token for Microsoft Admin API, exception is '{0}'" -f $_);
        }

        # If the access token is null.
        if ($null -eq $accessToken)
        {
            # Throw exception.
            throw ('Access token for Microsoft Admin API is not valid');
        }
    }
    END
    {
        # Return the token.
        return $accessToken;
    }
}