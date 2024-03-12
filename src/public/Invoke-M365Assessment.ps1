function Invoke-M365Assessment
{
    <#
    .SYNOPSIS
        .
    .DESCRIPTION
        .
    .PARAMETER Reviews
        .
    .EXAMPLE
        .
    #>

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Get reviews.
        $reviews = Invoke-Review;
    }
    PROCESS
    {
        # Get only the reviews that are true.
        $shouldBeReviewed = $reviews | Where-Object -FilterScript { $true -eq $_.Review };

        # Get HTML report.
        $htmlZipFilePath = Get-HtmlReport -Reviews $shouldBeReviewed;

        # Get folder path.
        $htmlZipFolderPath = Split-Path -Path $htmlZipFilePath;
    }
    END
    {
        # Open folder.
        Invoke-Item -Path $htmlZipFolderPath;
    }
}