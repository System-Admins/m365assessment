function Invoke-ReviewEntraBlockLinkedInConnection
{
    <#
    .SYNOPSIS
        If "LinkedIn account connections" is enabled in Entra ID.
    .DESCRIPTION
        Returns review object.
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
        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Identity' -Message ("Getting 'LinkedIn account connections' settings") -Level Debug;

        # Get the Entra ID property settings.
        $entraIdProperties = Invoke-EntraIdIamApi -Uri $uri -Method 'GET';

        # If property is 1.
        if ($entraIdProperties.enableLinkedInAppFamily -eq 1)
        {
            # Set bool.
            $blockLinkedInConnection = $true;
        }

        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Identity' -Message ("'LinkedIn account connections' is set to '{0}'" -f $blockLinkedInConnection) -Level Debug;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $blockLinkedInConnection)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '23d22457-f5e2-4f55-9aba-e483e8cbb11d';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity';
        $review.Title = "Ensure 'LinkedIn account connections' is disabled";
        $review.Data = [PSCustomObject]@{
            BlockLinkedInConnection = $blockLinkedInConnection
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}