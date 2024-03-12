function Connect-M365Tenant
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
    .EXAMPLE
        # Initiate login to Microsoft services.
        Connect-M365Tenant;
    #>
    [cmdletbinding()]
    param
    (
    )
    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Login' -Message ('Starting login process to Microsoft') -Level Debug;

        # Microsoft Graph scopes.
        $mgScopes = @(
            'RoleManagement.Read.Directory',
            'Directory.Read.All',
            'RoleEligibilitySchedule.Read.Directory',
            'AuditLog.Read.All',
            'User.Read.All',
            'Policy.Read.All',
            'Policy.ReadWrite.ConditionalAccess',
            'Reports.Read.All',
            'SecurityEvents.Read.All'
        );
    }
    PROCESS
    {
        # Try to connect to Graph.
        try
        {
            # Write to log.
            Write-Log -Category 'Login' -Subcategory 'Microsoft Graph' -Message ('Trying to connect to Microsoft Graph') -Level Debug;
            Write-Log -Category 'Login' -Subcategory 'Microsoft Graph' -Message ('Please provide your credentials for Microsoft Graph in the web browser') -Level Information;

            # Launch interactive login.
            $null = Connect-MgGraph -Scopes $mgScopes -NoWelcome -ErrorAction Stop;

            # Throw exception.
            Write-Log -Category 'Login' -Subcategory 'Microsoft Graph' -Message ('Successfully connected to Microsoft Graph') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Throw exception.
            Write-Log -Category 'Login' -Subcategory 'Microsoft Graph' -Message ("Could not connect to Microsoft Graph, exception is '{0}'" -f $_) -Level Error;
        }

        # Get Microsoft Graph context.
        $mgContext = Get-MgContext;

        # If there is not context, exit.
        if ($null -eq $mgContext)
        {
            # Throw exception.
            Write-Log -Category 'Login' -Subcategory 'Microsoft Graph' -Message ('Could not get Microsoft Graph context') -Level Error;
        }

        # This is run due to issues with the Microsoft Graph module.
        $null = Get-MgUser -Top 1;

        # Try to connect to Azure.
        try
        {
            # Write to log.
            Write-Log -Category 'Login' -Subcategory 'Azure' -Message ('Trying to connect to Azure') -Level Debug;
            Write-Log -Category 'Login' -Subcategory 'Azure' -Message ('Please provide your credentials for Entra ID in the web browser') -Level Information;

            # Launch interactive login.
            $null = Connect-AzAccount -ErrorAction Stop -Force;

            # Throw exception.
            Write-Log -Category 'Login' -Subcategory 'Azure' -Message ('Successfully connected to Azure') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Throw exception.
            Write-Log -Category 'Login' -Subcategory 'Azure' -Message ("Could not connect to Entra ID, exception is '{0}'" -f $_) -Level Error;
        }

        # Get the current context.
        $azContext = Get-AzContext;

        # If there is not context, exit.
        if ($null -eq $azContext)
        {
            # Throw exception.
            Write-Log -Category 'Login' -Subcategory 'Azure' -Message ('Could not get Azure context') -Level Error;
        }

        # Try to connect to Exchange Online.
        try
        {
            # Write to log.
            Write-Log -Category 'Login' -Subcategory 'Exchange Online' -Message ('Trying to connect to Exchange Online') -Level Debug;
            Write-Log -Category 'Login' -Subcategory 'Exchange Online' -Message ('Please provide your credentials for Exchange Online in the web browser') -Level Information;

            # Launch interactive login.
            $null = Connect-ExchangeOnline -UserPrincipalName $azContext.Account.Id -ShowBanner:$false -ErrorAction Stop;

            # Throw exception.
            Write-Log -Category 'Login' -Subcategory 'Exchange Online' -Message ('Successfully connected to Exchange Online') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Throw exception.
            Write-Log -Category 'Login' -Subcategory 'Exchange Online' -Message ("Could not connect to Exchange Online, exception is '{0}'" -f $_) -Level Error;
        }

        # Try to connect to Security and Compliance.
        try
        {
            # Write to log.
            Write-Log -Category 'Login' -Subcategory 'Security and Compliance' -Message ('Trying to connect to Security and Compliance') -Level Debug;
            Write-Log -Category 'Login' -Subcategory 'Security and Compliance' -Message ('Please provide your credentials for Security and Compliance in the web browser') -Level Information;

            # Launch interactive login.
            $null = Connect-IPPSSession -UserPrincipalName $azContext.Account.Id -ShowBanner:$false -ErrorAction Stop;

            # Throw exception.
            Write-Log -Category 'Login' -Subcategory 'Security and Compliance' -Message ('Successfully connected to Security and Compliance') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Throw exception.
            Write-Log -Category 'Login' -Subcategory 'Security and Compliance' -Message ("Could not connect to Security and Compliance, exception is '{0}'" -f $_) -Level Error;
        }

        # Try to connect to Microsoft Teams.
        try
        {
            # Write to log.
            Write-Log -Category 'Login' -Subcategory 'Microsoft Teams' -Message ('Trying to connect to Teams') -Level Debug;
            Write-Log -Category 'Login' -Subcategory 'Microsoft Teams' -Message ('Please provide your credentials for Teams in the web browser') -Level Information;

            # Launch interactive login.
            $null = Connect-MicrosoftTeams -ErrorAction Stop;

            # Throw exception.
            Write-Log -Category 'Login' -Subcategory 'Microsoft Teams' -Message ('Successfully connected to Teams') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Throw exception.
            Write-Log -Category 'Login' -Subcategory 'Microsoft Teams' -Message ("Could not connect to Teams, exception is '{0}'" -f $_) -Level Error;
        }

        # Get SharePoint URLs.
        $spoUrls = Get-SpoTenantUrl;

        # Try to connect to SharePoint.
        try
        {
            # Write to log.
            Write-Log -Category 'Login' -Subcategory 'SharePoint Online' -Message ('Trying to connect to SharePoint') -Level Debug;
            Write-Log -Category 'Login' -Subcategory 'SharePoint Online' -Message ('Please provide your credentials for SharePoint in the web browser or webview prompt') -Level Information;

            # Launch interactive login.
            $null = Connect-PnPOnline -Interactive -Url $spoUrls.AdminUrl -ErrorAction Stop;

            # Throw exception.
            Write-Log -Category 'Login' -Subcategory 'SharePoint Online' -Message ('Successfully connected to SharePoint') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Throw exception.
            Write-Log -Category 'Login' -Subcategory 'SharePoint Online' -Message ("Could not connect to SharePoint, exception is '{0}'" -f $_) -Level Error;
        }
    }
    END
    {
        # Write to log.
        Write-Log -Category 'Login' -Message ('Completed login process to Microsoft') -Level Debug;
    }
}