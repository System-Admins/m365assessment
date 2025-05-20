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
        Write-CustomLog -Category 'Login' -Message ('Starting login process to Microsoft') -Level Verbose;

        # Microsoft Graph scopes.
        $mgScopes = @(
            'RoleManagement.Read.Directory',
            'Application.Read.All',
            'Directory.Read.All',
            'RoleEligibilitySchedule.Read.Directory',
            'AuditLog.Read.All',
            'User.Read.All',
            'Policy.Read.All',
            'Policy.ReadWrite.ConditionalAccess',
            'Reports.Read.All',
            'SecurityEvents.Read.All',
            'Organization.Read.All'
        );
    }
    PROCESS
    {
        # Try to connect to Graph.
        try
        {
            # Write to log.
            Write-CustomLog -Category 'Login' -Subcategory 'Microsoft Graph' -Message ('Trying to connect to Microsoft Graph') -Level Verbose;
            Write-CustomLog -Message ('Microsoft Graph: Please provide your credentials for Microsoft Graph') -Level Information -NoDateTime -NoLogLevel;

            # Force disconnect (else it will use SSO).
            Disconnect-Graph -ErrorAction SilentlyContinue;

            # Launch interactive login.
            $null = Connect-MgGraph -Scopes $mgScopes -NoWelcome -WarningAction SilentlyContinue -ContextScope Process -ErrorAction Stop;

            # Throw exception.
            Write-CustomLog -Category 'Login' -Subcategory 'Microsoft Graph' -Message ('Successfully connected to Microsoft Graph') -Level Verbose;
        }
        # Something went wrong.
        catch
        {
            # Throw exception.
            throw ("Could not connect to Microsoft Graph, exception is '{0}'" -f $_);
        }

        # Get Microsoft Graph context.
        $mgContext = Get-MgContext;

        # If there is not context, exit.
        if ($null -eq $mgContext)
        {
            # Throw exception.
            throw ('Could not get Microsoft Graph context');
        }

        # Try to get content from Microsoft Graph.
        try
        {
            # This is run due to issues with the Microsoft Graph module.
            $null = Get-MgUser -Top 1 -ErrorAction SilentlyContinue;
        }
        catch
        {
            # Throw exception.
            throw ("Could not get content from Microsoft Graph (try to restart the PowerShell session), exception is '{0}'" -f $_);
        }

        # Try to connect to Azure.
        try
        {
            # Write to log.
            Write-CustomLog -Category 'Login' -Subcategory 'Azure' -Message ('Trying to connect to Azure') -Level Verbose;
            Write-CustomLog -Message ('Entra ID: Please provide your credentials for Entra ID') -Level Information -NoDateTime -NoLogLevel;

            # Launch interactive login.
            $null = Connect-AzAccount -AuthScope 'https://admin.microsoft.com' -WarningAction SilentlyContinue -ErrorAction Stop -InformationAction Continue -Force;

            # Throw exception.
            Write-CustomLog -Category 'Login' -Subcategory 'Azure' -Message ('Successfully connected to Azure') -Level Verbose;
        }
        # Something went wrong.
        catch
        {
            # Throw exception.
            throw ("Could not connect to Entra ID, exception is '{0}'" -f $_);
        }

        # Try to connect to Microsoft Teams.
        try
        {
            # Write to log.
            Write-CustomLog -Category 'Login' -Subcategory 'Microsoft Teams' -Message ('Trying to connect to Teams') -Level Verbose;
            Write-CustomLog -Message ('Microsoft Teams: Please provide your credentials for Teams') -Level Information -NoDateTime -NoLogLevel;

            # Launch interactive login.
            $null = Connect-MicrosoftTeams -WarningAction SilentlyContinue -ErrorAction Stop;

            # Throw exception.
            Write-CustomLog -Category 'Login' -Subcategory 'Microsoft Teams' -Message ('Successfully connected to Teams') -Level Verbose;
        }
        # Something went wrong.
        catch
        {
            # Throw exception.
            throw ("Could not connect to Teams, exception is '{0}'" -f $_);
        }

        # Get the current context.
        $azContext = Get-AzContext;

        # If there is not context, exit.
        if ($null -eq $azContext)
        {
            # Throw exception.
            throw ('Could not get Azure context');
        }

        # Try to connect to Exchange Online.
        try
        {
            # Write to log.
            Write-CustomLog -Category 'Login' -Subcategory 'Exchange Online' -Message ('Trying to connect to Exchange Online') -Level Verbose;
            Write-CustomLog -Message ('Exchange Online: Please provide your credentials for Exchange Online') -Level Information -NoDateTime -NoLogLevel;

            # Launch interactive login.
            $null = Connect-ExchangeOnline -UserPrincipalName $azContext.Account.Id -ShowBanner:$false -WarningAction SilentlyContinue -ErrorAction Stop;

            # Throw exception.
            Write-CustomLog -Category 'Login' -Subcategory 'Exchange Online' -Message ('Successfully connected to Exchange Online') -Level Verbose;
        }
        # Something went wrong.
        catch
        {
            # Throw exception.
            throw ("Could not connect to Exchange Online, exception is '{0}'" -f $_);
        }

        # Try to connect to Security and Compliance.
        try
        {
            # Write to log.
            Write-CustomLog -Category 'Login' -Subcategory 'Security and Compliance' -Message ('Trying to connect to Security and Compliance') -Level Verbose;
            Write-CustomLog -Message ('Security and Compliance: Please provide your credentials for Security and Compliance') -Level Information -NoDateTime -NoLogLevel;

            # Launch interactive login.
            $null = Connect-IPPSSession -UserPrincipalName $azContext.Account.Id -ShowBanner:$false -WarningAction SilentlyContinue -ErrorAction Stop;

            # Throw exception.
            Write-CustomLog -Category 'Login' -Subcategory 'Security and Compliance' -Message ('Successfully connected to Security and Compliance') -Level Verbose;
        }
        # Something went wrong.
        catch
        {
            # Throw exception.
            throw ("Could not connect to Security and Compliance, exception is '{0}'" -f $_);
        }

        # Get SharePoint URLs.
        $spoUrls = Get-SpoTenantUrl;

        # Get the Pnp.PowerShell application.
        $application = Get-EntraIdApplicationPnpPowerShell -DisplayName $script:PnPPowerShellApplicationName;

        # If no application was found.
        if ($null -eq $application)
        {
            # Try to register the application.
            try
            {
                # Write to log.
                Write-CustomLog -Category 'Login' -Subcategory 'SharePoint Online' -Message ('Trying to register application for PnP.PowerShell') -Level Verbose;
                Write-CustomLog -Message ('SharePoint Online: Please provide your credentials for PnP.PowerShell (global administrator)') -Level Information -NoDateTime -NoLogLevel;

                # Register the application.
                $null = Register-PnPEntraIDAppForInteractiveLogin -ApplicationName $script:PnPPowerShellApplicationName -Tenant $spoUrls.tenantUrl -SharePointDelegatePermissions 'AllSites.FullControl' -ErrorAction Stop 2>$null;
            }
            # Something went wrong.
            catch
            {
                # Throw exception.
                throw ("Could not register application for PnP.PowerShell, exception is '{0}'" -f $_);
            }

        }

        # Get the Pnp.PowerShell application.
        $application = Get-EntraIdApplicationPnpPowerShell -DisplayName $script:PnPPowerShellApplicationName;

        # Try to connect to SharePoint.
        try
        {
            # Write to log.
            Write-CustomLog -Category 'Login' -Subcategory 'SharePoint Online' -Message ('Trying to connect to SharePoint') -Level Verbose;
            Write-CustomLog -Message ('SharePoint Online: Again, please provide your credentials for SharePoint') -Level Information -NoDateTime -NoLogLevel;

            # Launch interactive login.
            $null = Connect-PnPOnline -ClientId $application.AppId -Interactive -Url $spoUrls.AdminUrl -WarningAction SilentlyContinue -ErrorAction Stop;

            # Throw exception.
            Write-CustomLog -Category 'Login' -Subcategory 'SharePoint Online' -Message ('Successfully connected to SharePoint') -Level Verbose;
        }
        # Something went wrong.
        catch
        {
            # Throw exception.
            throw ("Could not connect to SharePoint, exception is '{0}'" -f $_);
        }
    }
    END
    {
        # Write to log.
        Write-CustomLog -Category 'Login' -Message ('Completed login process to Microsoft') -Level Verbose;
    }
}