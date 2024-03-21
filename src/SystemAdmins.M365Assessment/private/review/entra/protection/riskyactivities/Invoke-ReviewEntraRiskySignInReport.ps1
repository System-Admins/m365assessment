function Invoke-ReviewEntraRiskySignInReport
{
    <#
    .SYNOPSIS
        Review the Azure AD 'Risky sign-ins' report.
    .DESCRIPTION
        Return risky sign in report.
    .EXAMPLE
        Invoke-ReviewEntraRiskySignInReport;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # URI.
        $uri = 'https://main.iam.ad.ext.azure.com/api/Security/RiskyUsers';

        # Body.
        $body = @{
            riskStates  = @(1, 4);
            riskLevels  = @(2, 1);
            riskDetails = New-Object System.Collections.ArrayList;
            userStatus  = @($false);
            sort        = @{
                field        = 'riskLastUpdatedDateTime';
                defaultOrder = $true;
            };
            pageSize    = 50;
        } | ConvertTo-Json;
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Protection' -Message ('Getting risky users report') -Level Debug;
        
        # Invoke Entra ID API.
        $riskyUsers = Invoke-EntraIdIamApi -Uri $uri -Body $body -Method POST;
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;
                    
        # If review flag should be set.
        if ($riskyUsers.items.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }
                                                     
        # Create new review object to return.
        [Review]$review = [Review]::new();
                                             
        # Add to object.
        $review.Id = 'ff9b1c25-464c-4c6a-a469-10aab9470e4c';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Protection';
        $review.Title = "Ensure the Azure AD 'Risky sign-ins' report is reviewed at least weekly";
        $review.Data = $riskyUsers.items;
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    }
}