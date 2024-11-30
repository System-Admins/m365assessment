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
    }
    PROCESS
    {
        # Write to log.
        Write-CustomLog -Category "Tenant" -Subcategory "Profile" -Message ("Getting Microsoft 365 tenant profile") -Level Verbose;

        # Get company profile.
        $companyProfile = (Get-AzTenant).ExtendedProperties;
    }
    END
    {
        # Return the company profile.
        return $companyProfile;
    }
}