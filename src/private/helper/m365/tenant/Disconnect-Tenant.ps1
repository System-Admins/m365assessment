function Disconnect-Tenant
{
    <#
    .SYNOPSIS
        Logout from various Microsoft services.
    .DESCRIPTION
        Disconnects from Microsoft 365 services such as Entra ID, SharePoint, Exchange, Fabric etc.
    .NOTES
        Requires the following modules:
        - Az.Accounts
        - ExchangeOnlineManagement
        - Microsoft.Graph.Authentication
        - MicrosoftTeams
        - PnP.PowerShell
    .EXAMPLE
        # Initiate logout from Microsoft services.
        Disconnect-Tenant;
    #>
    [cmdletbinding()]
    param
    (
    )
    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Logout' -Message ('Starting logout process from Microsoft') -Level Debug;
    }
    PROCESS
    {

        # Disconnect from Microsoft Graph.
        Write-Log -Category 'Logout' -Subcategory 'Microsoft Graph' -Message ('Disconnecting from Microsoft Graph') -Level Debug;
        $null = Disconnect-MgGraph -ErrorAction SilentlyContinue -WarningAction SilentlyContinue;

        # Disconnect from Exchange Online.
        Write-Log -Category 'Logout' -Subcategory 'Exchange Online' -Message ('Disconnecting from Exchange Online') -Level Debug;
        $null = Disconnect-ExchangeOnline -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Confirm:$false;

        # Disconnect from Azure.
        Write-Log -Category 'Logout' -Subcategory 'Azure' -Message ('Disconnecting from Azure') -Level Debug;
        $null = Disconnect-AzAccount -ErrorAction SilentlyContinue -WarningAction SilentlyContinue;

        # Disconnect from Microsoft Teams.
        Write-Log -Category 'Logout' -Subcategory 'Microsoft Teams' -Message ('Disconnecting from Microsoft Teams') -Level Debug;
        $null = Disconnect-MicrosoftTeams -ErrorAction SilentlyContinue -WarningAction SilentlyContinue;

        # Try to disconnect SharePoint.
        try
        {   
            # Disconnect from SharePoint Online.
            Write-Log -Category 'Logout' -Subcategory 'SharePoint Online' -Message ('Disconnecting from SharePoint Online') -Level Debug;
            $null = Disconnect-PnPOnline -ErrorAction SilentlyContinue -WarningAction SilentlyContinue;
        }
        # Something went wrong.
        catch
        {
            # Throw warning.
            Write-Log -Category 'Logout' -Subcategory 'SharePoint Online' -Message ("Something went wrong while disconnecting from SharePoint Online, exception is '{0}'" -f $_) -Level Debug;
        }
    }
    END
    {
        # Write to log.
        Write-Log -Category 'Logout' -Message ('Completed logout process from Microsoft') -Level Debug;
    }
}