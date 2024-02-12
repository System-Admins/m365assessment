function Invoke-ReviewSpoExternalSharingRestrictedGroup
{
    <#
    .SYNOPSIS
        Review if external sharing is restricted by security group.
    .DESCRIPTION
        Return true if enabled otherwise false.
    .EXAMPLE
        Invoke-ReviewSpoExternalSharingRestrictedGroup;
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get tenant settings.
        $tenantSettings = Invoke-PnPSPRestMethod -Method Get -Url "/_api/SPOInternalUseOnly.Tenant";

        # Setting is valid.
        [bool]$externalSharingGroupValid = $false;

    }
    PROCESS
    {
        # If security group is set.
        if($null -ne $tenantSettings.WhoCanShareAllowListInTenant -and
           $null -ne $tenantSettings.WhoCanShareAllowListInTenantByPrincipalIdentity)
        {
            # Setting is valid.
            $externalSharingGroupValid = $true;
        }
    }
    END
    {
        # Return bool.
        return $externalSharingGroupValid
    } 
}