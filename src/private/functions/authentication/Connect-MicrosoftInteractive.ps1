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
            Write-Log -Message ('Disconnecting from Entra ID, Exchange Online and Microsoft Graph (if connections exist)') -Level Debug;

            # Disconnect from all services.
            Disconnect-MgGraph -ErrorAction SilentlyContinue | Out-Null
            Disconnect-ExchangeOnline -ErrorAction SilentlyContinue -Confirm:$false | Out-Null
            Disconnect-AzAccount -ErrorAction SilentlyContinue | Out-Null
        }
    }
    PROCESS
    {
        

        # Try to connect to Azure.
        try
        {
            # Write to log.
            Write-Log -Message ('Trying to connect to Azure') -Level Debug;

            # Launch interactive login.
            Connect-AzAccount -ErrorAction Stop -Force | Out-Null;

            # Throw execption.
            Write-Log -Message ('Successfully connected to Azure') -Level Debug;
        }
        # Something went wrong.
        catch
        {
            # Write to log.
            Write-Log -Message ("Could not connect to Entra ID, execption is '{0}'" -f $_) -Level Error;
        }

        # Get the current context.
        $context = Get-AzContext;

        # Get access token.
        $mgAccessToken = Get-AzAccessToken -ResourceUrl 'https://graph.microsoft.com';

        # If the access token is null, then the user is not logged in.
        if ($null -eq $mgAccessToken)
        {
            # Throw execption.
            Write-Log -Message ('Could not get access token for Microsoft Graph') -Level Error;
        }

        # Write to log.
        Write-Log -Message ('Connecting to Microsoft Graph') -Level Debug;

        # Connect to Microsoft Graph (using existing token).
        Connect-MgGraph -AccessToken ($mgAccessToken.Token | ConvertTo-SecureString -AsPlainText -Force) -NoWelcome | Out-Null;

        # Write to log.
        Write-Log -Message ('Connecting to Exchange Online') -Level Debug;

        # Connect to Exchange Online (interactive).
        Connect-ExchangeOnline -UserPrincipalName $context.Account.Id -ShowBanner:$false;
    }
    END
    {
    }
}