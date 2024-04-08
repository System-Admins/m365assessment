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
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category 'Microsoft Defender' -Subcategory 'Policy' -Message 'Getting spoofed domains report' -Level Verbose;

        # Get spoofed senders (last 7 days).
        $spoofedSenders = Get-SpoofIntelligenceInsight | Where-Object { $_.LastSeen -gt (Get-Date).AddDays(-7) };

        # If there is any spoofed senders.
        if ($spoofedSenders.Count -gt 0)
        {
            # Sort by message count.
            $spoofedSenders = $spoofedSenders | Sort-Object -Property MessageCount -Descending;
        }
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