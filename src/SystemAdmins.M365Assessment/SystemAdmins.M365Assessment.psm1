# Variable for script path.
[string]$scriptPath = '';

# If the script is running in the ISE, use the current file path.
if ($null -ne $psISE)
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

# Paths to the private and public folders.
[string]$privatePath = Join-Path -Path $scriptPath -ChildPath 'private';
[string]$publicPath = Join-Path -Path $scriptPath -ChildPath 'public';

# Object array to store all PowerShell files to dot source.
$ps1Files = New-Object -TypeName System.Collections.ArrayList;

# Get all the files in the src (private and public) folder.
$privatePs1Files = Get-ChildItem -Path $privatePath -Recurse -File -Filter *.ps1;
$publicPs1Files = Get-ChildItem -Path $publicPath -Recurse -File -Filter *.ps1;

# Add the private and public files to the object array.
$ps1Files += ($privatePs1Files).FullName;
$ps1Files += ($publicPs1Files).FullName;

# Loop through each PowerShell file.
foreach ($ps1File in $ps1Files)
{
    # Try to dot source the file.
    try
    {
        # Write to log.
        Write-Debug -Message ("Dot sourcing the PowerShell file '{0}'" -f $ps1File);

        # Dot source the file.
        . $ps1File;
    }
    catch
    {
        # Throw execption.
        Write-Error -Message ("Something went wrong while importing the PowerShell file '{0}', the execption is:`r`n" -f $ps1File, $_);
    }
}

# Write to log.
Write-CustomLog -Category 'Module' -Message ("Script path is '{0}'" -f $scriptPath) -Level Verbose;

# Get all the functions in the public section.
$publicFunctions = $publicPs1Files.Basename;

# Set script variable.
$Script:scriptPath = $scriptPath;

# Check if required modules are installed.
$installedModules = Get-M365Module -Modules $Script:Modules | Where-Object { $false -eq $_.Valid };

# If not all modules are installed, throw exception.
if ($null -ne $installedModules)
{
    # Write to log.
    Write-CustomLog -Category 'Module' -Message ("Exporting the functions 'Install-M365Dependency'") -Level Verbose;

    # Expose only the function "Install-M365Dependency".
    Export-ModuleMember -Function 'Install-M365Dependency';

    # Throw warning.
    Write-CustomLog -Message ('Not all required modules are installed, please run "Install-M365Dependency"') -Level Warning -NoDateTime -NoLogLevel;
    Write-CustomLog -Message ('Then restart the PowerShell session and import the module again') -Level Warning -NoDateTime -NoLogLevel;
}
# Else all modules are installed.
else
{
    # Write to log.
    Write-CustomLog -Category 'Module' -Message ("Exporting the functions '{0}'" -f ($publicFunctions -join ',')) -Level Verbose;

    # Export functions.
    Export-ModuleMember -Function $publicFunctions;
}