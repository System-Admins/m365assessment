function Get-Emoji
{
    <#
    .SYNOPSIS
        Get predefined emojis.
    .DESCRIPTION
        Convert hex to emoji.
    .PARAMETER Type
        What type of emoji.
    .EXAMPLE
        # Get checkmark Emoji.
        Get-Emoji -Type Checkmark;
    #>
    [cmdletbinding()]
    param
    (
    
        # Message to write to log.
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Checkmark', 'Crossmark', 'Warning')]
        [string]$Type
    )
    
    BEGIN
    {
    }
    PROCESS
    {
        # Based on type.
        switch ($Type)
        {
            # Checkmark.
            'Checkmark'
            {
                # Get emoji from HEX.
                $emojiIcon = [System.Convert]::toInt32('2705', 16);
                $result = [System.Char]::ConvertFromUtf32($EmojiIcon);
            }
            # Cross mark.
            'Crossmark'
            {
                # Get emoji from HEX.
                $emojiIcon = [System.Convert]::toInt32('274C', 16);
                $result = [System.Char]::ConvertFromUtf32($EmojiIcon);
            }
            # Warning.
            'Warning'
            {
                # Get emoji from HEX.
                $emojiIcon = [System.Convert]::toInt32('1F4A1', 16);
                $result = [System.Char]::ConvertFromUtf32($EmojiIcon);
            }
        }
    }
    END
    {
        # Return emoji.
        return $result;
    }
}