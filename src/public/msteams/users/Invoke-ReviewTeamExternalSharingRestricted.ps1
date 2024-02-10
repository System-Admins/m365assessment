function Invoke-ReviewTeamExternalSharingRestricted
{
    <#
    .SYNOPSIS
        Review 'external access' is restricted in the Teams admin center.
    .DESCRIPTION
        Return object with valid flag and settings.
    .EXAMPLE
        Invoke-ReviewTeamExternalSharingRestricted;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # Get tenant federation configuraiton.
        $tenantFederationConfig = Get-CsTenantFederationConfiguration;

        # Valid flag.
        [bool]$valid = $false;
    }
    PROCESS
    {
        # If external access is restricted.
        if ($tenantFederationConfig.AllowTeamsConsumer -eq $false -and
            $tenantFederationConfig.AllowPublicUsers -eq $false -and
            $tenantFederationConfig.AllowFederatedUsers -eq $false)
        {
            # Set valid flag to true.
            $valid = $true;
        }
        # Another option.
        elseif ($tenantFederationConfig.AllowFederatedUsers -eq $true -and
            $tenantFederationConfig.AllowedDomains -notlike 'AllowAllKnownDomains')
        {
            # Set valid flag to true.
            $valid = $true;
        }

        # Create object.
        $settings = [PSCustomObject]@{
            Valid = $valid;
            AllowTeamsConsumer = $tenantFederationConfig.AllowTeamsConsumer;
            AllowPublicUsers = $tenantFederationConfig.AllowPublicUsers;
            AllowFederatedUsers = $tenantFederationConfig.AllowFederatedUsers;
            AllowedDomains = $tenantFederationConfig.AllowedDomains;
        };
    }
    END
    {
        # Return object.
        return $settings;
    } 
}