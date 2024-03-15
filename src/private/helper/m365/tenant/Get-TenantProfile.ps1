function Get-TenantProfile
{
    <#
    .SYNOPSIS
        Get Microsoft 365 organization profile such as company info.
    .DESCRIPTION
        Uses the Microsoft Admin API.
    .EXAMPLE
        Get-TenantProfile;
    #>
    [cmdletbinding()]
    param
    (
    )
    BEGIN
    {
        # URL.
        [string]$Uri = 'https://admin.microsoft.com/admin/api/Settings/company/profile';
    }
    PROCESS
    {
        # Write to log.
        Write-Log -Category "Tenant" -Subcategory "Profile" -Message ("Getting Microsoft 365 tenant profile") -Level Debug;

        # Get company profile.
        $companyProfile = Invoke-MsAdminApi -Uri $Uri;
    }
    END
    {
        # Return the company profile.
        return $companyProfile;
    }
}