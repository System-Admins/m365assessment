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
        # Create a credential object from the input username and password.
        $clientSecretCredential = New-PSCredential -Username $ClientId -Password $ClientSecret;

        # Variable to store the token.
        [string]$token = '';
    }
    PROCESS
    {
        # Try to connect to Microsoft Graph.
        try
        {
            # Write to the log.
            Write-Log -Message 'Connecting to Microsoft Graph' -Level 'Information';

            # Connect to Microsoft Graph.
            Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $clientSecretCredential -NoWelcome -ErrorAction Stop;

            # Write to the log.
            Write-Log -Message 'Successfully connected to Microsoft Graph' -Level 'Information';
        }
        # Something went wrong while connecting to Microsoft Graph.
        catch
        {
            # Write to the log.
            Write-Log -Message ("Something went wrong while connecting to Microsoft Graph. Exception is: {0}" -f $_.Exception.Message) -Level 'Error';
        }


        # It the token is in-memory.
        if ([Microsoft.Graph.PowerShell.Authentication.GraphSession]::Instance.AuthContext.Scopes)
        {
            # Get the token from memory.
            $token = Get-MgGraphTokenFromMemory;
        }
    }
    END
    {
        # If the token is not empty.
        if (! [string]::IsNullOrEmpty($token))
        {
            # Return the token.
            return $token;
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
                
            # Get the JWT as a UTF8 string and convert it to a object.
            $jwtObject = [System.Text.Encoding]::UTF8.GetString($tokenData) | ConvertFrom-Json -AsHashtable;
        
            # Get the token.
            $token = $jwtObject.AccessToken.Values.secret;

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