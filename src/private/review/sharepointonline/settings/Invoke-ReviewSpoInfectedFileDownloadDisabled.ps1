function Invoke-ReviewSpoInfectedFileDownloadDisabled
{
    <#
    .SYNOPSIS
        Review if Office 365 SharePoint infected files are disallowed for download.
    .DESCRIPTION
        Return true if enabled, otherwise false.
    .EXAMPLE
        Invoke-ReviewSpoInfectedFileDownloadDisabled;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        
    }
    PROCESS
    {
        # Get tenant settings.
        $tenantSettings = Invoke-PnPSPRestMethod -Method Get -Url '/_api/SPOInternalUseOnly.Tenant';
    }
    END
    {
        # Return object.
        return [bool]$tenantSettings.DisallowInfectedFileDownload;
    } 
}