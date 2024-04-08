function Invoke-ReviewEntraApplicationUserConsent
{
    <#
    .SYNOPSIS
        If user consent to apps accessing company data on their behalf is not allowed in Entra ID.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Beta.Reports
    .EXAMPLE
        Invoke-ReviewEntraApplicationUserConsent;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # Get user consent setting.
        $userConsentSetting = Get-EntraIdApplicationUserConsentSetting;

        # Boolean if valid.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If don't allow user consent.
        if ($userConsentSetting -eq 'DoNotAllowUserConsent')
        {
            # Set valid.
            $valid = $true;
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $valid)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'ca409d22-6638-48ff-ad7c-4a61e3488b94';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity';
        $review.Title = 'Ensure user consent to apps accessing company data on their behalf is not allowed';
        $review.Data = [PSCustomObject]@{
            UserConsentSetting = $userConsentSetting;
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}