function Invoke-ReviewPriorityAccountProtectionConfig
{
    <#
    .SYNOPSIS
        Review that priority account protection is enabled and configured.
    .DESCRIPTION
        Ensure that priority account protection is enabled and one or more users are protected.
    .EXAMPLE
        Invoke-ReviewPriorityAccountProtectionConfig;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Defender' -Message 'Getting email tenant settings' -Level Debug;

        # Get the current email tenant settings.
        $emailTenantSettings = Get-EmailTenantSettings;

        # Get all alert policies.
        $protectionAlertPolicies = Get-ProtectionAlert;

        # Boolean to track if the tenant is configured for priority account protection.
        [bool]$validConfig = $false;
        [bool]$validAllUsers = $false;
        [bool]$validPolicy = $false;
    }
    PROCESS
    {
        # Try to get VIP users.
        try
        {
            # Write to log.
            Write-Log -Category 'Defender' -Message ('Getting all VIP users' -f $_) -Level Debug;

            # Get all users.
            $allUsers = Get-User -IsVIP;
        }
        catch
        {
            # Write to log.
            Write-Log -Category 'Defender' -Message ('Could not get VIP users, exception is "{0}"' -f $_) -Level Warning;
        }

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
        # Return settings.
        return $settings;
    }
}