function Invoke-ReviewFormsPhishingProtection
{
    <#
    .SYNOPSIS
        Review that internal phishing protection for Microsoft Forms is enabled.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewFormsPhishingProtection;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name;
    }
    PROCESS
    {
        # Get Microsoft Forms organization settings.
        $settings = Get-TenantOfficeFormSetting;

        # Write to log.
        Write-CustomLog -Category 'Microsoft Forms' -Subcategory 'Policy' -Message ("Internal phishing protection is set to '{0}'" -f $settings.InOrgFormsPhishingScanEnabled) -Level Verbose;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If the review flag should be set.
        if ($false -eq $settings.InOrgFormsPhishingScanEnabled)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '229fc460-ec0c-4e88-89db-0b8a883ba3e0';
        $review.Category = 'Microsoft 365 Admin Center';
        $review.Subcategory = 'Settings';
        $review.Title = "Ensure internal phishing protection for Forms is enabled";
        $review.Data = [PSCustomObject]@{
            Enabled = $settings.InOrgFormsPhishingScanEnabled;
        }
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}