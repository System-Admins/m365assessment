function Invoke-ReviewInformationProtectionLabelPolicy
{
    <#
    .SYNOPSIS
        Check if SharePoint Online Information Protection policies are set up and used.
    .DESCRIPTION
        Return list of policies in use.
    .EXAMPLE
        Invoke-ReviewInformationProtectionLabelPolicy;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get all label policies.
        $labelPolicies = Get-LabelPolicy;

        # Object array for storing policies.
        $policies = New-Object System.Collections.ArrayList;
    }
    PROCESS
    {
        # Foreach label policy.
        foreach ($labelPolicy in $labelPolicies)
        {
            # Boolean if the label policy valid.
            $isValid = $true;

            # If the label policy is not enabled.
            if($false -eq $labelPolicy.Enabled)
            {
                # Set the policy to invalid.
                $isValid = $false;
            }

            # If mode is not set to enforce.
            if('Enforce' -ne $labelPolicy.Mode)
            {
                # Set the policy to invalid.
                $isValid = $false;
            }

            # If label policy is valid.
            if($true -eq $isValid)
            {
                # Add the policy to the list.
                $policies.Add($labelPolicy) | Out-Null;
            }
        }
    }
    END
    {
        # Return policies.
        return $policies;
    }
}