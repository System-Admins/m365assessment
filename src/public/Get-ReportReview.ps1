$reviews = Invoke-Review -Service m365admin;

# Get all templates.
$reviewTemplates = Get-ChildItem -Path 'documentation/review' -Recurse -File -Filter '*.md';

# HTML content.
[string]$htmlContent = '';

# Foreach review.
foreach ($review in $reviews)
{
    # Review template filename.
    $templateName = ("{0}.md" -f $review.Id);

    # Get the review template.
    $template = $reviewTemplates | Where-Object { $_.Name -eq $templateName };

    # If the template does not exist, skip.
    if ($null -eq $template)
    {
        # Skip.
        continue;
    }

    # Get the HTML content.
    $htmlContent += Get-ReportReviewHtml -Path $template.FullName -Review $review;
}

# Return the HTML content.
$htmlContent | Out-File -FilePath '/Users/ath/Desktop/test.html' -Encoding utf8 -Force;