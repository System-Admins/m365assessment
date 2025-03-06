function Invoke-EntraIdAccessReviewApi
{
    <#
    .SYNOPSIS
        Invoke Entra ID Access Review API.
    .DESCRIPTION
        Used to call the Entra ID Access Review API.
        Currently this use undocumented APIs from Microsoft.
    .NOTES
        Requires the following modules:
        - Az.Accounts
    .PARAMETER Uri
        URI to the API.
    .PARAMETER Method
        GET or POST.
    .EXAMPLE
        # Get the Entra ID property settings.
        Invoke-EntraIdAccessReviewApi -Uri 'https://api.accessreviews.identitygovernance.azure.com/accessReviews/v2.0/approvalWorkflowProviders/D5EC9F3B-324E-4F8A-AF55-B69EDD48ECBE/requests?$count=true&$orderby=createdDateTime%20desc&$skip=0&$top=10&$select=id,businessFlowId,decisionsCriteria,reviewedEntity,businessFlowTemplateId,policy,settings,errors,displayName,status,createdDateTime&$filter=((customDataProvider%20eq%20null))&x-tenantid=<tenantID>&{}&_=1706945719963' -Method 'GET';
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
        # Get access token for Entra ID Access Review API.
        $accessToken = (Get-AzAccessToken -AsSecureString -WarningAction SilentlyContinue).Token | ConvertFrom-SecureString -AsPlainText;

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
            Write-CustomLog -Category "API" -Subcategory 'Entra ID' -Message ('Trying to call access review API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Verbose;

            # Invoke API.
            $response = Invoke-RestMethod @param -ErrorAction Stop;

            # Write to log.
            Write-CustomLog -Category "API" -Subcategory 'Entra ID' -Message ('Successfully called access review API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Verbose;
        }
        # Something went wrong while invoking API.
        catch
        {
            # Throw exception.
            throw ("Could not call access review API, the exception is '{0}'" -f $_);
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
        Write-CustomLog -Category "API" -Subcategory 'Entra ID' -Message ('Response from access review API is empty') -Level Verbose;
    }
}