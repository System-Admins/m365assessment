function Invoke-ReviewEntraAuthMethodCustomPasswordListEnforced
{
    <#
    .SYNOPSIS
        If custom banned passwords lists are used.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewEntraAuthMethodCustomPasswordListEnforced;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # URI.
        $uri = 'https://main.iam.ad.ext.azure.com/api/AuthenticationMethods/PasswordPolicy';
        
        # Valid configuration.
        [bool]$valid = $true;
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Authentication Methods' -Message ('Getting password policies') -Level Debug;

        # Invoke Entra ID API.
        $passwordPolicy = Invoke-EntraIdIamApi -Uri $uri -Method Get;

        # if custom passwords is not enforced.
        if ($false -eq $passwordPolicy.enforceCustomBannedPasswords)
        {
            # Set valid configuration to false.
            $valid = $false;
        }

        # If there is custom banned passwords.
        if ($null -eq $passwordPolicy.customBannedPasswords)
        {
            # Set valid configuration to false.
            $valid = $false;
        }

        # Write to log.
        Write-Log -Category 'Entra' -Subcategory 'Authentication Methods' -Message ("Policy for custom banned passwords is '{0}'" -f $passwordPolicy.enforceCustomBannedPasswords) -Level Debug;
        Write-Log -Category 'Entra' -Subcategory 'Authentication Methods' -Message ('Found {0} passwords that is banned' -f $passwordPolicy.customBannedPasswords.Count) -Level Debug;
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
        $review.Id = 'bb23f25a-0c03-4607-a232-ef8902a0a899';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Protection';
        $review.Title = 'Ensure custom banned passwords lists are used';
        $review.Data = [PSCustomObject]@{
            Enabled   = $passwordPolicy.enforceCustomBannedPasswords;
            Passwords = $passwordPolicy.customBannedPasswords;
        };
        $review.Review = $reviewFlag;
                              
        # Print result.
        $review.PrintResult();
                                             
        # Return object.
        return $review;
    }
}