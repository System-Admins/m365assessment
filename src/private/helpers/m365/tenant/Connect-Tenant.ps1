function Connect-Tenant
{
    <#
    .SYNOPSIS
        Login to various Microsoft services.
    .DESCRIPTION
        Connects to Microsoft 365 services such as Entra ID, SharePoint, Exchange, Fabric etc.
        All connections are interactive and will prompt the user for credentials using modern authentication.
        A webview page will open for each service and the user may be prompted to provide credentials.
    .NOTES
        Requires the following modules:
        - Az.Accounts
        - ExchangeOnlineManagement
        - Microsoft.Graph.Authentication
        - MicrosoftTeams
        - PnP.PowerShell
    .PARAMETER Disconnect
        If current connection should be disconnected.
    .EXAMPLE
        # Initiate login to Microsoft services.
        Connect-Tenant;
    .EXAMPLE
        # Disconnect first and then login to Microsoft Graph, Exchange Online and Azure.
        Connect-Tenant -Disconnect;
    #>
    [cmdletbinding()]
    param
    (
        # If current connection should be disconnected.
        [Parameter(Mandatory = $false)]
        [switch]$Disconnect
    )
    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Login' -Message ('Starting login process to Microsoft') -Level Information;

        # Microsoft Graph scopes.
        $mgScopes = @(
            'RoleManagement.Read.Directory',
            'Directory.Read.All',
            'AuditLog.Read.All',
            'User.Read.All',
            'Policy.Read.All',
            'Policy.ReadWrite.ConditionalAccess',
            'Reports.Read.All'
        );
    }
    PROCESS
    {
        # If we should disconnect.
        if ($true -eq $Disconnect)
        {
            # Try to disconnect from all services.
            try
            {            
                # Disconnect from Microsoft Graph.
                Write-Log -Category 'Login' -Subcategory 'Microsoft Graph' -Message ('Disconnecting from Microsoft Graph') -Level Information;
                Disconnect-MgGraph -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null;

                # Disconnect from Exchange Online.
                Write-Log -Category 'Login' -Subcategory 'Exchange Online' -Message ('Disconnecting from Exchange Online') -Level Information;
                Disconnect-ExchangeOnline -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Confirm:$false | Out-Null;

                # Disconnect from Azure.
                Write-Log -Category 'Login' -Subcategory 'Azure' -Message ('Disconnecting from Azure') -Level Information;
                Disconnect-AzAccount -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null;

                # Disconnect from SharePoint Online.
                Write-Log -Category 'Login' -Subcategory 'SharePoint Online' -Message ('Disconnecting from SharePoint Online') -Level Information;
                Disconnect-PnPOnline -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null;

                # Disconnect from Microsoft Teams.
                Write-Log -Category 'Login' -Subcategory 'Microsoft Teams' -Message ('Disconnecting from Microsoft Teams') -Level Information;
                Disconnect-MicrosoftTeams -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
            }
            # Something went wrong.
            catch
            {
                # Throw warning.
                Write-Log -Category 'Login' -Message ("Something went wrong while disconnecting from Microsoft services, execption is '{0}'" -f $_) -Level Warning;
            }
        }

        # Try to connect to Graph.
        try
        {
            # Write to log.
            Write-Log -Category 'Login' -Subcategory 'Microsoft Graph' -Message ('Trying to connect to Microsoft Graph') -Level Debug;
            Write-Log -Category 'Login' -Subcategory 'Microsoft Graph' -Message ('Please provide your credentials for Microsoft Graph in the web browser') -Level Information;

            # Launch interactive login.
            Connect-MgGraph -Scopes $mgScopes -NoWelcome -ErrorAction Stop | Out-Null;

            # Throw execption.
            Write-Log -Category 'Login' -Subcategory 'Microsoft Graph' -Message ('Successfully connected to Microsoft Graph') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Throw excpetion.
            Write-Log -Category 'Login' -Subcategory 'Microsoft Graph' -Message ("Could not connect to Microsoft Graph, execption is '{0}'" -f $_) -Level Error;
        }

        # Get Microsoft Graph context.
        $mgContext = Get-MgContext;

        # If there is not context, exit.
        if ($null -eq $mgContext)
        {
            # Throw excpetion.
            Write-Log -Category 'Login' -Subcategory 'Microsoft Graph' -Message ('Could not get Microsoft Graph context') -Level Error;
        }

        # Try to connect to Azure.
        try
        {
            # Write to log.
            Write-Log -Category 'Login' -Subcategory 'Azure' -Message ('Trying to connect to Azure') -Level Debug;
            Write-Log -Category 'Login' -Subcategory 'Azure' -Message ('Please provide your credentials for Entra ID in the web browser') -Level Information;

            # Launch interactive login.
            Connect-AzAccount -AccountId $mgContext.Account -ErrorAction Stop -Force | Out-Null;

            # Throw execption.
            Write-Log -Category 'Login' -Subcategory 'Azure' -Message ('Successfully connected to Azure') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Throw excpetion.
            Write-Log -Category 'Login' -Subcategory 'Azure' -Message ("Could not connect to Entra ID, execption is '{0}'" -f $_) -Level Error;
        }

        # Get the current context.
        $azContext = Get-AzContext;

        # If there is not context, exit.
        if ($null -eq $azContext)
        {
            # Throw excpetion.
            Write-Log -Category 'Login' -Subcategory 'Azure' -Message ('Could not get Azure context') -Level Error;
        }

        # Try to connect to Exchange Online.
        try
        {
            # Write to log.
            Write-Log -Category 'Login' -Subcategory 'Exchange Online' -Message ('Trying to connect to Exchange Online') -Level Debug;
            Write-Log -Category 'Login' -Subcategory 'Exchange Online' -Message ('Please provide your credentials for Exchange Online in the web browser') -Level Information;

            # Launch interactive login.
            Connect-ExchangeOnline -UserPrincipalName $azContext.Account.Id -ShowBanner:$false -ErrorAction Stop | Out-Null;

            # Throw execption.
            Write-Log -Category 'Login' -Subcategory 'Exchange Online' -Message ('Successfully connected to Exchange Online') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Throw excpetion.
            Write-Log -Category 'Login' -Subcategory 'Exchange Online' -Message ("Could not connect to Exchange Online, execption is '{0}'" -f $_) -Level Error;
        }

        # Try to connect to Security and Compliance.
        try
        {
            # Write to log.
            Write-Log -Category 'Login' -Subcategory 'Security and Compliance' -Message ('Trying to connect to Security and Compliance') -Level Debug;
            Write-Log -Category 'Login' -Subcategory 'Security and Compliance' -Message ('Please provide your credentials for Security and Compliance in the web browser') -Level Information;

            # Launch interactive login.
            Connect-IPPSSession -UserPrincipalName $azContext.Account.Id -ShowBanner:$false -ErrorAction Stop | Out-Null;

            # Throw execption.
            Write-Log -Category 'Login' -Subcategory 'Security and Compliance' -Message ('Successfully connected to Security and Compliance') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Throw excpetion.
            Write-Log -Category 'Login' -Subcategory 'Security and Compliance' -Message ("Could not connect to Security and Compliance, execption is '{0}'" -f $_) -Level Error;
        }

        # Get SharePoint URLs.
        $spoUrls = Get-SpoTenantUrl;

        # Try to connect to SharePoint.
        try
        {
            # Write to log.
            Write-Log -Category 'Login' -Subcategory 'SharePoint Online' -Message ('Trying to connect to SharePoint') -Level Debug;
            Write-Log -Category 'Login' -Subcategory 'SharePoint Online' -Message ('Please provide your credentials for SharePoint in the web browser') -Level Information;

            # Launch interactive login.
            Connect-PnPOnline -Interactive -Url $spoUrls.AdminUrl -ErrorAction Stop | Out-Null;

            # Throw execption.
            Write-Log -Category 'Login' -Subcategory 'SharePoint Online' -Message ('Successfully connected to SharePoint') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Throw excpetion.
            Write-Log -Category 'Login' -Subcategory 'SharePoint Online' -Message ("Could not connect to SharePoint, execption is '{0}'" -f $_) -Level Error;
        }

        # Try to connect to Teams.
        try
        {
            # Write to log.
            Write-Log -Category 'Login' -Subcategory 'Microsoft Teams' -Message ('Trying to connect to Teams') -Level Debug;
            Write-Log -Category 'Login' -Subcategory 'Microsoft Teams' -Message ('Please provide your credentials for Teams in the web browser') -Level Information;

            # Launch interactive login.
            Connect-MicrosoftTeams -AccountId $azContext.Account.Id -ErrorAction Stop | Out-Null;

            # Throw execption.
            Write-Log -Category 'Login' -Subcategory 'Microsoft Teams' -Message ('Successfully connected to Teams') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Throw excpetion.
            Write-Log -Category 'Login' -Subcategory 'Microsoft Teams' -Message ("Could not connect to Teams, execption is '{0}'" -f $_) -Level Error;
        }
    }
    END
    {
        # Write to log.
        Write-Log -Category 'Login' -Message ('Completed login process to Microsoft') -Level Information;
    }
}