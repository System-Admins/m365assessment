function Invoke-ReviewDefenderPriorityAccountProtectionConfig
{
    <#
    .SYNOPSIS
        Review that priority account protection is enabled and configured.
    .DESCRIPTION
        Returns review object.
    .NOTES
        Requires the following modules:
        - ExchangeOnlineManagement
    .EXAMPLE
        Invoke-ReviewDefenderPriorityAccountProtectionConfig;
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
        Write-CustomLog -Category 'Microsoft Defender' -Subcategory 'Settings' -Message 'Getting email tenant settings' -Level Verbose;

        # Get the current email tenant settings.
        $emailTenantSettings = Get-EmailTenantSettings;

        # Get all priority users.
        $allUsers = Get-EntraIdUserPriority;

        # Get all alert policies.
        $protectionAlertPolicies = Get-ProtectionAlert;

        # Boolean to track if the tenant is configured for priority account protection.
        [bool]$validConfig = $false;
        [bool]$validAllUsers = $false;
        [bool]$validPolicy = $false;
    }
    PROCESS
    {
        # If protection setting is disabled.
        if ($true -eq $emailTenantSettings.EnablePriorityAccountProtection)
        {
            # Set valid config to false.
            $validConfig = $true;
        }

        # If is no user protected.
        if ($null -ne $allUsers)
        {
            # Set valid config to false.
            $validAllUsers = $true;
        }

        # Foreach protection alert policy.
        foreach ($protectionAlertPolicy in $protectionAlertPolicies)
        {
            # Booleans for settings.
            [bool]$validFilter = $false;
            [bool]$validThreatType = $false;
            [bool]$validRecipientTags = $false;
            [bool]$validMode = $false;
            [bool]$validDisabled = $false;

            # If the filter include "inbound" and "priority account".
            if ($protectionAlertPolicy.Filter -like "*(Mail.Direction -eq 'Inbound')*" -and $protectionAlertPolicy.Filter -like "*(Mail.Recipients.Tags -like 'Priority account')*")
            {
                # Set valid filter to true.
                $validFilter = $true;
            }

            # If threat type is malware.
            if ($protectionAlertPolicy.ThreatType -eq 'Malware')
            {
                # Set valid to true.
                $validThreatType = $true;
            }

            # Recipient tags is "priority account".
            if ($protectionAlertPolicy.RecipientTags -eq 'Priority account')
            {
                # Set valid to true.
                $validRecipientTags = $true;
            }

            # If mode is enforce.
            if ($protectionAlertPolicy.Mode -eq 'Enforce')
            {
                # Set valid to true.
                $validMode = $true;
            }

            # If disabled is false.
            if ($protectionAlertPolicy.Disabled -eq $false)
            {
                # Set valid to true.
                $validDisabled = $true;
            }

            # If all settings are valid.
            if ($validFilter -eq $true -and $validThreatType -eq $true -and $validRecipientTags -eq $true -and $validMode -eq $true -and $validDisabled -eq $true)
            {
                # Set valid config to true.
                $validPolicy = $true;

                # Break out of loop.
                break;
            }
        }

        # Add object.
        $settings = [PSCustomObject]@{
            'PriorityAccountProtectionEnabled'     = $validConfig;
            'PriorityAccountUsersExist'            = $validAllUsers;
            'PriorityAccountProtectionPolicyExist' = $validPolicy;
        };
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($false -eq $settings.PriorityAccountProtectionEnabled -or
            $false -eq $settings.PriorityAccountUsersExist -or
            $false -eq $settings.PriorityAccountProtectionPolicyExist)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = '749ee441-71ea-4261-86da-1f1081c65bb3';
        $review.Category = 'Microsoft 365 Defender';
        $review.Subcategory = 'Settings';
        $review.Title = 'Ensure Priority account protection is enabled and configured';
        $review.Data = $settings;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}