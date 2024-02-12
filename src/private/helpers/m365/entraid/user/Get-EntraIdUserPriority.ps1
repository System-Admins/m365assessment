function Get-EntraIdUserPriority
{
    <#
    .SYNOPSIS
        Get priority users.
    .DESCRIPTION
        Return all priority users from Microsoft 365.
    .EXAMPLE
        Get-EntraIdUserPriority;
    #>
    [CmdletBinding()]
    Param
    (
    )
    BEGIN
    {
        # URL to the priority users API.
        [string]$uri = 'https://admin.microsoft.com/admin/api/users/GetPriorityUsers';

        # Body of the request.
        $body = @{
            SortDirection = 0;
            SortField = "PriorityUserDisplayName";
        };
    }
    PROCESS
    {
        # Invoke the API.
        $priorityUsers = Invoke-Office365ManagementApi -Uri $uri -Method 'POST' -Body $body;
    }
    END
    {
        # If the priority users is not null.
        if ($null -ne $priorityUsers.PriorityUsers)
        {
            # Return null.
            return $priorityUsers.PriorityUsers;
        }
    }
}