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
            # Get check mark.
            $emoji = Get-Emoji -Type Crossmark;
        }
        else
        {
            # Get cross mark.
            $emoji = Get-Emoji -Type Checkmark;
        }
        
        # Write to log.
        Write-Log -Category ("{0} {1}"-f $emoji, $this.Category) -Subcategory $this.Subcategory -Message ('{0}' -f $this.Title) -Level Information -NoDateTime -NoLogLevel -NoLogFile;
    }
}