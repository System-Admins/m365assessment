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
        [string]$Method = 'GET'
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
        # Try to invoke API.
        try
        {
            # Write to log.
            Write-Log -Message ('Trying to call Office 365 Management API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Debug;

            # Invoke API.
            $response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $headers -ErrorAction Stop;

            # Write to log.
            Write-Log -Message ('Successfully called Office 365 Management API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Debug;
        }
        # Something went wrong while invoking API.
        catch
        {
            # Throw execption.
            Write-Log -Message ("Could not call Office 365 Management API, the exception is: '{0}'" -f $_) -Level 'Error';
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
        Write-Log -Message ('Response from Office 365 Management API is empty') -Level 'Debug';
    }
}