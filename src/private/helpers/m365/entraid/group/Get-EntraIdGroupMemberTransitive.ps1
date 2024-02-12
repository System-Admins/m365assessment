function Get-EntraIdGroupMemberTransitive
{
    <#
    .SYNOPSIS
        Get members recursively from a group, and only return the users.
    .DESCRIPTION
        Return transitive users from a group.
    .NOTES
        Requires the following modules:
        - Microsoft.Graph.Authentication
    .EXAMPLE
        Get-EntraIdGroupMemberTransitive -Id '<group id>';
    #>
    [CmdletBinding()]
    Param
    (
        # Group ID.
        [Parameter(Mandatory = $true)]
        [Parameter(ParameterSetName = 'Id')]
        [ValidateNotNullOrEmpty()]
        [string]$Id
    )
    BEGIN
    {
        # URL to get transitive members.
        [string]$uri = ('https://graph.microsoft.com/beta/groups/{0}/transitiveMembers' -f $Id);
    }
    PROCESS
    {
        # Try to invoke API.
        try
        {
            # Write to log.
            Write-Log -Category 'Entra ID' -Message ("Trying to get members from group '{0}'" -f $Id) -Level Debug;

            # Get members.
            $response = Invoke-MgGraphRequest -Method Get -Uri $uri -OutputType PSObject -ErrorAction Stop;

            # Write to log.
            Write-Log -Category 'Entra ID' -Message ("Successfully got members from group '{0}'" -f $Id) -Level Debug;
        }
        # Something went wrong while getting members from group.
        catch
        {
            # Throw execption.
            Write-Log -Category 'Entra ID' -Message ("Something went wrong while getting members from group '{0}', exception is '{1}'" -f $Id, $_) -Level Error;
        }
    }
    END
    {
        # If there is any members.
        if ($null -ne $response.value)
        {
            # Return members.
            return $response.value;
        }
    }
}