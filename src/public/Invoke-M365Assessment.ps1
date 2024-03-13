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
    .EXAMPLE
        # Run review and return data.
        $reviews = Invoke-M365Assessment -ReturnReviews;
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
        ),

        # If the reviews should be returned.
        [Parameter(Mandatory = $false)]
        [switch]$ReturnReviews
    )

    BEGIN
    {
        # Test connections.
        $testConnections = Test-M365Connection;

        # If there are connections missing.
        if ($testConnections.Values | Where-Object { $_ -eq $false })
        {
            # Write to log.
            Write-Log -Message ('Missing connection to Microsoft 365, please run "Connect-M365Tenant"') -Level Warning -NoDateTime -NoLogLevel;

            # Exit script.
            break;
        }

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

        # Write to log.
        Write-Log -Message ("Report Path: {0}" -f $htmlZipFilePath) -Level Information -NoDateTime -NoLogLevel;

        # If return is requested.
        if ($true -eq $ReturnReviews)
        {
            # Return the reviews.
            return $reviews;
        }
    }
}