function Invoke-EntraIdIamApi
{
    <#
    .SYNOPSIS
        Invoke Entra ID Iam API.
    .DESCRIPTION
        Used to call the Entra ID Iam API.
        Currently this use undocumented APIs from Microsoft.
    .PARAMETER Uri
        URI to the API.
    .PARAMETER Method
        GET or POST.
    .EXAMPLE
        # Get the Entra ID property settings.
        Invoke-Office365ManagementApi -Uri 'https://main.iam.ad.ext.azure.com/api/Directories/Properties' -Method 'GET';
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
        # Get access token for Entra ID IAM API.
        $accessToken = Get-EntraIdIamApiToken;

        # Construct the headers for the request.
        $headers = @{
            'Content-Type'           = 'application/json; charset=UTF-8';
            'Authorization'          = ('Bearer {0}' -f $accessToken);
            'X-Requested-With'       = 'XMLHttpRequest';
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
            Write-Log -Category "API" -Subcategory 'Entra ID' -Message ('Trying to call IAM API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Debug;

            # Invoke API.
            $response = Invoke-RestMethod @param -ErrorAction Stop;

            # Write to log.
            Write-Log -Category "API" -Subcategory 'Entra ID' -Message ('Successfully called IAM API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Debug;
        }
        # Something went wrong while invoking API.
        catch
        {
            # Throw exception.
            throw ("Could not call IAM API, the exception is '{0}'" -f $_);
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
        Write-Log -Category "API" -Subcategory 'Entra ID' -Message ('Response from IAM API is empty') -Level Debug;
    }
}