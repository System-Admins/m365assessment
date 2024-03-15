function Get-HtmlOverviewTable
{
    <#
    .SYNOPSIS
        Generate a table overview of review in HTML format.
    .DESCRIPTION
        Returns HTML code.
    .PARAMETER Review
        Review(s) to get the HTML code.
    .EXAMPLE
        # Get report HTML.
        Get-HtmlOverviewTable -Reviews $reviews;
    #>

    [cmdletbinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [Review[]]$Reviews
    )

    BEGIN
    {
        # HTML content.
        [string]$htmlContent = '';
    }
    PROCESS
    {
        # Add to the HTML content.
        $htmlContent += @'
        <table>
        <colgroup>
          <col />
          <col />
          <col />
        </colgroup>
        <thead>
        <tr>
          <th>Category</th>
          <th>Subcategory</th>
          <th>Title</th>
        </tr>
        </thead>
        <tbody>
'@;

        # Foreach review.
        foreach ($review in $Reviews)
        {
            # Add to the HTML content.
            $htmlContent += @"
            <tr>
              <td>$($review.Category)</td>
              <td>$($review.Subcategory)</td>
              <td><a href="#review-d106f228-2f57-4009-a4c1-8d309a97c4f3" title="$($review.Title)">$($review.Title)</a></td>
            </tr>
"@;
        }

        # Add to the HTML content.
        $htmlContent += @'
        </tbody>
        </table>
'@;
    }
    END
    {
        # Return the HTML content.
        return $htmlContent;
    }
}