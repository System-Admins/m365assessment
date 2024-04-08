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

    [cmdletbinding()]
    param
    (
    )

    BEGIN
    {
        # Write progress.
        Write-Progress -Activity $MyInvocation.MyCommand -Status 'Running' -CurrentOperation $MyInvocation.MyCommand.Name -PercentComplete -1 -SecondsRemaining -1;

        # Dates.
        $startDate = (Get-Date).AddDays(-7);
        $endDate = (Get-Date).AddHours(-1);

        # URI.
        $uri = ('https://graph.microsoft.com/beta/auditLogs/signIns?api-version=beta&$filter=(createdDateTime%20ge%20{0}%20and%20createdDateTime%20lt%20{1}%20and%20(riskState%20eq%20%27atRisk%27%20or%20riskState%20eq%20%27confirmedCompromised%27)%20and%20(signInEventTypes/any(t:%20t%20eq%20%27interactiveUser%27)%20or%20signInEventTypes/any(t:%20t%20eq%20%27nonInteractiveUser%27)))&$top=50&$orderby=createdDateTime%20desc' -f $startDate.ToString('yyyy-MM-ddTHH:mm:ss.fffZ', [CultureInfo]::InvariantCulture), $endDate.ToString('yyyy-MM-ddTHH:mm:ss.fffZ', [CultureInfo]::InvariantCulture));

    }
    PROCESS
    {
        # Try to invoke API.
        try
        {
            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'Protection' -Message ('Getting risky sign-in report') -Level Verbose;

            # Invoke Microsoft Graph API.
            $riskySignIns = Invoke-MgGraphRequest -Uri $uri -Method Get -ErrorAction Stop;

            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'Protection' -Message ('Successfully got risky sign-in report') -Level Verbose;
        }
        # Something went wrong.
        catch
        {
            # Write to log.
            Write-CustomLog -Category 'Entra' -Subcategory 'Protection' -Message ('Failed to get risky sign-in report') -Level Verbose;

            # Return.
            return;
        }
    }
    END
    {
        # Bool for review flag.
        [bool]$reviewFlag = $false;

        # If review flag should be set.
        if ($riskySignIns.value.Count -gt 0)
        {
            # Should be reviewed.
            $reviewFlag = $true;
        }

        # Create new review object to return.
        [Review]$review = [Review]::new();

        # Add to object.
        $review.Id = 'ff9b1c25-464c-4c6a-a469-10aab9470e4c';
        $review.Category = 'Microsoft Entra Admin Center';
        $review.Subcategory = 'Protection';
        $review.Title = "Ensure the Azure AD 'Risky sign-ins' report is reviewed at least weekly";
        $review.Data = $riskySignIns.value | Select-Object createdDateTime, userPrincipalName, ipAddress, @{Name = 'location'; Expression = { ('{0}, {1}, {2}' -f $_.location.city, $_.location.state, $_.location.countryOrRegion) } }, riskState, riskLevelDuringSignIn;
        $review.Review = $reviewFlag;

        # Print result.
        $review.PrintResult();

        # Return object.
        return $review;
    }
}