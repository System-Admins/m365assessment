function Invoke-ReviewEntraHideKeepMeSignedIn
{
    <#
    .SYNOPSIS
        If "Show keep user signed in" is enabled in Entra ID.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewEntraHideKeepMeSignedIn;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # URI to the API.
        $uri = 'https://main.iam.ad.ext.azure.com/api/LoginTenantBrandings/0';   
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Identity' -Message ("Getting 'Show keep user signed' login settings") -Level Debug;

        # Get the Entra ID property settings.
        $entraIdProperties = Invoke-EntraIdIamApi -Uri $uri -Method 'GET';

        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Identity' -Message ("'Show keep user signed' is set to '{0}'" -f $entraIdProperties.hideKeepMeSignedIn) -Level Debug;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($false -eq $entraIdProperties.hideKeepMeSignedIn)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                               
        # Create new review object to return.
        [Review]$review = [Review]::new();
                       
        # Add to object.
        $review.Id = '08798711-af3c-4fdc-8daf-947b050dca95';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity';
        $review.Title = "Ensure the option to remain signed in is hidden";
        $review.Data = [PSCustomObject]@{
            HideKeepMeSignedIn = $entraIdProperties.hideKeepMeSignedIn
        };
        $review.Review = $reviewFlag;
        
        # Print result.
        $review.PrintResult();
                       
        # Return object.
        return $review;
    }
}