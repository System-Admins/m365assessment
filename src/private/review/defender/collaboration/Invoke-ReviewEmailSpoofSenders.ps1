function Invoke-ReviewEmailSpoofSenders
{
    <#
    .SYNOPSIS
        Review the e-mail spoofed domains.
    .DESCRIPTION
        Return e-mail spoofed domains report.
    .EXAMPLE
        Invoke-ReviewEmailDomainDmarc;
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
        
        # Get spoofed senders.
        $spoofedSenders = Get-SpoofIntelligenceInsight;
    }
    END
    {
        # Return object array.
        return $spoofedSenders;
    }
}