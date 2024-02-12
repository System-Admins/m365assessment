function Invoke-ReviewSpoSharingCapability
{
    <#
    .SYNOPSIS
        Review if external content sharing is restricted for SharePoint Online.
    .DESCRIPTION
        Return true if enabled otherwise false.
    .EXAMPLE
        Invoke-ReviewSpoSharingCapability;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get tenant settings.
        $tenantSettings = Get-PnPTenant;

        # External sharing bool.
        [bool]$isExternalSharingValid = $false;
    }
    PROCESS
    {
        # If the external sharing is restricted.
        if ($tenantSettings.SharingCapability -eq "ExternalUserSharingOnly" -and
            $tenantSettings.SharingCapability -eq "ExistingExternalUserSharingOnly" -and
            $tenantSettings.SharingCapability -eq "Disabled")
        {
            # Setting is valid.
            $isExternalSharingValid = $true;
        }
    }
    END
    {
        # Return bool.
        return [bool]$isExternalSharingValid;
    } 
}