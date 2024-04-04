function Invoke-ReviewEntraApplicationAdminConsentWorkflowEnabled
{
    <#
    .SYNOPSIS
        If the admin consent workflow is enabled.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewEntraApplicationAdminConsentWorkflowEnabled;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name;

        # Get admin consent setting.
        $adminConsentSetting = Get-EntraIdApplicationDirectorySetting;

        # Boolean if enabled.
        $enabled = $false;
    }
    PROCESS
    {
        # If the admin consent workflow is enabled.
        if ($adminConsentSetting.EnableAdminConsentRequests -eq $true)
        {
            # Set enabled to true.
            $enabled = $true;
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $enabled)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '7bd57849-e98c-48c0-bd98-5c337fb7bc32';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Identity';
        $review.Title = 'Ensure the admin consent workflow is enabled';
        $review.Data = [PSCustomObject]@{
            Enabled = $enabled;
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