function Invoke-ReviewTeamUsersCantSendEmailToChannel
{
    <#
    .SYNOPSIS
        Review users can't send emails to a channel email address.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - MicrosoftTeams
    .EXAMPLE
        Invoke-ReviewTeamUsersCantSendEmailToChannel;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Microsoft Teams' -Subcategory 'Teams' -Message ('Getting client configuration') -Level Debug;

        # Get Teams client configuration.
        $teamsClientConfig = Get-CsTeamsClientConfiguration -Identity Global;

        # Valid flag.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If users are allowed to send emails to a channel.
        if ($teamsClientConfig.AllowEmailIntoChannel -eq $false)
        {
            # Write to log.
            Write-Log -Category 'Microsoft Teams' -Subcategory 'Teams' -Message ('Users are not allowed to send emails to a channel') -Level Debug;

            # Set valid flag to true.
            $valid = $true;
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($false -eq $valid)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                                             
        # Create new review object to return.
        [Review]$review = [Review]::new();
                                                     
        # Add to object.
        $review.Id = '4623807d-6c30-4906-a33e-1e55fbbdfdec';
        $review.Category = 'Microsoft Teams Admin Center';
        $review.Subcategory = 'Teams';
        $review.Title = "Ensure users can't send emails to a channel email address";
        $review.Data = $teamsClientConfig.AllowEmailIntoChannel;
        $review.Review = $reviewFlag;
                                      
        # Print result.
        $review.PrintResult();
                                                     
        # Return object.
        return $review;
    } 
}