function get-report
{
    # Install modules.
    #Install-Modules;

    # Disconnect from Microsoft.
    #Disconnect-Tenant

    # Connect to Microsoft.
    #Connect-Tenant;

    # Get reviews.
    $reviews = Invoke-Review;

    # Get HTML report.
    $htmlPath = Get-HtmlReport;
}