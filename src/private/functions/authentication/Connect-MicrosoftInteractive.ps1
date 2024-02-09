function Connect-MicrosoftInteractive
{
    <#
    .SYNOPSIS
        Login to various Microsoft services.
    .DESCRIPTION
        Connects to Microsoft Graph, Exchange Online and Azure.
    .EXAMPLE
        # Login to Microsoft Graph, Exchange Online and Azure.
        Connect-MicrosoftInteractive;
    .EXAMPLE
        # Disconnect first and then login to Microsoft Graph, Exchange Online and Azure.
        Connect-MicrosoftInteractive -Disconnect;
    #>
    [CmdletBinding()]
    Param
    (
        # If current connection should be disconnected.
        [Parameter(Mandatory = $false)]
        [switch]$Disconnect
    )
    BEGIN
    {
        # If we should disconnect.
        if ($true -eq $Disconnect)
        {
            # Write to log.
            Write-Log -Category 'Authentication' -Message ('Disconnecting from Entra ID, Exchange Online and Microsoft Graph (if connections exist)') -Level Debug;

            # Disconnect from all services.
            Disconnect-MgGraph -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
            Disconnect-ExchangeOnline -ErrorAction SilentlyContinue -WarningAction SilentlyContinue -Confirm:$false | Out-Null
            Disconnect-AzAccount -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | Out-Null
        }

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
        # Try to connect to Graph.
        try
        {
            # Write to log.
            Write-Log -Category 'Authentication' -Message ('Trying to connect to Microsoft Graph') -Level Debug;

            # Launch interactive login.
            Connect-MgGraph -Scopes $mgScopes -NoWelcome -ErrorAction Stop | Out-Null;

            # Throw execption.
            Write-Log -Category 'Authentication' -Message ('Successfully connected to Microsoft Graph') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Throw excpetion.
            Write-Log -Category 'Authentication' -Message ("Could not connect to Microsoft Graph, execption is '{0}'" -f $_) -Level Error;

            # Exit.
            exit 1;
        }

        # Get Microsoft Graph context.
        $mgContext = Get-MgContext;

        # Try to connect to Azure.
        try
        {
            # Write to log.
            Write-Log -Category 'Authentication' -Message ('Trying to connect to Azure') -Level Debug;

            # Launch interactive login.
            Connect-AzAccount -AccountId $mgContext.Account -ErrorAction Stop -Force| Out-Null;

            # Throw execption.
            Write-Log -Category 'Authentication' -Message ('Successfully connected to Azure') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Throw excpetion.
            Write-Log -Category 'Authentication' -Message ("Could not connect to Entra ID, execption is '{0}'" -f $_) -Level Error;

            # Exit.
            exit 1;
        }

        # Get the current context.
        $context = Get-AzContext;

        # Write to log.
        Write-Log -Category 'Authentication' -Message ('Connecting to Exchange Online') -Level Debug;

        # Connect to Exchange Online (interactive).
        Connect-ExchangeOnline -UserPrincipalName $context.Account.Id -ShowBanner:$false;

        # Write to log.
        Write-Log -Category 'Authentication' -Message ('Connecting to Security & Compliance') -Level Debug;

        # Connect to Security and Compliance (interactive).
        Connect-IPPSSession -UserPrincipalName $context.Account.Id -ShowBanner:$false;

        # Write to log.
        Write-Log -Category 'Authentication' -Message ('Connecting to SharePoint') -Level Debug;

        # Get SharePoint URLs.
        $spoUrls = Get-SpoUrl;

        # Connect to SharePoint Online (interactive).
        Connect-PnPOnline -Interactive -Url $spoUrls.AdminUrl;
    }
    END
    {
    }
}