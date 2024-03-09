function Get-ReportHtml
{
    <#
    .SYNOPSIS
        Get the HTML for the review.
    .DESCRIPTION
        Returns HTML code.
    .PARAMETER Review
        Review(s) to get the HTML for.
    .PARAMETER Path
        Path to the documentation templates.
    .EXAMPLE
        # Get report HTML.
        Get-ReportHtml -Reviews $reviews -Path 'documentation/review';
    #>

    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [Review[]]$Reviews,
        [Parameter(Mandatory = $false)]
        [string]$Path = ('{0}/private/template/markdown' -f $Script:scriptPath)
    )

    BEGIN
    {
        # Get all templates.
        $reviewTemplates = Get-ChildItem -Path $Path -Recurse -File -Filter '*.md';

        # HTML content.
        [string]$htmlContent = '';
    }
    PROCESS
    {
        # Foreach review.
        foreach ($review in $Reviews)
        {
            # Review template filename.
            $templateName = ('{0}.md' -f $review.Id);

            # Get the review template.
            $template = $reviewTemplates | Where-Object { $_.Name -eq $templateName };

            # Get the HTML content.
            $htmlContent += Get-ReportReviewHtml -Path $template.FullName -Review $review;
        }
    }
    END
    {
        # Return the HTML content.
        return $htmlContent;
    }
}