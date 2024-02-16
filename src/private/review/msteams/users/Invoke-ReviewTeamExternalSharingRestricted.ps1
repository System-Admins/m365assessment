function Invoke-ReviewTeamExternalSharingRestricted
{
    <#
    .SYNOPSIS
        Review 'external access' is restricted in the Teams admin center.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - MicrosoftTeams
    .EXAMPLE
        Invoke-ReviewTeamExternalSharingRestricted;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Microsoft Teams' -Subcategory 'Users' -Message ('Getting federation configuration') -Level Debug;

        # Get tenant federation configuraiton.
        $tenantFederationConfig = Get-CsTenantFederationConfiguration;

        # Valid flag.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If external access is restricted.
        if ($tenantFederationConfig.AllowTeamsConsumer -eq $false -and
            $tenantFederationConfig.AllowPublicUsers -eq $false -and
            $tenantFederationConfig.AllowFederatedUsers -eq $false)
        {
            # Set valid flag to true.
            $valid = $true;
        }
        # Another option.
        elseif ($tenantFederationConfig.AllowFederatedUsers -eq $true -and
            $tenantFederationConfig.AllowedDomains -notlike 'AllowAllKnownDomains')
        {
            # Set valid flag to true.
            $valid = $true;
        }

        # If valid.
        if ($valid)
        {
            # Write to log.
            Write-Log -Category 'Microsoft Teams' -Subcategory 'Users' -Message ('External access is restricted') -Level Debug;
        }
        # Else not valid.
        else
        {
            # Write to log.
            Write-Log -Category 'Microsoft Teams' -Subcategory 'Users' -Message ('External access is not restricted') -Level Debug;
        }

        # Create object.
        $settings = [PSCustomObject]@{
            AllowTeamsConsumer  = $tenantFederationConfig.AllowTeamsConsumer;
            AllowPublicUsers    = $tenantFederationConfig.AllowPublicUsers;
            AllowFederatedUsers = $tenantFederationConfig.AllowFederatedUsers;
            AllowedDomains      = $tenantFederationConfig.AllowedDomains;
        };
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
        $review.Id = '1d4902a0-dcb6-4b1a-b77a-0662ba15a431';
        $review.Category = 'Microsoft Teams Admin Center';
        $review.Subcategory = 'Users';
        $review.Title = "Ensure 'external access' is restricted in the Teams admin center";
        $review.Data = $settings;
        $review.Review = $reviewFlag;
                                      
        # Print result.
        $review.PrintResult();
                                                     
        # Return object.
        return $review;
    } 
}