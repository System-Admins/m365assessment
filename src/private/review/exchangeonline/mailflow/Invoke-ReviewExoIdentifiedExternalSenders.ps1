function Invoke-ReviewExoIdentifiedExternalSenders
{
    <#
    .SYNOPSIS
        Check if email from external senders is identified.
    .DESCRIPTION
        Return object if any rules is found that is not enabled.
    .EXAMPLE
        Invoke-ReviewExoIdentifiedExternalSenders;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get configuration of external sender identification.
        $externalsInOutlook = Get-ExternalInOutlook;
    }
    PROCESS
    {
        # Get where not enabled.
        $externalsInOutlookNotEnabled = $externalsInOutlook | Where-Object { $_.Enabled -eq $false };
    }
    END
    {
        # Return object.
        return $externalsInOutlookNotEnabled;
    } 
}