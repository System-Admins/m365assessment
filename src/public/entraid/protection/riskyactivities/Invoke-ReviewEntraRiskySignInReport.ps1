function Invoke-ReviewEntraRiskySignInReport
{
    <#
    .SYNOPSIS
        Review the Azure AD 'Risky sign-ins' report.
    .DESCRIPTION
        Return risky sign in report.
    .EXAMPLE
        Invoke-ReviewEntraRiskySignInReport;
    #>

    [CmdletBinding()]
    Param
    (
    )

    BEGIN
    {
        # URI.
        $uri = 'https://main.iam.ad.ext.azure.com/api/Security/RiskyUsers';

        # Body.
        $body = @{
            riskStates  = @(1, 4);
            riskLevels  = @(2, 1);
            riskDetails = @();
            userStatus  = @($false);
            sort        = @{
                field        = 'riskLastUpdatedDateTime';
                defaultOrder = $true;
            };
            pageSize    = 50;
        } | ConvertTo-Json;
    }
    PROCESS
    {
        # Invoke Entra ID API.
        $riskyUsers = Invoke-EntraIdIamApi -Uri $uri -Body $body -Method POST;
    }
    END
    {
        # If there is any risky users.
        if ($riskyUsers.items.count -gt 0)
        {
            # Return risky users.
            return $riskyUsers;
        }
    }
}