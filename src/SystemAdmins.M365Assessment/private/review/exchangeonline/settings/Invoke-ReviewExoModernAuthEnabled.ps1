function Invoke-ReviewExoModernAuthEnabled
{
    <#
    .SYNOPSIS
        If modern authentication is enabled.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewExoModernAuthEnabled;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name;

        # Write to log.
        Write-CustomLog -Category 'Exchange Online' -Subcategory 'Settings' -Message 'Getting organization configuration' -Level Verbose;

        # Get all organization settings.
        $organizationSettings = Get-OrganizationConfig;
    }
    PROCESS
    {
        # Get modern authentication settings.
        [bool]$modernAuthSettings = $organizationSettings.OAuth2ClientProfileEnabled;

        # Write to log.
        Write-CustomLog -Category 'Exchange Online' -Subcategory 'Settings' -Message ("Modern authentication is set to '{0}'" -f $modernAuthSettings) -Level Verbose;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $modernAuthSettings)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'bd574cc3-88f8-4ce5-9b0c-5c9982c2de10';
        $review.Category = 'Microsoft Exchange Admin Center';
        $review.Subcategory = 'Settings';
        $review.Title = "Ensure modern authentication for Exchange Online is enabled";
        $review.Data = [PSCustomObject]@{
            Enabled = $modernAuthSettings;
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}