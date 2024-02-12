function Invoke-ReviewTeamApprovedCloudStorage
{
    <#
    .SYNOPSIS
        Review external file sharing in Teams is enabled for only approved cloud storage services.
    .DESCRIPTION
        Return object with approved cloud storage services, also contain if all is disabled (valid flag).
    .EXAMPLE
        Invoke-ReviewTeamApprovedCloudStorage;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get Teams client configuration.
        $teamsClientConfig = Get-CsTeamsClientConfiguration;

        # Bool external cloud providers valid setting.
        [bool]$authorizedCloudProvidersValid = $false;
    }
    PROCESS
    {
        # Check if any of the approved cloud storage services are enabled.
        if ($teamsClientConfig.AllowDropbox -eq $false -and
            $teamsClientConfig.AllowBox -eq $false -and
            $teamsClientConfig.AllowGoogleDrive -eq $false -and
            $teamsClientConfig.AllowShareFile -eq $false -and
            $teamsClientConfig.AllowEgnyte -eq $false)
        {
            # Set bool to false.
            $authorizedCloudProvidersValid = $true;
        }

        # Get list of approved cloud storage services.
        $authorizedCloudProviders = [PSCustomObject]@{
            Valid       = $authorizedCloudProvidersValid;
            Dropbox     = $teamsClientConfig.AllowDropbox;
            Box         = $teamsClientConfig.AllowBox;
            GoogleDrive = $teamsClientConfig.AllowGoogleDrive;
            ShareFile   = $teamsClientConfig.AllowShareFile;
            Egnyte      = $teamsClientConfig.AllowEgnyte;
        };
    }
    END
    {
        # Return list of approved cloud storage services.
        return $authorizedCloudProviders;
    } 
}