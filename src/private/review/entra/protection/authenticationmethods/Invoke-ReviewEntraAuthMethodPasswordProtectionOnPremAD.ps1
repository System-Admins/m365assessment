function Invoke-ReviewEntraAuthMethodPasswordProtectionOnPremAD
{
    <#
    .SYNOPSIS
        If password protection is enabled for on-prem Active Directory.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewEntraAuthMethodPasswordProtectionOnPremAD;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get the hybrid AD connect status.
        $adConnectStatus = Get-EntraIdHybridAdConnectStatus;

        # URI.
        $uri = 'https://main.iam.ad.ext.azure.com/api/AuthenticationMethods/PasswordPolicy';
        
        # Valid configuration.
        [bool]$valid = $true;
    }
    PROCESS
    {
        # Invoke Entra ID API.
        $passwordPolicy = Invoke-EntraIdIamApi -Uri $uri -Method Get;

        # If the hybrid AD connect status is connected.
        if ($adConnectStatus.dirSyncEnabled -eq $true)
        {
            # If password protection is not enforced on premises.
            if ($false -eq $passwordPolicy.enableBannedPasswordCheckOnPremises)
            {
                # Set valid configuration to false.
                $valid = $false;

                # Write to log.
                Write-Log -Category 'Entra' -Subcategory 'Protection' -Message 'Password protection is not enforced on premises' -Level Debug;
            }
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
        $review.Id = 'ee6975f8-842f-4096-a8a7-0ad093db82c0';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Protection';
        $review.Title = 'Ensure password protection is enabled for on-prem Active Directory';
        $review.Data = [PSCustomObject]@{
            HybridStatus = $adConnectStatus;
            PasswordPolicy = $passwordPolicy;
        };
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    }
}