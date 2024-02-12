function Invoke-ReviewSpoGuestResharingRestricted
{
    <#
    .SYNOPSIS
        Review if SharePoint external sharing is managed through domain whitelist/blacklists.
    .DESCRIPTION
        Return true if restricted, otherwise false.
    .EXAMPLE
        Invoke-ReviewSpoGuestResharingRestricted;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Bool for valid setting.
        [bool]$sharingDomainValid = $false;
    }
    PROCESS
    {
        # Get tenant settings.
        $tenantSettings = Get-PnPTenant;

        # If SharingDomainRestrictionMode is set to allow list.
        if ($tenantSettings.SharingDomainRestrictionMode -eq "AllowList")
        {
            # Return true.
            $sharingDomainValid = $true;
        }
    }
    END
    {
        # Return bool.
        return $sharingDomainValid;
    } 
}