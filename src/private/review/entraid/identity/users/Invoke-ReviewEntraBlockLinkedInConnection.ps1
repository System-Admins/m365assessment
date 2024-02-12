function Invoke-ReviewEntraBlockLinkedInConnection
{
    <#
    .SYNOPSIS
        If "LinkedIn account connections" is enabled in Entra ID.
    .DESCRIPTION
        Return true if blocked otherwise false if enabled.
    .EXAMPLE
        Invoke-ReviewEntraBlockLinkedInConnection;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # URI to the API.
        $uri = 'https://main.iam.ad.ext.azure.com/api/Directories/Properties';

        # Boolean if enabled.
        [bool]$blockLinkedInConnection = $false;
    }
    PROCESS
    {
        # Get the Entra ID property settings.
        $entraIdProperties = Invoke-EntraIdIamApi -Uri $uri -Method 'GET';

        # If property is 1.
        if ($entraIdProperties.enableLinkedInAppFamily -eq 1)
        {
            # Set bool.
            $blockLinkedInConnection = $true;
        }
    }
    END
    {
        # Return state.
        return [bool]$blockLinkedInConnection;
    }
}