function Invoke-ReviewMicrosoftFormInternalPhishingScanEnabled
{
    <#
    .SYNOPSIS
        Review that internal phishing protection for Microsoft Forms is enabled.
    .DESCRIPTION
        Check if "Add internal phishing protection" is enabled.
        Uses Office 365 Management API to get the settings.
        Return true if it's enabled, otherwise false.
    .EXAMPLE
        Invoke-ReviewMicrosoftFormInternalPhishingScanEnabled;
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
        # Get Microsoft Forms organization settings.
        $settings = Get-TenantOfficeFormSetting;
    }
    END
    {
        # Return value.
        return $settings.InOrgFormsPhishingScanEnabled;
    }
}