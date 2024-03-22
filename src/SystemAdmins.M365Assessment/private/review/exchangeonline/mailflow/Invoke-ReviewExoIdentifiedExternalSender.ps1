function Invoke-ReviewExoIdentifiedExternalSender
{
    <#
    .SYNOPSIS
        Check if email from external senders is identified.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewExoIdentifiedExternalSender;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Exchange Online' -Subcategory 'Mail Flow' -Message 'Getting identify external sender settings' -Level Debug;

        # Get configuration of external sender identification.
        $externalsInOutlook = Get-ExternalInOutlook;
    }
    PROCESS
    {
        # Get where not enabled.
        $externalsInOutlookNotEnabled = $externalsInOutlook | Where-Object { $_.Enabled -eq $false };
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($externalsInOutlookNotEnabled.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'a73f7dd0-6c32-44d1-ae18-197b775e28bb';
        $review.Category = 'Microsoft Exchange Admin Center';
        $review.Subcategory = 'Mail Flow';
        $review.Title = "Ensure email from external senders is identified";
        $review.Data = $externalsInOutlookNotEnabled;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}