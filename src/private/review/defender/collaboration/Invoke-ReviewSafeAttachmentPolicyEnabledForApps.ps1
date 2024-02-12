function Invoke-ReviewSafeAttachmentPolicyEnabledForApps
{
    <#
    .SYNOPSIS
        Review the Safe Attachment Policy is enabled for Microsoft Teams, SharePoint and OneDrive.
    .DESCRIPTION
        Check if safe attachment global settings is enabled and configured.
    .EXAMPLE
        Invoke-ReviewSafeAttachmentPolicyEnabledForApps;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Defender' -Message 'Getting safe attachment global settings' -Level debug;

        # Get safe attachment global settings.
        $atpPolicyForO365 = Get-AtpPolicyForO365;
    }
    PROCESS
    {
        # Boolean if configured correctly.
        $configuredCorrect = $true;

        # If enabled for Microsoft Teams, SharePoint and OneDrive.
        if ($atpPolicyForO365.EnableATPForSPOTeamsODB -eq $false)
        {
            # Set the boolean to false.
            $configuredCorrect = $false;
        }

        # If safe docs is not enabled.
        if ($atpPolicyForO365.EnableSafeDocs -eq $false)
        {
            # Set the boolean to false.
            $configuredCorrect = $false;
        }

        # If docs are allowed to open.
        if ($atpPolicyForO365.AllowSafeDocsOpen -eq $true)
        {
            # Set the boolean to false.
            $configuredCorrect = $false;
        }

        # Create object.
        $settings = [PSCustomObject]@{
            ConfiguredCorrect = $configuredCorrect;
            EnableATPForSPOTeamsODB = $atpPolicyForO365.EnableATPForSPOTeamsODB;
            EnableSafeDocs = $atpPolicyForO365.EnableSafeDocs;
            AllowSafeDocsOpen = $atpPolicyForO365.AllowSafeDocsOpen;
        };
    }
    END
    {
        # Return object.
        return $settings;
    }
}

