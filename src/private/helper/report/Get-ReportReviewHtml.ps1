function Get-ReviewHtmlBody
{
    <#
    .SYNOPSIS
        Get template file (markdown), replace review values and add data to the content.
    .DESCRIPTION
        Returns HTML (fragment) code.
    .EXAMPLE
        Get-ReviewHtmlBody -Path 'C:\path\to\report.md' -Review $review;
    #>
    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [Review]$Review
    )
    
    BEGIN
    {
        # If the file does not exist, throw an error.
        if (-not (Test-Path -Path $Path -PathType Leaf))
        {
            # Throw exception.
            Write-Log -Category 'Report' -Subcategory 'HTML' -Message ("Markdown file '{0}' does not exist" -f $Path) -Level Error;
        }
    }
    PROCESS
    {
        # Convert from Markdown to HTML.
        $htmlContent = (ConvertFrom-Markdown -Path $Path).Html;

        # Write to log.
        Write-Log -Category 'Report' -Subcategory 'HTML' -Message ("Replacing ID with '{0}'" -f $Review.Id) -Level Debug;
        Write-Log -Category 'Report' -Subcategory 'HTML' -Message ("Replacing CATEGORY with '{0}'" -f $Review.Category) -Level Debug;
        Write-Log -Category 'Report' -Subcategory 'HTML' -Message ("Replacing SUBCATEGORY with '{0}'" -f $Review.Subcategory) -Level Debug;
        Write-Log -Category 'Report' -Subcategory 'HTML' -Message ("Replacing TITLE with '{0}'" -f $Review.Title) -Level Debug;
        Write-Log -Category 'Report' -Subcategory 'HTML' -Message ("Replacing REVIEW with '{0}'" -f $Review.Review) -Level Debug;
        Write-Log -Category 'Report' -Subcategory 'HTML' -Message ("Replacing DATE with '{0}'" -f (Get-Date).ToString('yyyy-MM-dd')) -Level Debug;

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

        # Add div.
        $htmlContent = '<div id="review-{0}" class="review">{1}</div>' -f $Review.Id, $htmlContent;
    }
    END
    {
        # Return HTML.
        return $htmlContent;
    }
}