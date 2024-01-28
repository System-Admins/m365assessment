function Invoke-ReviewSafeAttachmentPolicyEnabled
{
    <#
    .SYNOPSIS
        Review the Safe Attachment Policy is enabled and is set to block.
    .DESCRIPTION
        Check if anti-malware policy is cofigured correctly (enabled and blocked).
    .EXAMPLE
        Invoke-ReviewSafeAttachmentPolicyEnabled;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Defender' -Message 'Getting safe attachment policies' -Level debug;

        # Get safe attachment policies.
        $safeAttachmentPolicies = Get-SafeAttachmentPolicy;

        # Object array to store policies.
        $policies = @();
    }
    PROCESS
    {
        # Foreach safe attachment policy.
        foreach ($safeAttachmentPolicy in $safeAttachmentPolicies)
        {
            # Boolean if safe attachment policy is correctly configured.
            $configuredCorrect = $true;

            # If safe attachment policy is enabled.
            if ($safeAttachmentPolicy.Enable -eq $false)
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # If action is not block.
            if ($safeAttachmentPolicy.Action -ne 'Block')
            {
                # Set the boolean to false.
                $configuredCorrect = $false;
            }

            # Add to object array.
            $policies += [PSCustomObject]@{
                Guid              = $safeAttachmentPolicy.Guid;
                Id                = $safeAttachmentPolicy.Id;
                Name              = $safeAttachmentPolicy.Name;
                ConfiguredCorrect = $configuredCorrect;
                Enable            = $safeAttachmentPolicy.Enable;
                Action            = $safeAttachmentPolicy.Action;
            };
        }
    }
    END
    {
        # Return the object array.
        return $policies;
    }
}