function Invoke-MsAdminApi
{
    <#
    .SYNOPSIS
        Invoke Microsoft Admin API.
    .DESCRIPTION
        Used to call the Microsoft Admin API.
    .PARAMETER Uri
        URI to the API.
    .PARAMETER Method
        GET or POST.
    .EXAMPLE
        # Get the tenant properties such as company name.
        Invoke-MsAdminApi -Uri 'https://admin.microsoft.com/admin/api/Settings/company/profile' -Method 'GET';
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
        # Get access token for Microsoft Admin API.
        $accessToken = Get-MsAdminApiToken;

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
            Write-CustomLog -Category "API" -Subcategory 'Microsoft Admin' -Message ('Trying to call API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Verbose;

            # Invoke API.
            $response = Invoke-RestMethod @param -ErrorAction Stop;

            # Write to log.
            Write-CustomLog -Category "API" -Subcategory 'Microsoft Admin' -Message ('Successfully called API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Verbose;
        }
        # Something went wrong while invoking API.
        catch
        {
            # Throw exception.
            throw ("Could not call API, the exception is '{0}'" -f $_);
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
        Write-CustomLog -Category "API" -Subcategory 'Microsoft Admin' -Message ('Response from API is empty') -Level Verbose;
    }
}