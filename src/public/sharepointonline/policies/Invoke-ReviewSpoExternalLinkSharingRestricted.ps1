function Invoke-ReviewSpoExternalLinkSharingRestricted
{
    <#
    .SYNOPSIS
        Review if link sharing is restricted in SharePoint and OneDrive.
    .DESCRIPTION
        Return object with settings and bool if valid.
    .EXAMPLE
        Invoke-ReviewSpoExternalLinkSharingRestricted;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get SPO urls.
        $spoUrls = Get-SpoUrl;

        # Get tenant settings.
        $spoTenantSettings = Get-PnPTenant;
        $odfbTenantSettings = Get-PnPTenantSite -Identity $spoUrls.OneDrive;

        # External sharing bools.
        [bool]$externalLinkSharingValid = $false;
    }
    PROCESS
    {
        # If the external link sharing is direct.
        if ($spotenantSettings.DefaultSharingLinkType -eq 'Direct' -and
            $odfbtenantSettings.DefaultSharingLinkType -eq 'Direct')
        {
            # Setting is valid.
            $externalLinkSharingValid = $true;
        }
    }
    END
    {
        # Return object.
        return [PSCustomObject]@{
            ExternalLinkSharingValid = $externalLinkSharingValid;
            SharePointLinkSharing    = $spoTenantSettings.DefaultSharingLinkType;
            OneDriveLinkSharing      = $odfbTenantSettings.DefaultSharingLinkType;
        };
    } 
}