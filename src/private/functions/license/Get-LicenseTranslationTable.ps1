function Get-LicenseTranslationTable
{
    <#
    .SYNOPSIS
        Get license translation file from Microsoft.
    .DESCRIPTION
        Get service plan license translation file from Microsoft and return it as a object array.
    .EXAMPLE
        # Get license translation file from Microsoft.
        $licenseTranslation = Get-LicenseTranslationTable;
    #>

    [cmdletBinding()]
    param
    (
        
    )
    BEGIN
    {
        # URL to translation table CSV (find the URL here https://learn.microsoft.com/en-us/entra/identity/users/licensing-service-plan-reference).
        $translationTableUrl = 'https://download.microsoft.com/download/e/3/e/e3e9faf2-f28b-490a-9ada-c6089a1fc5b0/Product%20names%20and%20service%20plan%20identifiers%20for%20licensing.csv';
    }
    PROCESS
    {
        # Try to get translation table.
        try
        {
            # Write to log.
            Write-Log -Message ("Downloading license translation from '{0}'" -f $translationTableUrl) -Level Debug;

            # Get translation table.
            $translationTableCsv = Invoke-RestMethod -Method Get -Uri $translationTableUrl -ContentType 'application/csv; charset=utf-8' -ErrorAction Stop;

            # Convert from CSV to object array.
            $translationTable = $translationTableCsv | ConvertFrom-Csv -ErrorAction Stop;
        }
        # Something went wrong while getting the translation table.
        catch
        {
            # Throw execption.
            Write-Log -Message ('Something went wrong while getting license translation. Exception is: {0}' -f $_) -Level Error;
        }
    }
    END
    {
        # If translation table is not empty.
        if (! [string]::IsNullOrEmpty($translationTable))
        {
            # Return the translation table.
            return $translationTable;
        }
    }
}