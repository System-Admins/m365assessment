function Invoke-ReviewExoMailTip
{
    <#
    .SYNOPSIS
        Review mail tips settings.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewExoMailTip;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # Write to log.
        Write-CustomLog -Category 'Exchange Online' -Subcategory 'Settings' -Message 'Getting organization configuration' -Level Verbose;

        # Get all organization settings.
        $organizationSettings = Get-OrganizationConfig;

        # Bool for mail tips settings.
        [bool]$valid = $true;
    }
    PROCESS
    {
        # If mail tips is disabled.
        if ($organizationSettings.MailTipsAllTipsEnabled -eq $false)
        {
            # Set bool to false.
            $valid = $false;
        }

        # If external recipient mail tips is disabled.
        if ($organizationSettings.MailTipsExternalRecipientsTipsEnabled -eq $false)
        {
            # Set bool to false.
            $valid = $false;
        }

        # If group metrics mail tips is disabled.
        if ($organizationSettings.MailTipsGroupMetricsEnabled -eq $false)
        {
            # Set bool to false.
            $valid = $false;
        }

        # If audience mail tips threshold is not acceptable.
        if ($organizationSettings.MailTipsLargeAudienceThreshold -gt 25)
        {
            # Set bool to false.
            $valid = $false;
        }

        # If not valid.
        if ($valid -eq $false)
        {
            # Write to log.
            Write-CustomLog -Category 'Exchange Online' -Subcategory 'Settings' -Message 'Mail tips settings are not valid' -Level Verbose;
        }

        # Create object.
        $settings = [PSCustomObject]@{
            Valid = $valid;
            MailTipsAllTipsEnabled = $organizationSettings.MailTipsAllTipsEnabled;
            MailTipsExternalRecipientsTipsEnabled = $organizationSettings.MailTipsExternalRecipientsTipsEnabled;
            MailTipsGroupMetricsEnabled = $organizationSettings.MailTipsGroupMetricsEnabled;
            MailTipsLargeAudienceThreshold = $organizationSettings.MailTipsLargeAudienceThreshold;
        };
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $settings.Valid)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'bed51aa7-e6de-4542-96fc-ffe9d699763c';
        $review.Category = 'Microsoft Exchange Admin Center';
        $review.Subcategory = 'Settings';
        $review.Title = "Ensure MailTips are enabled for end users";
        $review.Data = $settings;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        #Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}