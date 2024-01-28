function Invoke-ReviewUserOwnedAppsServiceRestricted
{
    <#
    .SYNOPSIS
        Review 'User owned apps and services' is restricted
    .DESCRIPTION
        Check if "Let users access the Office store" and "Let users start trials on behalf of your organization" is disabled.
        Uses Office 365 Management API to get the settings.
        Return true if it's restricted, otherwise false
    .EXAMPLE
        Invoke-ReviewUserOwnedAppsServiceRestricted;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get User owned apps and services settings.
        $settings = Get-OrganizationUserOwnedAppsServicesSettings;

        # Boolean to check restrictions.
        [bool]$restricted = $false;
    }
    PROCESS
    {
        # If the settings are null.
        if ($null -eq $settings)
        {
            # Throw execption.
            Write-Log -Category "Organization" -Message ("Something went wrong getting user owned apps and services settings, execption is '{0}'" -f $_) -Level 'Error';
        }

        # If "Let users access the Office store" and "Let users start trials on behalf of your organization" is disabled.
        if ($settings.accessOfficeStore -eq $false -and $settings.startTrial -eq $false)
        {
            # Set restricted to true.
            $restricted = $true;
        }
    }
    END
    {
        # Return value of restrictions.
        return $restricted;
    }
}