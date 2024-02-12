function Invoke-ReviewExoMailTips
{
    <#
    .SYNOPSIS
        Review mail tips settings.
    .DESCRIPTION
        Return object with settings and if set correct.
    .EXAMPLE
        Invoke-ReviewExoMailTips;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get all organization settings.
        $organizationSettings = Get-OrganizationConfig;

        # Bool for mail tips settings.
        [bool]$mailTipsSettingsValid = $true;
    }
    PROCESS
    {
        # If mail tips is disabled.
        if ($organizationSettings.MailTipsAllTipsEnabled -eq $false)
        {
            # Set bool to false.
            $mailTipsSettingsValid = $false;
        }

        # If external recipient mail tips is disabled.
        if ($organizationSettings.MailTipsExternalRecipientsTipsEnabled -eq $false)
        {
            # Set bool to false.
            $mailTipsSettingsValid = $false;
        }

        # If group metrics mail tips is disabled.
        if ($organizationSettings.MailTipsGroupMetricsEnabled -eq $false)
        {
            # Set bool to false.
            $mailTipsSettingsValid = $false;
        }

        # If audience mail tips threshold is not acceptable.
        if ($organizationSettings.MailTipsLargeAudienceThreshold -gt 25)
        {
            # Set bool to false.
            $mailTipsSettingsValid = $false;
        }
    }
    END
    {
        # Return object.
        return [PSCustomObject]@{
            MailTipsSettingsValid = $mailTipsSettingsValid;
            MailTipsAllTipsEnabled = $organizationSettings.MailTipsAllTipsEnabled;
            MailTipsExternalRecipientsTipsEnabled = $organizationSettings.MailTipsExternalRecipientsTipsEnabled;
            MailTipsGroupMetricsEnabled = $organizationSettings.MailTipsGroupMetricsEnabled;
            MailTipsLargeAudienceThreshold = $organizationSettings.MailTipsLargeAudienceThreshold;
        };
    } 
}