function Invoke-FabricApi
{
    <#
    .SYNOPSIS
        Invoke Microsoft Fabric API.
    .DESCRIPTION
        Used to call the Microsoft Fabric API.
    .PARAMETER Uri
        URI to the API.
    .PARAMETER Method
        GET or POST.
    .EXAMPLE
        # Get the Entra ID property settings.
        Invoke-FabricApi -Uri 'https://api.fabric.microsoft.com/v1/admin/tenantsettings' -Method 'GET';
    #>
    [cmdletbinding()]
    param
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
        # Get access token for Microsoft Fabric API.
        $accessToken = Get-FabricApiToken;

        # Construct the headers for the request.
        $headers = @{
            'Content-Type'           = 'application/json; charset=UTF-8';
            'Authorization'          = ('Bearer {0}' -f $accessToken);
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
            Write-Log -Category "API" -Message ('Trying to call Microsoft Fabric API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Debug;

            # Invoke API.
            $response = Invoke-RestMethod @param -ErrorAction Stop;

            # Write to log.
            Write-Log -Category "API" -Message ('Successfully called Microsoft Fabric API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Debug;
        }
        # Something went wrong while invoking API.
        catch
        {
            # Throw execption.
            Write-Log -Category "API" -Message ("Could not call Microsoft Fabric API, the exception is: '{0}'" -f $_) -Level 'Error';
        }
    }
    END
    {
        # If the response is not null.
        if ($null -ne $response)
        {
            # Return the response.
            return $response;
        }

        # Write to log.
        Write-Log -Category "API" -Message ('Response from Microsoft Fabric API is empty') -Level 'Debug';
    }
}