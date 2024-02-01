function Invoke-EntraIdRbacApi
{
    <#
    .SYNOPSIS
        Invoke Entra ID RBAC API.
    .DESCRIPTION
        Used to call the Entra ID RBAC API.
        Currently this use undocumented APIs from Microsoft.
    .PARAMETER Uri
        URI to the API.
    .PARAMETER Method
        GET or POST.
    .EXAMPLE
        # PIM RBAC roles.
        Invoke-EntraIdRbacApi -Uri 'https://api.azrbac.mspim.azure.com/api/v2/privilegedAccess/aadroles/resources/<tenant ID>/roleDefinitions?$select=id,displayName,type,templateId,resourceId,externalId,isbuiltIn,subjectCount,eligibleAssignmentCount,activeAssignmentCount&$orderby=displayName' -Method 'GET';
    #>
    [CmdletBinding()]
    Param
    (
        # API URL.
        [Parameter(Mandatory = $true)]
        [string]$Uri,

        # Method (GET, POST etc).
        [Parameter(Mandatory = $false)]
        [ValidateSet('GET', 'POST')]
        [string]$Method = 'GET',

        # Body for the request.
        [Parameter(Mandatory = $false)]
        $Body
    )
    
    BEGIN
    {
        # Get access token for Entra ID.
        $accessToken = (Get-AzAccessToken).Token

        # Construct the headers for the request.
        $headers = @{
            'Content-Type'           = 'application/json; charset=UTF-8';
            'Authorization'          = ('Bearer {0}' -f $accessToken);
            'x-ms-client-request-id' = [guid]::NewGuid();
            'x-ms-correlation-id'    = [guid]::NewGuid();
        };
    }
    PROCESS
    {
        # Create parameter splatting.
        $param = @{
            Uri     = $Uri;
            Method  = $Method;
            Headers = $headers;
        };

        # If body is not null.
        if ($null -ne $Body)
        {
            # Add body to parameter splatting.
            $param.Add('Body', $Body);
        }

        # Try to invoke API.
        try
        {
            # Write to log.
            Write-Log -Category "API" -Message ('Trying to call Entra ID RBAC API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Debug;

            # Invoke API.
            $response = Invoke-RestMethod @param -ErrorAction Stop;

            # Write to log.
            Write-Log -Category "API" -Message ('Successfully called Entra ID RBAC API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Debug;
        }
        # Something went wrong while invoking API.
        catch
        {
            # Throw execption.
            Write-Log -Category "API" -Message ("Could not call Entra ID RBAC API, the exception is: '{0}'" -f $_) -Level 'Error';
        }
    }
    END
    {
        # If the response is not null.
        if ($null -ne $response.value)
        {
            # Return the response.
            return $response.value;
        }

        # Write to log.
        Write-Log -Category "API" -Message ('Response from Entra ID RBAC API is empty') -Level 'Debug';
    }
}