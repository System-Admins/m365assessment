function Invoke-ReviewExoAuditEnabled
{
    <#
    .SYNOPSIS
        Check if 'AuditDisabled' organizationally is set to 'False'.
    .DESCRIPTION
        Return true if enabled otherwise false.
    .EXAMPLE
        Invoke-ReviewExoAuditEnabled;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get organization config.
        $organizationConfig = Get-OrganizationConfig;

        # Boolean if enabled.
        [bool]$enabled = $false;
    }
    PROCESS
    {
        # If 'AuditDisabled' is set to 'False'.
        if ($organizationConfig.AuditDisabled -eq $false)
        {
            # Set to true.
            $enabled = $true;
        }
    }
    END
    {
        # Return state.
        return $enabled;
    }
}