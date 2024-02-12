function Invoke-ReviewSpoGuestResharingRestricted
{
    <#
    .SYNOPSIS
        Review if that SharePoint guest users cannot share items they don't own.
    .DESCRIPTION
        Return true if restricted, otherwise false.
    .EXAMPLE
        Invoke-ReviewSpoGuestResharingRestricted;
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
        # Get tenant settings.
        $tenantSettings = Get-PnPTenant;
    }
    END
    {
        # Return bool.
        return [bool]$tenantSettings.PreventExternalUsersFromResharing;
    } 
}