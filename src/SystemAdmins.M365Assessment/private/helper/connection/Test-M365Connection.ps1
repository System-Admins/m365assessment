function Test-M365Connection
{
    <#
    .SYNOPSIS
        Test login to various Microsoft services.
    .DESCRIPTION
        Invoke differrent endpoints to check connectivity to Microsoft 365 services such as Entra ID, SharePoint, Exchange, Fabric etc.
    .NOTES
        Requires the following modules:
        - Az.Accounts
        - ExchangeOnlineManagement
        - Microsoft.Graph.Authentication
        - MicrosoftTeams
        - PnP.PowerShell
    .EXAMPLE
        # Test login to Microsoft services.
        Test-M365Connection;
    #>
    [cmdletbinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
    )
    BEGIN
    {
        # Hash table for connections.
        [hashtable]$connections = @{};

        # Microsoft Graph.
        $connections.Add('Graph', $false);

        # Azure.
        $connections.Add('Azure', $false);

        # Exchange Online.
        $connections.Add('ExchangeOnline', $false);

        # Microsoft Teams.
        $connections.Add('Teams', $false);

        # SharePoint.
        $connections.Add('SharePoint', $false);
    }
    PROCESS
    {
        # Try to connect to Microsoft services.
        try
        {
            # Test connection to Microsoft Graph.
            $null = Get-MgContext -ErrorAction Stop;
            $connections.Graph = $true;
        }
        catch
        {
            # Write to log.
            Write-CustomLog -Category 'Connection' -Subcategory 'Microsoft Graph' -Message ('Not connected') -Level Verbose;
        }

        # Try to connect to Azure.
        try
        {
            # Test connection to Azure.
            $azAccessToken = Get-AzAccessToken -AsSecureString -WarningAction SilentlyContinue -ErrorAction Stop;
            $null = ConvertFrom-SecureString -SecureString $azAccessToken.Token -ErrorAction Stop;
            $connections.Azure = $true;
            $null = Remove-Variable -Name azAccessToken -ErrorAction SilentlyContinue;
        }
        catch
        {
            # Write to log.
            Write-CustomLog -Category 'Connection' -Subcategory 'Azure' -Message ('Not connected') -Level Verbose;
        }

        # Try to connect to Exchange Online.
        try
        {
            # Test connection to Exchange Online.
            $null = Get-AcceptedDomain -ErrorAction Stop;
            $connections.ExchangeOnline = $true;
        }
        catch
        {
            # Write to log.
            Write-CustomLog -Category 'Connection' -Subcategory 'Exchange Online' -Message ('Not connected') -Level Verbose;
        }

        # Try to connect to Microsoft Teams.
        try
        {
            # Test connection to Microsoft Teams.
            $null = Get-Team -ErrorAction Stop -ProgressAction SilentlyContinue;
            $connections.Teams = $true;
        }
        catch
        {
            # Write to log.
            Write-CustomLog -Category 'Connection' -Subcategory 'Microsoft Teams' -Message ('Not connected') -Level Verbose;
        }

        # Try to connect to SharePoint.
        try
        {
            # Test connection to SharePoint.
            $null = Get-PnPTenant -ErrorAction Stop;
            $connections.SharePoint = $true;
        }
        catch
        {
            # Write to log.
            Write-CustomLog -Category 'Connection' -Subcategory 'SharePoint Online' -Message ('Not connected') -Level Verbose;
        }
    }
    END
    {
        # Return connections.
        return $connections;
    }
}