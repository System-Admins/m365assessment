# Modules used by the this module.
$script:Modules = [PSCustomObject]@{
    'Microsoft.Graph.Authentication'                    = 'latest';
    'Microsoft.Graph.Applications'                      = 'latest';
    'Microsoft.Graph.Groups'                            = 'latest';
    'Microsoft.Graph.Users'                             = 'latest';
    'Microsoft.Graph.Identity.DirectoryManagement'      = 'latest';
    'Microsoft.Graph.Identity.SignIns'                  = 'latest';
    'Microsoft.Graph.Identity.Governance'               = 'latest';
    'Microsoft.Graph.Beta.Identity.DirectoryManagement' = 'latest';
    'Microsoft.Graph.Beta.Reports'                      = 'latest';
    'Microsoft.Graph.Reports'                           = 'latest';
    'Az.Accounts'                                       = 'latest';
    'Az.Resources'                                      = 'latest';
    'ExchangeOnlineManagement'                          = 'latest';
    'PnP.PowerShell'                                    = 'latest';
    'MicrosoftTeams'                                    = 'latest';
};

# Temp path.
$script:TempPath = [io.path]::GetTempPath();

# PnP PowerShell settings.
$script:PnPPowerShellApplicationName = 'SystemAdmins.M365Assessment.PnPPowerShell';