function Invoke-ReviewEmailRestrictedSender
{
    <#
    .SYNOPSIS
        Review the users who is restricted by sending e-mail.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewEmailRestrictedSender;
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
        # Write to log.
        Write-CustomLog -Category 'Microsoft Defender' -Subcategory 'Policy' -Message 'Getting blocked sender addresses' -Level Verbose;

        # Get restricted senders.
        $restrictedSenders = Get-BlockedSenderAddress;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($restrictedSenders.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '86bab3de-8bac-442f-8495-496bd1ed75b9';
        $review.Category = 'Microsoft 365 Defender';
        $review.Subcategory = 'Email and collaboration';
        $review.Title = "Ensure the 'Restricted entities' report is reviewed weekly";
        $review.Data = $restrictedSenders;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}