function Update-ReportContent
{
    <#
    .SYNOPSIS
        Update report template with review data.
    .DESCRIPTION
        Import markdown data and replace content with review data.
        Returns HTML (string)
    .EXAMPLE
        Update-ReportContent -Path 'C:\path\to\report.md' -Review $review;
    #>
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][Review]$Review
    )
    
    BEGIN
    {
    }
    PROCESS
    {
        # Convert from Markdown to HTML.
        $htmlContent = (ConvertFrom-Markdown -Path $Path).Html;

        # Update the content of the file.
        $htmlContent = $htmlContent.Replace('{{ID}}', $Review.Id);
        $htmlContent = $htmlContent.Replace('{{CATEGORY}}', $Review.Category);
        $htmlContent = $htmlContent.Replace('{{SUBCATEGORY}}', $Review.Subcategory);
        $htmlContent = $htmlContent.Replace('{{TITLE}}', $Review.Title);
        $htmlContent = $htmlContent.Replace('{{REVIEW}}', $Review.Review);
        $htmlContent = $htmlContent.Replace('{{DATE}}', (Get-Date).ToString('yyyy-MM-dd'));

        # Convert review data to HTML.
        $reviewData = $Review.Data | ConvertTo-Html -Fragment;

        # Add to content.
        $htmlContent += $reviewData;
    }
    END
    {
        # Return HTML.
        return $htmlContent;
    }
}