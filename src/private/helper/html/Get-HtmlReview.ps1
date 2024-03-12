function Get-HtmlReview
{
    <#
    .SYNOPSIS
        Get all markdown documents and replace with review data.
    .DESCRIPTION
        Returns HTML code.
    .PARAMETER Review
        Review(s) to get the HTML code.
    .PARAMETER Path
        Path to the documentation templates.
    .EXAMPLE
        # Get report HTML.
        Get-HtmlReview -Reviews $reviews -Path 'documentation/review';
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
            $htmlContent += Set-HtmlReview -Path $template.FullName -Review $review;
        }
    }
    END
    {
        # Return the HTML content.
        return $htmlContent;
    }
}