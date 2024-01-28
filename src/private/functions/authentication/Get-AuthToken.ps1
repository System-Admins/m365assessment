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

        # Url to the Exchange Online endpoint.
        [string]$office365Url = 'https://admin.microsoft.com';

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
            # If we should use the Office 365 admin endpoint.
            elseif ($Backend -eq 'Office365Api')
            {
                # Set the scope for the request.
                $scope = ('{0}/.default' -f $office365Url);
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
                Write-Log -Category "Authentication" -Message ("Getting access token from Entra ID with the scope '{0}'" -f $scope) -Level 'Debug';

                # Get the token.
                $token = Invoke-RestMethod -Uri $loginUrl -Method 'POST' -Body $body -ContentType 'application/x-www-form-urlencoded' -ErrorAction Stop;
                
                # Write to the log.
                Write-Log -Category "Authentication" -Message ('Succesfully got access token: {0}' -f $token) -Level Debug -NoLogFile;
            }
            # Something went wrong while getting the token.
            catch
            {
                # Write to the log.
                Write-Log -Category "Authentication" -Message ('Could not get access token from Entra ID, the exception is: {0}' -f $_) -Level 'Error';
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