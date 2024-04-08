function Invoke-ReviewEntraSsprEnabledForAll
{
    <#
    .SYNOPSIS
        If 'Self service password reset enabled' is set to 'All'.
    .DESCRIPTION
        Returns review object.
    .EXAMPLE
        Invoke-ReviewEntraSsprEnabledForAll;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # URI.
        $uri = 'https://main.iam.ad.ext.azure.com/api/PasswordReset/PasswordResetPolicies?getPasswordResetEnabledGroup=true';

        # Valid configuration.
        [bool]$valid = $true;

        # Display name for password reset policy.
        $displayName = '';
    }
    PROCESS
    {
        # Invoke Entra ID API.
        $passwordResetPolicies = Invoke-EntraIdIamApi -Uri $uri -Method Get;

        # If not set to all users.
        if ($passwordResetPolicies.enablementType -ne 2)
        {
            # Set valid configuration to false.
            $valid = $false;
        }

        # Switch on enablement type.
        switch ($passwordResetPolicies.enablementType)
        {
            # All users.
            2
            {
                # Write to log.
                Write-CustomLog -Category 'Entra' -Subcategory 'Protection' -Message ("SSPR target is set to 'All'") -Level Verbose;

                # Set display name.
                $displayName = 'All';
            }
            # None.
            0
            {
                # Write to log.
                Write-CustomLog -Category 'Entra' -Subcategory 'Protection' -Message ("SSPR target is set to 'None'") -Level Verbose;

                # Set display name.
                $displayName = 'None';
            }
            # Selected users.
            1
            {
                # Write to log.
                Write-CustomLog -Category 'Entra' -Subcategory 'Protection' -Message ("SSPR target is set to 'Selected'") -Level Verbose;

                # Set display name.
                $displayName = 'Selected';
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
        $review.Id = '2425f84f-76cf-441b-891e-86142f14ff9e';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Protection';
        $review.Title = "Ensure 'Self service password reset enabled' is set to 'All'";
        $review.Data = [PSCustomObject]@{
            EnablementType = $displayName;
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}