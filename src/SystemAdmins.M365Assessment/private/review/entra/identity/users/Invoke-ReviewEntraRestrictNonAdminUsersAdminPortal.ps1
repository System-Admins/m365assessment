function Invoke-ReviewEntraRestrictNonAdminUsersAdminPortal
{
    <#
    .SYNOPSIS
        If users are allowed to access admin portal in Entra ID.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewEntraRestrictNonAdminUsersAdminPortal;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # URI to the API.
        $uri = 'https://main.iam.ad.ext.azure.com/api/Directories/Properties';
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Identity' -Message ('Getting users are allowed to access Microsoft 365 admin portal settings') -Level Verbose;

        # Get the Entra ID property settings.
        $entraIdProperties = Invoke-EntraIdIamApi -Uri $uri -Method 'GET';

        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Identity' -Message ("Access to the Microsoft 365 admin portal is set to '{0}' for non-admins" -f $entraIdProperties.restrictNonAdminUsers) -Level Verbose;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $entraIdProperties.restrictNonAdminUsers)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '591c821b-52ca-48f3-806e-56a98d25c041';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity';
        $review.Title = "Ensure 'Restrict access to the Azure AD administration portal' is set to 'Yes'";
        $review.Data = [PSCustomObject]@{
            RestrictNonAdminUsers = $entraIdProperties.restrictNonAdminUsers
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}