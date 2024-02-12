function Invoke-EntraIdAccessReviewApi
{
    <#
    .SYNOPSIS
        Invoke Entra ID Access Review API.
    .DESCRIPTION
        Used to call the Entra ID Access Review API.
        Currently this use undocumented APIs from Microsoft.
    .PARAMETER Uri
        URI to the API.
    .PARAMETER Method
        GET or POST.
    .EXAMPLE
        # Get the Entra ID property settings.
        Invoke-EntraIdAccessReviewApi -Uri 'https://api.accessreviews.identitygovernance.azure.com/accessReviews/v2.0/approvalWorkflowProviders/D5EC9F3B-324E-4F8A-AF55-B69EDD48ECBE/requests?$count=true&$orderby=createdDateTime%20desc&$skip=0&$top=10&$select=id,businessFlowId,decisionsCriteria,reviewedEntity,businessFlowTemplateId,policy,settings,errors,displayName,status,createdDateTime&$filter=((customDataProvider%20eq%20null))&x-tenantid=<tenantID>&{}&_=1706945719963' -Method 'GET';
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
        # Get access token for Entra ID Access Review API.
        $accessToken = (Get-AzAccessToken).Token;

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
            Write-Log -Category "API" -Message ('Trying to call Entra ID Access Review API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Debug;

            # Invoke API.
            $response = Invoke-RestMethod @param -ErrorAction Stop;

            # Write to log.
            Write-Log -Category "API" -Message ('Successfully called Entra ID Access Review API with the method "{0}" and the URL "{1}"' -f $Method, $Uri) -Level Debug;
        }
        # Something went wrong while invoking API.
        catch
        {
            # Throw execption.
            Write-Log -Category "API" -Message ("Could not call Entra ID Access Review API, the exception is: '{0}'" -f $_) -Level 'Error';
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
        Write-Log -Category "API" -Message ('Response from Entra ID Access Review API is empty') -Level 'Debug';
    }
}