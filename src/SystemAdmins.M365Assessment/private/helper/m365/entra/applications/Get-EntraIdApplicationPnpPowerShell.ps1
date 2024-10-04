function Get-EntraIdApplicationPnpPowerShell
{
    <#
    .SYNOPSIS
        Search after the Entra ID application used to connect to SharePoint with PnP.PowerShell.
    .DESCRIPTION
        Returns application object.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Applications
    .EXAMPLE
        Get-EntraIdApplicationPnpPowerShell;
    #>

    [cmdletbinding()]
    param
    (
        # Display name of the application.
        [Parameter(Mandatory = $true)]
        [string]$DisplayName
    )

    BEGIN
    {
        # Write to log.
        Write-CustomLog -Category 'Entra' -Subcategory 'Application' -Message 'Getting PnP.PowerShell application' -Level Verbose;

        # Search after the  application.
        $applications = Get-MgApplication -ConsistencyLevel 'Eventual' -Search ('"DisplayName:{0}"' -f $DisplayName);

        # Variable for application.
        $application = $null;
    }
    PROCESS
    {
        # If no application was found.
        if ($applications.Count -eq 0)
        {
            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'Application' -Message 'No PnP.PowerShell application found' -Level Warning;
        }
        # Else if multiple applications were found.
        elseif ($applications.Count -gt 1)
        {
            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'Application' -Message 'Multiple PnP.PowerShell applications found' -Level Warning;

            # Get the first application.
            $application = $applications[0];

            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'Application' -Message ("Using the first application '{0}'" -f $application.Id) -Level Verbose;
        }
        # Else if only one application was found.
        else
        {
            # Get the application.
            $application = $applications;

            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'Application' -Message ("Using the application '{0}'" -f $application.Id) -Level Verbose;
        }
    }
    END
    {
        # If application was found.
        if ($null -ne $application)
        {
            # Return application.
            return $application;
        }
    }
}