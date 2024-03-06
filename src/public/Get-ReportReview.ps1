$reviews = Invoke-Review;

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
        Write-Host "Kan ikke finde $($review.Id) $($review.Title)"
        # Skip.
        continue;
    }#

    # Get the HTML content.
    $htmlContent += Get-ReportReviewHtml -Path $template.FullName -Review $review;
}

# Return the HTML content.
$htmlContent | Out-File -FilePath "C:\Users\AlexHansen\OneDrive - System Admins\Desktop\hmm.html" -Encoding utf8 -Force;