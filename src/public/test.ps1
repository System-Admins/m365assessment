# Get all the files in the src (private) folder.
$ps1Files = Get-ChildItem -Path 'C:\Repositories\m365assessment\src\private' -Recurse -File -Filter *.ps1;
#$ps1Files = Get-ChildItem -Path '/Users/ath/Repositories/m365assessment/src/private' -Recurse -File -Filter *.ps1;

# Loop through each file
foreach ($ps1File in $ps1Files)
{
    # Dot source the file.
    . $ps1File.FullName;
}

######################################

#Uninstall-ModuleAll -OnlyUnload
#Uninstall-ModuleAll -Debug

# Install modules.
#Install-Modules -Reinstall -Debug;

# Connect to Microsoft.
#Connect-Tenant;