function Invoke-ReviewOneDriveSharingCapability
{
    <#
    .SYNOPSIS
        Review if external content sharing is restricted for OneDrive.
    .DESCRIPTION
        Return true if enabled otherwise false.
    .EXAMPLE
        Invoke-ReviewOneDriveSharingCapability;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get SharePoint URLs.
        $spoUrls = Get-SpoTenantUrl;

        # Get tenant settings.
        $tenantSettings = Get-PnPTenantSite -Identity $spoUrls.OneDrive;

        # External sharing bool.
        [bool]$isExternalSharingValid = $false;
    }
    PROCESS
    {
        # If the external sharing is restricted.
        if ($tenantSettings.SharingCapability -eq 'Disabled')
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