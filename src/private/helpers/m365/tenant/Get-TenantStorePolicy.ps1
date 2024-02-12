function Get-TenantStorePolicy
{
    <#
    .SYNOPSIS
        Get the user owned apps and services settings from the organization.
    .DESCRIPTION
        Uses the Office 365 Management API.
    .EXAMPLE
        Get-TenantStorePolicy;
    #>
    [CmdletBinding()]
    Param
    (
    )
    BEGIN
    {
        # URL to "Let users access the Office store" setting.
        [string]$storeUri = 'https://admin.microsoft.com/admin/api/settings/apps/store';

        # URL to "Let users start trials on behalf of your organization" setting.
        [string]$iwPurchaseAllowedUri = 'https://admin.microsoft.com/admin/api/storesettings/iwpurchaseallowed';
        #[string]$iwPurchaseFeatureEnabledUri = 'https://admin.microsoft.com/admin/api/storesettings/iwpurchasefeatureenabled';

        # URL to "Let users auto-claim licenses the first time they sign in" setting.
        [string]$autoclaimUri = 'https://admin.microsoft.com/fd/m365licensing/v1/policies/autoclaim'

        # Variable to store the settings.
        $accessOfficeStore = $false;
        $startTrial = $false;
        $autoClaimLicense = $false;
    }
    PROCESS
    {
        # Setting - Let users access the Office store.
        $accessOfficeStore = Invoke-Office365ManagementApi -Uri $storeUri -Method 'GET';

        # Setting - Let users start trials on behalf of your organization.
        $startTrial = Invoke-Office365ManagementApi -Uri $iwPurchaseAllowedUri -Method 'GET';

        # Setting - Let users auto-claim licenses the first time they sign in.
        $autoclaim = Invoke-Office365ManagementApi -Uri $autoclaimUri -Method 'GET';

        # If autoclaim is enabled.
        if ($autoclaim.tenantPolicyValue -eq 'Enabled')
        {
            # Set the value to false.
            $autoClaimLicense = $true;
        }

        # Create a custom object.
        $response = [PSCustomObject]@{
            accessOfficeStore = $accessOfficeStore;
            startTrial = $startTrial;
            autoClaimLicense = $autoClaimLicense;
        };
    }
    END
    {
        # Return the settings.
        return $response;
    }
}