# Class used for reviews.
class Review
{
    [string]$Id;
    [string]$Title;
    [string]$Category;
    [string]$Subcategory;
    [bool]$Review;
    $Data;

    [void]PrintResult()
    {
        # If review is true.
        if ($true -eq $this.Review)
        {
            # Get checkmark.
            $emoji = Get-Emoji -Type Crossmark;
        }
        else
        {
            # Get crossmark.
            $emoji = Get-Emoji -Type Checkmark;
        }
        
        # Write to log.
        Write-Log -Category $this.Category -Subcategory $this.Subcategory -Message ('{0} {1}' -f $emoji, $this.Title) -Level Information -NoDateTime -NoLogLevel -NoLogFile;
    }
}