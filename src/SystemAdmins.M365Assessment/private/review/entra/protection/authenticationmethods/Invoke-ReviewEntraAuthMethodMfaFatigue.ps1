function Invoke-ReviewEntraAuthMethodMfaFatigue
{
    <#
    .SYNOPSIS
        If Microsoft Authenticator is configured to protect against MFA fatigue.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Identity.SignIns
    .EXAMPLE
        Invoke-ReviewEntraAuthMethodMfaFatigue;
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
        Write-CustomLog -Category 'Entra' -Subcategory 'Authentication Methods' -Message ('Getting authentication methods') -Level Verbose;

        # Get authentication method policy.
        $authenticationMethodPolicy = Get-MgPolicyAuthenticationMethodPolicy;

        # Valid configuration.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # Foreach authentication method configuration.
        foreach ($authenticationMethodConfiguration in $authenticationMethodPolicy.AuthenticationMethodConfigurations)
        {
            # Skip if not "MicrosoftAuthenticator".
            if ($authenticationMethodConfiguration.id -ne 'MicrosoftAuthenticator')
            {
                # Skip to next item.
                continue;
            }

            # If state is disabled.
            if ($authenticationMethodConfiguration.state -eq 'disabled')
            {
                # Write to log.
                Write-CustomLog -Category 'Entra' -Subcategory 'Authentication Methods' -Message 'Microsoft Authenticator authentication method is disabled' -Level Verbose;

                # Skip to next item.
                continue;
            }

            # Get feature settings for "Show application name in push and passwordless notifications".
            $displayAppInformationRequiredState = $authenticationMethodConfiguration.AdditionalProperties.featureSettings.displayAppInformationRequiredState;

            # If display app information required state is "disabled".
            if ($displayAppInformationRequiredState.state -eq 'disabled')
            {
                # Write to log.
                Write-CustomLog -Category 'Entra' -Subcategory 'Authentication Methods' -Message 'Show application name in push and passwordless notifications, is not enabled' -Level Verbose;

                # Skip to next item.
                continue;
            }

            # If display app information required state is not deployed to all users.
            if (($displayAppInformationRequiredState.includeTarget).Values -notcontains 'all_users')
            {
                # Write to log.
                Write-CustomLog -Category 'Entra' -Subcategory 'Authentication Methods' -Message 'Show application name in push and passwordless notifications, is not deployed to all users' -Level Verbose;

                # Skip to next item.
                continue;
            }

            # Get feature settings for "Show geographic location in push and passwordless notifications".
            $displayLocationInformationRequiredState = $authenticationMethodConfiguration.AdditionalProperties.featureSettings.displayLocationInformationRequiredState;

            # If display location app information required state is "disabled".
            if ($displayLocationInformationRequiredState.state -eq 'disabled')
            {
                # Write to log.
                Write-CustomLog -Category 'Entra' -Subcategory 'Authentication Methods' -Message 'Show geographic location in push and passwordless notifications, is not enabled' -Level Verbose;

                # Skip to next item.
                continue;
            }

            # If display location app information required state is not deployed to all users.
            if (($displayLocationInformationRequiredState.includeTarget).Values -notcontains 'all_users')
            {
                # Write to log.
                Write-CustomLog -Category 'Entra' -Subcategory 'Authentication Methods' -Message 'Show geographic location in push and passwordless notifications, is not deployed to all users' -Level Verbose;

                # Skip to next item.
                continue;
            }

            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'Authentication Methods' -Message ("The authentication method policy '{0}' is valid" -f $authenticationMethodConfiguration.Id) -Level Verbose;

            # Set valid configuration.
            $valid = $true;
        }

        # Get Microsoft Authenticator authentication method.
        $microsoftAuthenticatorAuthMethod = ($authenticationMethodPolicy.AuthenticationMethodConfigurations | Where-Object { $_.Id -eq 'MicrosoftAuthenticator' });
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
        $review.Id = '0c1ccf40-64f3-4300-96e4-2f7f3272bf9a';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Protection';
        $review.Title = 'Ensure Microsoft Authenticator is configured to protect against MFA fatigue';
        $review.Data = [PSCustomObject]@{
            id              = $microsoftAuthenticatorAuthMethod.Id;
            state           = $microsoftAuthenticatorAuthMethod.State;
            displayApp      = $microsoftAuthenticatorAuthMethod.AdditionalProperties.featureSettings.displayAppInformationRequiredState.state;
            displayLocation = $microsoftAuthenticatorAuthMethod.AdditionalProperties.featureSettings.displayLocationInformationRequiredState.state;
        };
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}