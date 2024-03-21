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

        # Hide keep me signed in flag.
        $hideKeepMeSignedIn = $false;
    }
    PROCESS
    {
        try
        {
            # Write to log.
            Write-Log -Category 'Entra' -Subcategory 'Identity' -Message ("Getting 'Show keep user signed' login settings") -Level Debug;

            # Get the Entra ID property settings.
            $entraIdProperties = Invoke-EntraIdIamApi -Uri $uri -Method 'GET' -ErrorAction SilentlyContinue;

            # Write to log.
            Write-Log -Category 'Entra' -Subcategory 'Identity' -Message ("'Show keep user signed' is set to '{0}'" -f $entraIdProperties.hideKeepMeSignedIn) -Level Debug;

            # If the setting is set to true.
            if ($true -eq $entraIdProperties.hideKeepMeSignedIn)
            {
                # Set flag.
                $hideKeepMeSignedIn = $true;
            }
        }
        catch
        {
            # Write to log.
            Write-Log -Category 'Entra' -Subcategory 'Identity' -Message ("Not able to get 'Show keep user signed', this is usually because user have never modified the setting (default setting is 'true')" -f $entraIdProperties.hideKeepMeSignedIn) -Level Debug;
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($false -eq $hideKeepMeSignedIn)
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
        $review.Title = 'Ensure the option to remain signed in is hidden';
        $review.Data = [PSCustomObject]@{
            HideKeepMeSignedIn = $hideKeepMeSignedIn;
        };
        $review.Review = $reviewFlag;
        
        # Print result.
        $review.PrintResult();
                       
        # Return object.
        return $review;
    }
}