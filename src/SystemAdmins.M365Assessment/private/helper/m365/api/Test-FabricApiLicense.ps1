function Test-FabricApiLicense
{
    <#
    .SYNOPSIS
        Test if user have a valid Fabric license for the API.
    .DESCRIPTION
        Return true if valid otherwise false.
    .EXAMPLE
        Test-FabricApiLicense;
    #>
    [cmdletbinding()]
    [OutputType([bool])]
    param
    (
    )

    BEGIN
    {
        # Get access token for Microsoft Fabric API.
        $accessToken = Get-FabricApiToken;

        # URI to the API.
        [string]$uri = 'https://api.fabric.microsoft.com/v1/admin/tenantsettings';

        # Construct the headers for the request.
        [hashtable]$headers = @{
            'Content-Type'  = 'application/json; charset=UTF-8';
            'Authorization' = ('Bearer {0}' -f $accessToken);
        };

        # Valid license.
        [bool]$validLicense = $false;
    }
    PROCESS
    {
        # Create parameter splatting.
        [hashtable]$param = @{
            Uri     = $Uri;
            Method  = 'GET';
            Headers = $headers;
        };

        # Try to invoke API.
        try
        {
            # Write to log.
            Write-CustomLog -Category 'API' -Subcategory 'Microsoft Fabric' -Message ('Trying to call API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Verbose;

            # Invoke API.
            $null = Invoke-RestMethod @param -ErrorAction Stop;

            # Write to log.
            Write-CustomLog -Category 'API' -Subcategory 'Microsoft Fabric' -Message ('Successfully called API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Verbose;

            # Set valid license to true.
            $validLicense = $true;
        }
        # Something went wrong while invoking API.
        catch
        {
            # Get error API code.
            $errorApiCode = ($_.Exception.Response.Headers) | Where-Object { $_.Key -eq 'x-ms-public-api-error-code' } | Select-Object -ExpandProperty Value;

            # If error API code is 'UserNotLicensed'.
            if ($errorApiCode -eq 'UserNotLicensed')
            {
                # Set valid license to true.
                $validLicense = $false;

                # Write to log.
                Write-CustomLog -Category 'API' -Subcategory 'Microsoft Fabric' -Message ('User is not licensed for the API') -Level Verbose;
            }
        }
    }
    END
    {
        # Return valid license.
        return $validLicense;
    }
}