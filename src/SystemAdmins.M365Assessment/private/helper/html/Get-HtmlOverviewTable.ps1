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

        # Add counter.
        [int]$counter = 1;

        # Foreach review.
        foreach ($review in $Reviews)
        {
            # Add to the HTML content.
            $htmlContent += @"
            <tr>
              <td>$($review.Category)</td>
              <td>$($review.Subcategory)</td>
              <td><a href="#review-$($review.Id)" title="$($review.Title)">$($counter). $($review.Title)</a></td>
            </tr>
"@;

            # Increment counter.
            $counter++;
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