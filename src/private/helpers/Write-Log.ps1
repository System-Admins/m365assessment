Function Write-Log
{
    <#
    .SYNOPSIS
       .
    .DESCRIPTION
       .
    .PARAMETER Message
        .
    .EXAMPLE
        .
    #>
    [CmdletBinding()]
    Param
    (
    
        # Message to write to log.
        [Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message,
    
        # (Optional) Path to log file.
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$Path,
        
        # (Optional) Log level.
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet('Error', 'Warning', 'Information', 'Debug')]
        [string]$Level = 'Information',
        
        # (Optional) If date and time should not be added to the log message.
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [switch]$NoDateTime,

        # (Optional) If the log message should not be appended to the log file.
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [switch]$NoAppend,

        # (Optional) If the log level should not be logged.
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [switch]$NoLogLevel,

        # (Optional) If the log message should not be output to the console.
        [Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true)]
        [switch]$NoConsole
    )
    
    BEGIN
    {
        # Store original preferences.
        $originalInformationPreference = $InformationPreference;
        $originalDebugPreference = $DebugPreference;
        $originalWarningPreference = $WarningPreference;

        # Output to file.
        [bool]$outputToFile = $false;
    }
    PROCESS
    { 
        # If log file path is specified.
        if (!([string]::IsNullOrEmpty($Path)))
        {
            # Output should be written to file.
            $outputToFile = $true;
            
            # If log file dont exist.
            if (!(Test-Path -Path $Path -PathType Leaf))
            {
                # Get folder path.
                [string]$folderPath = Split-Path -Path $Path -Parent;

                # If folder path dont exist.
                if (!(Test-Path -Path $folderPath -PathType Container))
                {
                    # Create folder path.
                    New-Item -Path $folderPath -ItemType Directory -Force | Out-Null;
                }

                # Create log file.
                New-Item -Path $Path -ItemType File -Force | Out-Null;
            }
            # If log file exist.
            else
            {
                # If log file should not be appended.
                if ($true -eq $NoAppend)
                {
                    # Clear log file.
                    Clear-Content -Path $Path -Force | Out-Null;
                }
            }
        }        

        # Construct log message.
        [string]$logMessage = '';

        # If date and time should be added to log message.
        if ($false -eq $NoDateTime)
        {
            # Add date and time to log message.
            $logMessage += ('[{0}]' -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'));
        }

        # If log level should be added to log message.
        if ($false -eq $NoLogLevel)
        {
            # Add log level to log message.
            $logMessage += ('[{0}]' -f $Level.ToUpper());
        }

        # Add message to log message.
        $logMessage += ('{0}' -f $Message);
  
        switch ($Level)
        {
            'Error'
            {
                Write-Error -Message $logMessage;
            }
            'Warning'
            {
                $WarningPreference = 'Continue';
                Write-Warning -Message $logMessage;
            }
            'Information'
            {
                $InformationPreference = 'Continue';
                Write-Information -MessageData $logMessage;
            }
            'Debug'
            {
                $DebugPreference = 'Continue';
                Write-Debug -Message $logMessage;
            }
        }

        # If output should be written to file.
        if ($true -eq $outputToFile)
        {
            # Construct splat parameters.
            $params = @{
                'Path'     = $Path;
                'Force'    = $true;
                'Encoding' = 'utf8';
            }

            # If log file should be appended.
            if ($false -eq $NoAppend)
            {
                # Add append parameter.
                $params.Add('Append', $true);
            }
            

            # Write log message to file.
            $logMessage | Out-File @params | Out-Null;
        }
    }
    END
    {
        # Restore original preferences.
        $InformationPreference = $originalInformationPreference;
        $DebugPreference = $originalDebugPreference;
        $WarningPreference = $originalWarningPreference;
    }
}

Write-Log -Message 'Hello world!' -Path '/Users/ath/log.txt' -Level Information;

Get-Content -Path '/Users/ath/log.txt';