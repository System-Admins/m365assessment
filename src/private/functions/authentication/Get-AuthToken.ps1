function Get-AuthToken
{
    <#
    .SYNOPSIS
        Get Microsoft Graph token.
    .DESCRIPTION
        Connect to Microsoft Graph and get token from in-memory.
    .PARAMETER ServicePrincipal
        If service principal/Entra ID application should be used as authentication method.
    .PARAMETER TenantId
        Entra ID tenant ID.
    .PARAMETER ClientId
        Entra ID application client ID (not the object ID).
    .PARAMETER ClientSecret
        Entra ID application client secret.
    .EXAMPLE
        # Get Microsoft Graph token.
        Get-AuthToken -ServicePrincipal -TenantId <tenantId> -ClientId <clientId> -ClientSecret <clientSecret>;

    #>
    [CmdletBinding()]
    Param
    (
        # If we should get the connection to Microsoft Graph or Exchange Online.
        [Parameter(Mandatory = $true)]
        [ValidateSet('Microsoft.Graph', 'Exchange.Online')]
        [string]$Backend,

        # If service principal/Entra ID application should be used as authentication method.
        [Parameter(Mandatory = $true)]
        [Parameter(ParameterSetName = 'ServicePrincipal')]
        [switch]$ServicePrincipal,

        # Entra ID tenant ID.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Parameter(ParameterSetName = 'ServicePrincipal')]
        [string]$TenantId,

        # Entra ID application client ID (not the object ID).
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Parameter(ParameterSetName = 'ServicePrincipal')]
        [string]$ClientId,

        # Entra ID application client secret.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Parameter(ParameterSetName = 'ServicePrincipal')]
        [string]$ClientSecret
    )
    
    BEGIN
    {
        # Login URL for the Entra ID authentication endpoint.
        [string]$loginUrl = ('https://login.microsoftonline.com/{0}/oauth2/v2.0/token' -f $TenantId);

        # Url to the Microsoft Graph endpoint.
        [string]$graphUrl = 'https://graph.microsoft.com';

        # Url to the Exchange Online endpoint.
        [string]$exchangeUrl = 'https://outlook.office365.com';

        # Variable to store the scope.
        [string]$scope = '';
    }
    PROCESS
    {
        # If we should use the service principal authentication method.
        if ($true -eq $ServicePrincipal)
        {
            # If we should use the graph endpoint.
            if ($Backend -eq 'Microsoft.Graph')
            {
                # Set the scope for the request.
                $scope = ('{0}/.default' -f $graphUrl);
            }
            # If we should use the Exchange Online endpoint.
            elseif ($Backend -eq 'Exchange.Online')
            {
                # Set the scope for the request.
                $scope = ('{0}/.default' -f $exchangeUrl);
            }

            # Construct the body for the request.
            $body = @{ 
                'grant_type'    = 'client_credentials'; 
                'scope'         = $scope;
                'client_id'     = $ClientId;
                'client_Secret' = $ClientSecret;
            };

            # Try to get the token.
            try
            {
                # Write to the log.
                Write-Log -Message ("Getting access token from Entra ID with the scope '{0}'" -f $scope) -Level 'Debug';

                # Get the token.
                $token = Invoke-RestMethod -Uri $loginUrl -Method 'POST' -Body $body -ContentType 'application/x-www-form-urlencoded' -ErrorAction Stop;
                
                # Write to the log.
                Write-Log -Message ('Succesfully got access token: {0}' -f $token) -Level Debug -NoLogFile;
            }
            # Something went wrong while getting the token.
            catch
            {
                # Write to the log.
                Write-Log -Message ('Could not get access token from Entra ID, the exception is: {0}' -f $_) -Level 'Error';
            }
        }
    }
    END
    {
        # If the access token is not null.
        if ($null -ne $token.access_token)
        {
            # Return the token.
            return $token.access_token;
        }
    }
}

function Get-MgGraphTokenFromMemory
{
    <#
    .SYNOPSIS
        Get Microsoft Graph token from in-memory token cache.
    .DESCRIPTION
        Uses reflection to get the Microsoft Graph token from the in-memory token cache.
    .EXAMPLE
        $token = Get-MgGraphTokenFromMemory;
    #>
    [cmdletBinding()]
    param
    ( 
    )

    BEGIN
    {
        # Variable to store the token.
        [string]$token = '';
    }
    PROCESS
    {
        # Try to get token from memory.
        try
        {
            # Write to the log.
            Write-Log -Message ('Getting access token from memory') -Level 'Debug';

            # Get the token data from the in-memory token cache.
            $inMemoryTokenCacheGetTokenData = [Microsoft.Graph.PowerShell.Authentication.Core.TokenCache.InMemoryTokenCache].GetMethod('ReadTokenData', [System.Reflection.BindingFlags]::NonPublic + [System.Reflection.BindingFlags]::Instance);
                
            # This is the byte array containing the token data.
            $tokenData = $inMemoryTokenCacheGetTokenData.Invoke([Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance.InMemoryTokenCache, $null);
                
            # This is the JWT as a base64 string.
            [System.Convert]::ToBase64String($tokenData);
                
            # Get the token as a UTF8 string.
            $token = [System.Text.Encoding]::UTF8.GetString($tokenData);

            # Write to the log.
            Write-Log -Message ('Microsoft Graph access token is: {0}' -f $token) -Level Debug -NoLogFile;
        }
        # Something went wrong while getting the token from memory.
        catch
        {
            # Write to the log.
            Write-Log -Message ('Could not get Microsoft Graph token from memory') -Level 'Error';
        }
    }
    END
    {
        # Return the token.
        return $token;
    }
}