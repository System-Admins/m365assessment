function Get-HtmlReport
{
    <#
    .SYNOPSIS
        Generate the HTML report.
    .DESCRIPTION
        Returns the path of the ZIP-file.
    .PARAMETER Reviews
        Reviews to get the HTML code.
    .PARAMETER WebTemplatePath
        Path to the web template.
    .PARAMETER MarkdownTemplatePath
        Path to the markdown templates.
    .PARAMETER OutputFilePath
        Output path for the ZIP-file.
    .EXAMPLE
        Get-HtmlReport -Reviews $reviews -WebTemplatePath 'private/template/web' -MarkdownTemplatePath 'private/template/markdown' -OutputFilePath 'C:\path\to\output.zip';
    #>

    [cmdletbinding()]
    param
    (
        # Reviews to get the HTML code.
        [Parameter(Mandatory = $true)]
        [Review[]]$Reviews,
        
        # Path to the web template.
        [Parameter(Mandatory = $false)]
        [string]$WebTemplatePath = ('{0}/private/template/web' -f $Script:scriptPath),
        
        # Path to the markdown templates.
        [Parameter(Mandatory = $false)]
        [string]$MarkdownTemplatePath = ('{0}/private/template/markdown' -f $Script:scriptPath),

        # Output path for the ZIP-file.
        [Parameter(Mandatory = $false)]
        [string]$OutputFilePath = ('{0}/m365assessment.zip' -f ([Environment]::GetFolderPath('Desktop')))
    )

    BEGIN
    {
        # Temporary path for the HTML report.
        $tempPath = Join-Path -Path $env:TEMP -ChildPath ((New-Guid).Guid);

        # Get tenant company profile.
        $tenantProfile = Get-TenantProfile;
    }
    PROCESS
    {
        # Copy the web template to the temporary path.
        $null = Copy-Item -Path $WebTemplatePath -Destination $tempPath -Recurse -Force;

        # Get overview table in HTML.
        $overviewTableHtml = Get-HtmlOverviewTable -Reviews $Reviews;

        # Get review in HTML.
        $reviewHtml = Get-HtmlReview -Reviews $Reviews -Path $MarkdownTemplatePath;

        # Replace the review content in the web template.
        $indexFilePath = Join-Path -Path $tempPath -ChildPath 'index.html';

        # If the HTML index file dont exist.
        if (!(Test-Path -Path $indexFilePath -PathType Leaf))
        {
            # Throw exception.
            Write-Log -Category 'Report' -Subcategory 'HTML' -Message ("HTML file '{0}' does not exist" -f $indexFilePath) -Level Error;
        }

        # Get content of the HTML index html.
        $indexContent = Get-Content -Path $indexFilePath;

        # Replace the content in the web template.
        $indexContent = $indexContent.Replace('{{OVERVIEWTABLE}}', $overviewTableHtml);
        $indexContent = $indexContent.Replace('{{REVIEW}}', $reviewHtml);
        $indexContent = $indexContent.Replace('{{COMPANYNAME}}', $tenantProfile.Name);

        # Save the content to the temporary path.
        $indexContent | Set-Content -Path $indexFilePath -Force;

        # Write to log.
        Write-Log -Category 'Report' -Subcategory 'HTML' -Message ("Compressing folder '{0}' to file '{1}'" -f $tempPath, $OutputFilePath) -Level Debug;

        # ZIP the temporary path.
        Compress-Archive -Path ($tempPath + "/*") -DestinationPath $OutputFilePath -Force;
    }
    END
    {
        # Remove the temporary path.
        Remove-Item -Path $tempPath -Recurse -Force;

        # Return the path to the ZIP-file.
        return $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputFilePath);
    }
}