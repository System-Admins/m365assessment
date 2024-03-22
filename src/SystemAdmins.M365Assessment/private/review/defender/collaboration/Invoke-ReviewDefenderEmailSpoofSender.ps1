function Invoke-ReviewDefenderEmailSpoofSender
{
    <#
    .SYNOPSIS
        Review the e-mail spoofed domains.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewDefenderEmailSpoofSender;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {

    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'Microsoft Defender' -Subcategory 'Policy' -Message 'Getting spoofed domains report' -Level Debug;

        # Get spoofed senders.
        $spoofedSenders = Get-SpoofIntelligenceInsight;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($spoofedSenders.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'c7d90aa7-bcb3-403c-96f4-bc828e6246ff';
        $review.Category = 'Microsoft 365 Defender';
        $review.Subcategory = 'Email and collaboration';
        $review.Title = 'Ensure the spoofed domains report is reviewed weekly';
        $review.Data = $spoofedSenders;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}