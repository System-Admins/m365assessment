function get-report
{
    # Install modules.
    Install-Modules;

    # Connect to Microsoft.
    Connect-Tenant;

    # Get reviews.
    $reviews = Invoke-Review;

    # Get report.
    $reviewsHtml = Get-ReportHtml -Reviews $reviews;

    # Return html.
    return $reviewsHtml;
}