function Invoke-Office365ManagementApi
{
    <#
    .SYNOPSIS
        Invoke Office 365 Management API.
    .DESCRIPTION
        Used to call the Office 365 Management API.
        Currently this use undocumented APIs from Microsoft.
    .PARAMETER Uri
        URI to the API.
    .PARAMETER Method
        GET or POST.
    .EXAMPLE
        # Get the external calendar sharing settings.
        Invoke-Office365ManagementApi -Uri 'https://admin.microsoft.com/admin/api/settings/apps/calendarsharing' -Method 'GET';
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
        # Get access token for Office 365 Management API.
        $accessToken = Get-Office365ManagementApiToken;

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
            Write-Log -Category "Authentication" -Message ('Trying to call Office 365 Management API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Debug;

            # Invoke API.
            $response = Invoke-RestMethod @param -ErrorAction Stop;

            # Write to log.
            Write-Log -Category "Authentication" -Message ('Successfully called Office 365 Management API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Debug;
        }
        # Something went wrong while invoking API.
        catch
        {
            # Throw execption.
            Write-Log -Category "Authentication" -Message ("Could not call Office 365 Management API, the exception is: '{0}'" -f $_) -Level 'Error';
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
        Write-Log -Category "Authentication" -Message ('Response from Office 365 Management API is empty') -Level 'Debug';
    }
}