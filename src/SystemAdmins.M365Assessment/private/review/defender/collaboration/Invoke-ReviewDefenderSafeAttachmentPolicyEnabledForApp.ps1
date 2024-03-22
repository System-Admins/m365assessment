function Invoke-ReviewDefenderSafeAttachmentPolicyEnabledForApp
{
    <#
    .SYNOPSIS
        Review the Safe Attachment Policy is enabled for Microsoft Teams, SharePoint and OneDrive.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewDefenderSafeAttachmentPolicyEnabledForApp;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Microsoft Defender' -Subcategory 'Policy' -Message 'Getting safe attachment global settings' -Level Debug;

        # Get safe attachment global settings.
        $atpPolicyForO365 = Get-AtpPolicyForO365;
    }
    PROCESS
    {
        # Boolean if configured correctly.
        $valid = $true;

        # If enabled for Microsoft Teams, SharePoint and OneDrive.
        if ($atpPolicyForO365.EnableATPForSPOTeamsODB -eq $false -or
            $atpPolicyForO365.EnableSafeDocs -eq $false -or
            $atpPolicyForO365.AllowSafeDocsOpen -eq $true)
        {
            # Set the boolean to false.
            $valid = $false;

            # Write to log.
            Write-Log -Category 'Microsoft Defender' -Subcategory 'Policy' -Message 'Safe attachment global settings is not configured correctly' -Level Debug;
        }
        else
        {
            # Write to log.
            Write-Log -Category 'Microsoft Defender' -Subcategory 'Policy' -Message 'Safe attachment global settings is configured correctly' -Level Debug;
        }

        # Create object.
        $settings = [PSCustomObject]@{
            Valid                   = $valid;
            EnableATPForSPOTeamsODB = $atpPolicyForO365.EnableATPForSPOTeamsODB;
            EnableSafeDocs          = $atpPolicyForO365.EnableSafeDocs;
            AllowSafeDocsOpen       = $atpPolicyForO365.AllowSafeDocsOpen;
        };
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($settings | Where-Object { $_.Valid -eq $false })
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'a4fb003f-b742-4a97-8a9a-c4e5a82171a4';
        $review.Category = 'Microsoft 365 Defender';
        $review.Subcategory = 'Email and collaboration';
        $review.Title = 'Ensure Safe Attachments for SharePoint, OneDrive, and Microsoft Teams is Enabled';
        $review.Data = $settings;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}

