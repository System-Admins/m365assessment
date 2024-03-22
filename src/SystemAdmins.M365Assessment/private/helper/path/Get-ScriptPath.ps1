function Get-ScriptPath
{
    <#
    .SYNOPSIS
        Get script path.
    .DESCRIPTION
        Returns script path
    .EXAMPLE
        Get-ScriptPath
    #>
    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Variable for script path.
        [string]$scriptPath = '';
    }
    PROCESS
    {


        # If the script is running in the ISE, use the current file path.
        if ($psISE)
        {
            # Use info from variable psISE.
            $scriptPath = Split-Path -Path $psISE.CurrentFile.FullPath;
        }
        # Else if we are running in VSCode, use the PSScriptRoot.
        elseif ($null -ne $psEditor)
        {
            # Use info from variable psEditor.
            $scriptPath = Split-Path -Path ($psEditor.GetEditorContext().CurrentFile.Path);
        }
        # Else use the current working directory.
        else
        {
            # Use the current working directory.
            $scriptPath = $PSScriptRoot;
        }
    }
    END
    {
        # Return the script path.
        return $scriptPath;
    }
}