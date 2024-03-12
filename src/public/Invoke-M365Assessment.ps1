function Invoke-M365Assessment
{
    <#
    .SYNOPSIS
        Run the Microsoft 365 assessment and export results to a HTML report.
    .DESCRIPTION
        Run all reviews and export the results to a HTML report in a ZIP-file.
    .PARAMETER All
        If all reviews should be exported, even if they are passed.
    .EXAMPLE
        # Run the assessment and export all results to a HTML report.
        Invoke-M365Assessment -All;
    .EXAMPLE
        # Run the assessment and only export the results that are not passed to a HTML report.
        Invoke-M365Assessment;
    #>

    [cmdletbinding()]
    param
    (
        # If all reviews should be exported.
        [Parameter(Mandatory = $false)]
        [switch]$All,

        # Path to export the HTML report (ZIP-file).
        [Parameter(Mandatory = $false)]
        [string]$Path = (
            '{0}/{1}_m365assessment.zip' -f
            ([Environment]::GetFolderPath('Desktop')),
            (Get-Date).ToString('yyyyMMdd')
        )
    )

    BEGIN
    {
        # Get reviews.
        $reviews = Invoke-Review;
    }
    PROCESS
    {
        # If all reviews should be exported.
        if ($true -eq $All)
        {
            # Get only the reviews that are true.
            $shouldBeReviewed = $reviews;
        }
        # Else only get the reviews that are true.
        else
        {
            # Get only the reviews that are true.
            $shouldBeReviewed = $reviews | Where-Object -FilterScript { $true -eq $_.Review };
        }

        # Get HTML report.
        $htmlZipFilePath = Get-HtmlReport -Reviews $shouldBeReviewed -OutputFilePath $Path;

        # Get folder path.
        $htmlZipFolderPath = Split-Path -Path $htmlZipFilePath;
    }
    END
    {
        # Open folder.
        Invoke-Item -Path $htmlZipFolderPath;
    }
}