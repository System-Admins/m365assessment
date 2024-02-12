function Invoke-ReviewCustomerLockEnabled
{
    <#
    .SYNOPSIS
        Review that customer lock is enabled.
    .DESCRIPTION
        Check if "Customer lock" is enabled.
        Return true if it's enabled, otherwise false.
    .EXAMPLE
        Invoke-ReviewCustomerLockEnabled;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
    }
    PROCESS
    {
        # Get settings.
        $settings = Get-OrganizationConfig;
    }
    END
    {
        # Return value.
        return $settings.CustomerLockBoxEnabled;
    }
}