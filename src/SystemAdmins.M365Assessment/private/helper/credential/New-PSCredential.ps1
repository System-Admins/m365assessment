function New-PSCredential
{
    <#
    .SYNOPSIS
        Create a PSCredential object.
    .DESCRIPTION
        Take a username and password and create a PSCredential object.
    .PARAMETER Username
        Username to use in the PSCredential object.
    .PARAMETER Password
        Password to use in the PSCredential object.
    .EXAMPLE
        # Create a PSCredential object.
        $credential = New-PSCredential -Username 'myUsername' -Password 'myPassword';
    #>

    [cmdletbinding()]	
		
    param
    (
        [Parameter(Mandatory = $true)][string]$Username,
        [Parameter(Mandatory = $true)][string]$Password
    )

    # Write to log.
    Write-Log -Category 'Credential' -Message ("Creating credential for '{0}'" -f $Username) -Level Information;
 
    # Convert the password to a secure string.
    $securePassword = $Password | ConvertTo-SecureString -AsPlainText -Force;
 
    # Convert $Username and $SecurePassword to a credential object.
    $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $securePassword;
 
    # Return the credential object.
    return $credential;
}