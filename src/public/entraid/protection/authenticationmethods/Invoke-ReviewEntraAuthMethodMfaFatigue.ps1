function Invoke-ReviewEntraAuthMethodMfaFatigue
{
    <#
    .SYNOPSIS
        If Microsoft Authenticator is configured to protect against MFA fatigue.
    .DESCRIPTION
        Return true if enabled, otherwise false.
    .EXAMPLE
        Invoke-ReviewEntraAuthMethodMfaFatigue;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get authentication method policy.
        $authenticationMethodPolicy = Get-MgPolicyAuthenticationMethodPolicy;
        
        # Valid configuration.
        [bool]$validConfiguration = $false;
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
                Write-Log -Message 'Microsoft Authenticator authentication method is disabled' -Level Debug;

                # Skip to next item.
                continue;
            }

            # Microsoft Authenticator.
            $microsoftAuthenticator = $authenticationMethodConfiguration;

            # Get feature settings for "Show application name in push and passwordless notifications".
            $displayAppInformationRequiredState = $microsoftAuthenticator.AdditionalProperties.featureSettings.displayAppInformationRequiredState;
            

            # If display app information required state is "disabled".
            if ($displayAppInformationRequiredState.state -eq 'disabled')
            {
                # Write to log.
                Write-Log -Message 'Show application name in push and passwordless notifications, is not enabled' -Level Debug;

                # Skip to next item.
                continue;
            }

            # If display app information required state is not deployed to all users.
            if (($displayAppInformationRequiredState.includeTarget).Values -notcontains 'all_users')
            {
                # Write to log.
                Write-Log -Message 'Show application name in push and passwordless notifications, is not deployed to all users' -Level Debug;

                # Skip to next item.
                continue;
            }

            # Get feature settings for "Show geographic location in push and passwordless notifications".
            $displayLocationInformationRequiredState = $microsoftAuthenticator.AdditionalProperties.featureSettings.displayLocationInformationRequiredState;

            # If display location app information required state is "disabled".
            if ($displayLocationInformationRequiredState.state -eq 'disabled')
            {
                # Write to log.
                Write-Log -Message 'Show geographic location in push and passwordless notifications, is not enabled' -Level Debug;

                # Skip to next item.
                continue;
            }

            # If display location app information required state is not deployed to all users.
            if (($displayLocationInformationRequiredState.includeTarget).Values -notcontains 'all_users')
            {
                # Write to log.
                Write-Log -Message 'Show geographic location in push and passwordless notifications, is not deployed to all users' -Level Debug;

                # Skip to next item.
                continue;
            }

            # Set valid configuration.
            $validConfiguration = $true;
        }
    }
    END
    {
        # Return state of valid configuration.
        return $validConfiguration;
    }
}