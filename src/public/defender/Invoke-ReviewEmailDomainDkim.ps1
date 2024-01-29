function Invoke-ReviewEmailDomainDkim
{
    <#
    .SYNOPSIS
        Review that all e-mail domains have DKIM configured.
    .DESCRIPTION
        Check if all e-mail domains have a valid signing configuration.
    .EXAMPLE
        Invoke-ReviewEmailDomainDkim;
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
        # Write to log.
        Write-Log -Category 'Defender' -Message 'Getting all DKIM configuration' -Level Debug;

        # Get all DKIM configuration.
        $dimSigningConfig = Get-DkimSigningConfig;
    }
    END
    {
        # Return config.
        return $dimSigningConfig;
    }
}