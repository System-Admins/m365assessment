function Invoke-ReviewExoStorageProvidersRestricted
{
    <#
    .SYNOPSIS
        Review additional storage providers are restricted in Outlook on the web.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewExoStorageProvidersRestricted;
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
        Write-CustomLog -Category 'Exchange Online' -Subcategory 'Settings' -Message 'Getting OWA policies' -Level Verbose;

        # Get OWA policies.
        $owaPolicies = Get-OwaMailboxPolicy;

        # List of OWA policies with additional storage providers not restricted.
        $owaPoliciesNotRestricted = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach OWA policy.
        foreach ($owaPolicy in $owaPolicies)
        {
            # If additional storage providers are not restricted.
            if ($owaPolicy.AdditionalStorageProvidersAvailable -eq $true)
            {
                # Write to log.
                Write-CustomLog -Category 'Exchange Online' -Subcategory 'Settings' -Message ("OWA policy '{0}' allows additional storage providers" -f $owaPolicy.Name) -Level Verbose;

                # Add OWA policy to list.
                $null = $owaPoliciesNotRestricted.Add($owaPolicy);
            }
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($owaPoliciesNotRestricted.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'd576ebed-fe29-44a7-9fdf-bb8b3c484894';
        $review.Category = 'Microsoft Exchange Admin Center';
        $review.Subcategory = 'Settings';
        $review.Title = "Ensure additional storage providers are restricted in Outlook on the web";
        $review.Data = $owaPolicies | Select-Object -Property Name, AdditionalStorageProvidersAvailable;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Write progress.
        #Write-Progress -Activity $MyInvocation.MyCommand -Status 'Completed' -CurrentOperation $MyInvocation.MyCommand.Name -Completed;

        # Return object.
        return $review;
    }
}