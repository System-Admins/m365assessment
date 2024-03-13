function Invoke-Review
{
    <#
    .SYNOPSIS
        Invokes all the review functions and returns the list of review objects.
    .DESCRIPTION
        Returns list of review objects.
    .PARAMETER Service
        The service to review.
    .PARAMETER ReturnReviews
        If the reviews should be returned.
    .EXAMPLE
        # Run all the review functions.
        Invoke-Review;
    .EXAMPLE
        # Run all the review functions for Microsoft 365 Admin Center.
        Invoke-Review -Service m365admin;
    #>

    [cmdletbinding()]
    param
    (
        # What services to review.
        [Parameter(Mandatory = $false)]
        [ValidateSet(
            'm365admin', # Microsoft 365 Admin Center
            'm365defender', # Microsoft Defender
            'm365purview', # Microsoft Purview
            'm365entra', # Microsoft Entra
            'm365exchange', # Microsoft Exchange Online
            'm365sharepoint', # Microsoft SharePoint Online
            'm365teams', # Microsoft Teams
            'm365fabric' # Microsoft Fabric
        )]
        [string[]]$Service = @()
    )

    BEGIN
    {
        # Write to log.
        Write-Log -Category 'Review' -Message ('Starting the review process') -Level Debug;

        # Object array storing all the reviews.
        $reviews = New-Object System.Collections.ArrayList;

        # Get licenses.
        $licenses = Get-LicenseTenant;
    }
    PROCESS
    {
        # If "Microsoft 365 Admin Center" is selected.
        if ($Service -contains 'm365admin' -or $Service.Count -eq 0)
        {
            # 1. Microsoft 365 Admin Center
            # 1.1 Users
            # 1.1.1 Ensure Administrative accounts are separate and cloud-only.
            # 289efa41-e17f-43e7-a6b8-9ff8868d3511
            $null = $reviews.Add((Invoke-ReviewEntraAdminAccountCloudOnly));

            # 1. Microsoft 365 Admin Center 
            # 1.1 Users
            # 1.1.3 Ensure that between two and four global admins are designated.
            # d106f228-2f57-4009-a4c1-8d309a97c4f3
            $null = $reviews.Add((Invoke-ReviewEntraNumberOfGlobalAdmins));

            # 1. Microsoft 365 Admin Center
            # 1.1 Users
            # 1.1.4 Ensure Guest Users are reviewed and approved.
            # 7fe4d30e-42bd-44d4-8066-0b732dcbda4c
            $null = $reviews.Add((Invoke-ReviewEntraGuestUsers));

            # 1. Microsoft 365 Admin Center
            # 1.2 Teams and groups
            # 1.2.1 Ensure that only organizationally managed/approved public groups exist.
            # 90295b64-2528-4c22-aa96-a606633bc705
            $null = $reviews.Add((Invoke-ReviewEntraPublicGroup));

            # Run only if the license is available.
            if ($licenses | Where-Object { $_.ServicePlanDisplayName -like 'Microsoft Entra ID P*' })
            {
                # 1. Microsoft 365 Admin Center
                # 1.2 Teams and groups
                # 1.2.2 Ensure sign-in to shared mailboxes is blocked.
                # dc6727fe-333d-46ad-9ad6-f9b0ae23d03b
                $null = $reviews.Add((Invoke-ReviewEntraSharedMailboxSignInAllowed));
            }

            # 1. Microsoft 365 Admin Center
            # 1.3 Settings
            # 1.3.1 Ensure the 'Password expiration policy' is set to 'Set passwords to never expire (recommended)'.
            # 7ccac596-ee68-4f28-abe7-713c2b75a39e
            $null = $reviews.Add((Invoke-ReviewEntraIdPasswordPolicy));

            # 1. Microsoft 365 Admin Center
            # 1.3 Settings
            # 1.3.2 Ensure 'Idle session timeout' is set to '3 hours (or less)' for unmanaged devices.
            # 645b1886-5437-43e5-8b8a-84c033173ff3
            $null = $reviews.Add((Invoke-ReviewEntraIdIdleSessionTimeout));

            # 1. Microsoft 365 Admin Center
            # 1.3 Settings
            # 1.3.3 Ensure 'External sharing' of calendars is not available.
            # 489b0b3d-cf78-46a5-8366-84908dc05d5a
            $null = $reviews.Add((Invoke-ReviewExoCalendarExternalSharing));

            # 1. Microsoft 365 Admin Center
            # 1.3 Settings
            # 1.3.4 Ensure 'User owned apps and services' is restricted.
            # 59a56832-8e8f-42ef-b03c-3a147059fe6f
            $null = $reviews.Add((Invoke-ReviewTenantUserOwnedAppsService));

            # 1. Microsoft 365 Admin Center
            # 1.3 Settings
            # 1.3.5 Ensure internal phishing protection for Forms is enabled.
            # 229fc460-ec0c-4e88-89db-0b8a883ba3e0
            $null = $reviews.Add((Invoke-ReviewFormsPhishingProtection));

            # 1. Microsoft 365 Admin Center
            # 1.3 Settings
            # 1.3.6 Ensure the customer lockbox feature is enabled.
            # f4cf24ca-cd8f-4ded-bfe0-6f45f3bcfed0
            $null = $reviews.Add((Invoke-ReviewTenantCustomerLockEnabled));

            # 1. Microsoft 365 Admin Center
            # 1.3 Settings
            # 1.3.7 Ensure 'third-party storage services' are restricted in 'Microsoft 365 on the web'.
            # 54b612c6-5306-45d4-b948-f3e75e09ab3b
            $null = $reviews.Add((Invoke-ReviewTenantThirdPartyStorage));

            # 1. Microsoft 365 Admin Center
            # 1.3 Settings
            # 1.3.8 Ensure that Sways cannot be shared with people outside of your organization.
            # d10b85ac-05df-4c78-91a5-5bc03f799ea2
            $null = $reviews.Add((Invoke-ReviewTenantSwayExternalSharing));
        }

        # If "Microsoft Defender" is selected.
        if ($Service -contains 'm365defender' -or $Service.Count -eq 0)
        {
            # Run only if the license is available.
            if ($licenses | Where-Object { $_.ServicePlanDisplayName -like 'Microsoft Defender for Office 365*' })
            {
                # 2. Microsoft 365 Defender
                # 2.1 Email and collaboration
                # 2.1.1 Ensure Safe Links for Office Applications is Enabled.
                # b29a3b32-4042-4ce6-86f6-eb85b183b4b5
                $null = $reviews.Add((Invoke-ReviewDefenderSafeLinksPolicyOfficeApps));

                # 2. Microsoft 365 Defender
                # 2.1 Email and collaboration
                # 2.1.2 Ensure the Common Attachment Types Filter is enabled.
                # fd660655-99e8-4cbe-93a2-9fa3c5e34f40
                $null = $reviews.Add((Invoke-ReviewDefenderMalwareCommonAttachmentTypesFilter));
            }

            # 2. Microsoft 365 Defender
            # 2.1 Email and collaboration
            # 2.1.3 Ensure notifications for internal users sending malware is Enabled.
            # 01f7327e-f8cf-4542-b12a-41b40d03415d
            $null = $reviews.Add((Invoke-ReviewDefenderMalwareInternalUserNotifications));

            # Run only if the license is available.
            if ($licenses | Where-Object { $_.ServicePlanDisplayName -like 'Microsoft Defender for Office 365*' })
            {
                # 2. Microsoft 365 Defender
                # 2.1 Email and collaboration
                # 2.1.4 Ensure Safe Attachments policy is enabled.
                # 383ea8f2-48e1-4a1f-bcc7-626fbeb0f331
                $null = $reviews.Add((Invoke-ReviewDefenderSafeAttachmentPolicyEnabled));

                # 2. Microsoft 365 Defender
                # 2.1 Email and collaboration
                # 2.1.5 Ensure Safe Attachments for SharePoint, OneDrive, and Microsoft Teams is Enabled.
                # a4fb003f-b742-4a97-8a9a-c4e5a82171a4
                $null = $reviews.Add((Invoke-ReviewDefenderSafeAttachmentPolicyEnabledForApps));
            }

            # 2. Microsoft 365 Defender
            # 2.1 Email and collaboration
            # 2.1.6 Ensure Exchange Online Spam Policies are set to notify administrators.
            # a019303a-3b0a-4f42-999d-0d76b528ae28
            $null = $reviews.Add((Invoke-ReviewDefenderAntiSpamNotifyAdmins));

            # 2. Microsoft 365 Defender
            # 2.1 Email and collaboration
            # 2.1.7 Ensure that an anti-phishing policy has been created.
            # 13954bef-f9cd-49f8-b8c8-626e87de6ba2
            $null = $reviews.Add((Invoke-ReviewDefenderAntiPhishingPolicy));

            # 2. Microsoft 365 Defender
            # 2.1 Email and collaboration
            # 2.1.8 Ensure that SPF records are published for all Exchange Domains.
            # 9be729e4-0378-4c2c-afa1-92b2af71c4e9
            $null = $reviews.Add((Invoke-ReviewDefenderEmailDomainSpf));

            # 2. Microsoft 365 Defender
            # 2.1 Email and collaboration
            # 2.1.9 Ensure that DKIM is enabled for all Exchange Online Domains.
            # 92adb77c-a12b-4dee-8ce8-2b5f748f22ec
            $null = $reviews.Add((Invoke-ReviewDefenderEmailDomainDkim));

            # 2. Microsoft 365 Defender
            # 2.1 Email and collaboration
            # 2.1.10 Ensure DMARC Records for all Exchange Online domains are published.
            # 7f46d070-097f-4a6b-aad1-118b5b707f41
            $null = $reviews.Add((Invoke-ReviewDefenderEmailDomainDmarc));

            # 2. Microsoft 365 Defender
            # 2.1 Email and collaboration
            # 2.1.11 Ensure the spoofed domains report is reviewed weekly.
            # c7d90aa7-bcb3-403c-96f4-bc828e6246ff
            $null = $reviews.Add((Invoke-ReviewDefenderEmailSpoofSenders));

            # 2. Microsoft 365 Defender
            # 2.1 Email and collaboration
            # 2.1.12 Ensure the 'Restricted entities' report is reviewed weekly.
            # 86bab3de-8bac-442f-8495-496bd1ed75b9
            $null = $reviews.Add((Invoke-ReviewEmailRestrictedSenders));

            # Run only if the license is available.
            if ($licenses | Where-Object { $_.ServicePlanDisplayName -eq 'Microsoft Defender for Office 365 (Plan 2)' })
            {
                # 2. Microsoft 365 Defender
                # 2.3 Audit
                # 2.3.1 Ensure the Account Provisioning Activity report is reviewed at least weekly.
                # 3483e87b-6069-4355-928f-dc9be4e31902
                $null = $reviews.Add((Invoke-ReviewDefenderAccountProvisioningActivity));
            }

            # 2. Microsoft 365 Defender
            # 2.3 Audit
            # 2.3.2 Ensure non-global administrator role group assignments are reviewed at least weekly.
            # 8104752c-9e07-4a61-99a1-7161a792d76e
            $null = $reviews.Add((Invoke-ReviewDefenderNonGlobalAdminRoleAssignment));

            # Run only if the license is available.
            if ($licenses | Where-Object { $_.ServicePlanDisplayName -eq 'Microsoft Defender for Office 365 (Plan 2)' })
            {
                # 2. Microsoft 365 Defender
                # 2.4 Settings
                # 2.4.1 Ensure Priority account protection is enabled and configured.
                # 749ee441-71ea-4261-86da-1f1081c65bb3
                $null = $reviews.Add((Invoke-ReviewDefenderPriorityAccountProtectionConfig));

                # 2. Microsoft 365 Defender
                # 2.4 Settings
                # 2.4.2 Ensure Priority accounts have 'Strict protection' presets applied.
                # 9780f1b2-e2ea-4f6e-9bd9-7eb551b5d1e7
                $null = $reviews.Add((Invoke-ReviewDefenderPriorityAccountStrictPolicy));
            }
        }

        # If "Microsoft Purview" is selected.
        if ($Service -contains 'm365purview' -or $Service.Count -eq 0)
        {
            # 3. Microsoft Purview
            # 3.1 Audit
            # 3.1.1 Ensure Microsoft 365 audit log search is Enabled.
            # 55299518-ad01-4532-aa35-422fd962c881
            $null = $reviews.Add((Invoke-ReviewPurviewUnifiedAuditLogIsEnabled));

            # 3. Microsoft Purview
            # 3.1 Audit
            # 3.1.2 Ensure Microsoft 365 audit log search is Enabled.
            # 6fe596b2-1ee0-46e1-9dba-316d1888d016
            $null = $reviews.Add((Invoke-ReviewPurviewUserRoleGroupChanges));

            # Run only if the license is available.
            if ($licenses | Where-Object {
                    $_.ServicePlanDisplayName -eq 'Microsoft Communications DLP' -or
                    $_.ServicePlanDisplayName -eq 'Data Loss Prevention'
                })
            {
                # 3. Microsoft Purview
                # 3.2 Data Loss Prevention (DLP)
                # 3.2.1 Ensure DLP policies are enabled.
                # b9caf88c-0c9c-42a8-b6be-14953a8b76c3
                $null = $reviews.Add((Invoke-ReviewPurviewDlpPolicyEnabled));

                # 3. Microsoft Purview
                # 3.2 Data Loss Prevention (DLP)
                # 3.2.2 Ensure DLP policies are enabled for Microsoft Teams.
                # 48d970b5-a31b-41e9-9d66-eb8e02e0546d
                $null = $reviews.Add((Invoke-ReviewPurviewDlpTeamsPolicyEnabled));
            }

            # 3. Microsoft Purview
            # 3.3 Information Protection
            # 3.3.1 Ensure SharePoint Online Information Protection policies are set up and used.
            # b01a1187-5921-4b29-95fd-73e1af3c5285
            $null = $reviews.Add((Invoke-ReviewPurviewInformationProtectionLabelPolicy));
        }

        # If "Microsoft Entra" is selected.
        if ($Service -contains 'm365entra' -or $Service.Count -eq 0)
        {
            # 5. Microsoft Entra Admin Center
            # 5.1 Identity
            # 5.1.1 Overview.
            # 5.1.1.1 Ensure Security Defaults is disabled on Azure Active Directory.
            # bf8c7733-8ec0-4c86-9c4e-28bf4812a57a
            $null = $reviews.Add((Invoke-ReviewEntraSecurityDefaultEnabled));

            # 5. Microsoft Entra Admin Center
            # 5.1 Identity
            # 5.1.2 Users
            # 5.1.2.2 Ensure third-party integrated applications are not allowed.
            # 3caa1bff-bce3-4744-8898-00b0ebc49ff7
            $null = $reviews.Add((Invoke-ReviewEntraUsersCanRegisterAppsEnabled));

            # 5. Microsoft Entra Admin Center
            # 5.1 Identity
            # 5.1.2 Users
            # 5.1.2.3 Ensure 'Restrict non-admin users from creating tenants' is set to 'Yes'.
            # bf785c94-b3b4-4b1b-bf90-55031fdba42c
            $null = $reviews.Add((Invoke-ReviewEntraUsersAllowedToCreateTenants));

            # 5. Microsoft Entra Admin Center
            # 5.1 Identity
            # 5.1.2 Users
            # 5.1.2.4 Ensure 'Restrict access to the Azure AD administration portal' is set to 'Yes'.
            # 591c821b-52ca-48f3-806e-56a98d25c041
            $null = $reviews.Add((Invoke-ReviewEntraRestrictNonAdminUsersAdminPortal));

            # 5. Microsoft Entra Admin Center
            # 5.1 Identity
            # 5.1.2 Users
            # 5.1.2.5 Ensure the option to remain signed in is hidden.
            # 08798711-af3c-4fdc-8daf-947b050dca95
            $null = $reviews.Add((Invoke-ReviewEntraHideKeepMeSignedIn));

            # 5. Microsoft Entra Admin Center
            # 5.1 Identity
            # 5.1.2 Users
            # 5.1.2.6 Ensure 'LinkedIn account connections' is disabled.
            # 23d22457-f5e2-4f55-9aba-e483e8cbb11d
            $null = $reviews.Add((Invoke-ReviewEntraBlockLinkedInConnection));

            # 5. Microsoft Entra Admin Center
            # 5.1 Identity
            # 5.1.3 Groups
            # 5.1.3.6 Ensure a dynamic group for guest users is created.
            # a15e2ff5-2a03-495d-a4f2-4935742395d5
            $null = $reviews.Add((Invoke-ReviewEntraGuestDynamicGroup));

            # Run only if the license is available.
            if ($licenses | Where-Object { $_.ServicePlanDisplayName -like 'Microsoft Entra ID P*' })
            {
                # 5. Microsoft Entra Admin Center
                # 5.1 Identity
                # 5.1.5 Applications
                # 5.1.5.1 Ensure the Application Usage report is reviewed at least weekly.
                # 95d55daa-d432-44f5-907a-eda61b57696f
                $null = $reviews.Add((Invoke-ReviewEntraApplicationUsageReport));
            }

            # 5. Microsoft Entra Admin Center
            # 5.1 Identity
            # 5.1.5 Applications
            # 5.1.5.2 Ensure user consent to apps accessing company data on their behalf is not allowed.
            # ca409d22-6638-48ff-ad7c-4a61e3488b94
            $null = $reviews.Add((Invoke-ReviewEntraApplicationUserConsent));

            # 5. Microsoft Entra Admin Center
            # 5.1 Identity
            # 5.1.5 Applications
            # 5.1.5.3 Ensure the admin consent workflow is enabled.
            # 7bd57849-e98c-48c0-bd98-5c337fb7bc32
            $null = $reviews.Add((Invoke-ReviewEntraApplicationAdminConsentWorkflowEnabled));

            # 5. Microsoft Entra Admin Center
            # 5.1 Identity
            # 5.1.5 External Identities
            # 5.1.6.1 Ensure that collaboration invitations are sent to allowed domains only.
            # 54848e5b-7bb0-4a70-aeb1-63a1e54562d6
            $null = $reviews.Add((Invoke-ReviewEntraExternalCollaborationDomains));

            # 5. Microsoft Entra Admin Center
            # 5.1 Identity
            # 5.1.8 Hybrid Management
            # 5.1.8.1 Ensure that password hash sync is enabled for hybrid deployments.
            # ac82d275-9102-4df6-bf3c-ca012a74a306
            $null = $reviews.Add((Invoke-ReviewEntraHybridPasswordHashSync));

            # 5. Microsoft Entra Admin Center
            # 5.2 Protection
            # 5.2.3 Authentication Methods
            # 5.2.3.1 Ensure Microsoft Authenticator is configured to protect against MFA fatigue.
            # 0c1ccf40-64f3-4300-96e4-2f7f3272bf9a
            $null = $reviews.Add((Invoke-ReviewEntraAuthMethodMfaFatigue));

            # 5. Microsoft Entra Admin Center
            # 5.2 Protection
            # 5.2.3 Authentication Methods
            # 5.2.3.2 Ensure custom banned passwords lists are used.
            # bb23f25a-0c03-4607-a232-ef8902a0a899
            $null = $reviews.Add((Invoke-ReviewEntraAuthMethodCustomPasswordListEnforced));

            # 5. Microsoft Entra Admin Center
            # 5.2 Protection
            # 5.2.3 Authentication Methods
            # 5.2.3.3 Ensure password protection is enabled for on-prem Active Directory.
            # ee6975f8-842f-4096-a8a7-0ad093db82c0
            $null = $reviews.Add((Invoke-ReviewEntraAuthMethodPasswordProtectionOnPremAD));

            # 5. Microsoft Entra Admin Center
            # 5.2 Protection
            # 5.2.4 Password reset
            # 5.2.4.1 Ensure 'Self service password reset enabled' is set to 'All'.
            # 2425f84f-76cf-441b-891e-86142f14ff9e
            $null = $reviews.Add((Invoke-ReviewEntraSsprEnabledForAll));

            # 5. Microsoft Entra Admin Center
            # 5.2 Protection
            # 5.2.4 Password reset
            # 5.2.4.2 Ensure the self-service password reset activity report is reviewed at least weekly.
            # 9141c4a0-0323-4aa3-abb5-e6a0a2bedffa
            $null = $reviews.Add((Invoke-ReviewEntraPasswordResetAudit));

            # 5. Microsoft Entra Admin Center
            # 5.2 Protection
            # 5.2.6 Risky Activities
            # 5.2.6.1 Ensure the Azure AD 'Risky sign-ins' report is reviewed at least weekly.
            # ff9b1c25-464c-4c6a-a469-10aab9470e4c
            $null = $reviews.Add((Invoke-ReviewEntraRiskySignInReport));

            # Run only if the license is available.
            if ($licenses | Where-Object {
                    $_.ServicePlanDisplayName -eq 'Microsoft Entra ID P2' -or
                    $_.ServicePlanDisplayName -eq 'Entra Identity Governance'
                })
            {
                # 5. Microsoft Entra Admin Center
                # 5.3 Identity Governance
                # 5.3.1 Ensure 'Privileged Identity Management' is used to manage roles.
                # 99dcdd37-60f6-450e-be03-13a85fcc5776
                $null = $reviews.Add((Invoke-ReviewEntraPimUsedToManageRoles));

                # 5. Microsoft Entra Admin Center
                # 5.3 Identity Governance
                # 5.3.2 Ensure 'Access reviews' for Guest Users are configured.
                # 03a57762-4613-47fc-835d-5a5c3d0dbe61
                $null = $reviews.Add((Invoke-ReviewEntraAccessReviewGuestUsers));

                # 5. Microsoft Entra Admin Center
                # 5.3 Identity Governance
                # 5.3.3 Ensure 'Access reviews' for high privileged Azure AD roles are configured.
                # e8c91221-63d2-4797-8a86-7ef53c30a9d6
                $null = $reviews.Add((Invoke-ReviewEntraAccessReviewPrivilegedRoles));
            }
        }

        # If "Microsoft Exchange Online" is selected.
        if ($Service -contains 'm365exchange' -or $Service.Count -eq 0)
        {
            # 6. Microsoft Exchange Admin Center
            # 6.1 Audit
            # 6.1.1 Ensure 'AuditDisabled' organizationally is set to 'False'.
            # 7cf11de7-eeb9-4e96-b406-7e69c232a9c0
            $null = $reviews.Add((Invoke-ReviewExoAuditEnabled));

            # 6. Microsoft Exchange Admin Center
            # 6.1 Audit
            # 6.1.2 / 6.1.3 Ensure mailbox auditing for users is Enabled.
            # 2b849f34-8991-4a13-a6f1-9f7d0ea4bcef
            $null = $reviews.Add((Invoke-ReviewExoMailboxAuditEnabled));

            # 6. Microsoft Exchange Admin Center
            # 6.1 Audit
            # 6.1.4 Ensure 'AuditBypassEnabled' is not enabled on mailboxes.
            # a2c3a619-df82-4e0b-ac98-47ff51ea8c2a
            $null = $reviews.Add((Invoke-ReviewExoMailboxAuditBypassDisabled));

            # 6. Microsoft Exchange Admin Center
            # 6.2 Mail flow
            # 6.2.1 Ensure all forms of mail forwarding are blocked and/or disabled.
            # 45887263-5f2f-4306-946d-8f36acfb3691
            $null = $reviews.Add((Invoke-ReviewExoMailForwardDisabled));

            # 6. Microsoft Exchange Admin Center
            # 6.2 Mail flow
            # 6.2.2 Ensure mail transport rules do not whitelist specific domains.
            # 8bf19b9f-7c76-4cb6-8d9a-2a327db4d7d3
            $null = $reviews.Add((Invoke-ReviewExoTransportRuleWhitelistSpecificDomains));

            # 6. Microsoft Exchange Admin Center
            # 6.2 Mail flow
            # 6.2.3 Ensure email from external senders is identified.
            # a73f7dd0-6c32-44d1-ae18-197b775e28bb
            $null = $reviews.Add((Invoke-ReviewExoIdentifiedExternalSenders));

            # 6. Microsoft Exchange Admin Center
            # 6.3 Roles
            # 6.3.1 Ensure users installing Outlook add-ins is not allowed.
            # 36ee88d3-0ab8-41ea-90e7-fd9b14ed6a03
            $null = $reviews.Add((Invoke-ReviewExoOutlookAddinsIsNotAllowedRolePolicy));

            # 6. Microsoft Exchange Admin Center
            # 6.4 Reports
            # 6.4.1 Ensure mail forwarding rules are reviewed at least weekly.
            # b2798cfb-c5cc-41d4-9309-d1bd932a4a91
            $null = $reviews.Add((Invoke-ReviewExoMailForwardRules));

            # 6. Microsoft Exchange Admin Center
            # 6.5 Settings
            # 6.5.1 Ensure modern authentication for Exchange Online is enabled.
            # bd574cc3-88f8-4ce5-9b0c-5c9982c2de10
            $null = $reviews.Add((Invoke-ReviewExoModernAuthEnabled));

            # 6. Microsoft Exchange Admin Center
            # 6.5 Settings
            # 6.5.2 Ensure MailTips are enabled for end users.
            # bed51aa7-e6de-4542-96fc-ffe9d699763c
            $null = $reviews.Add((Invoke-ReviewExoMailTips));

            # 6. Microsoft Exchange Admin Center
            # 6.5 Settings
            # 6.5.3 Ensure additional storage providers are restricted in Outlook on the web.
            # d576ebed-fe29-44a7-9fdf-bb8b3c484894
            $null = $reviews.Add((Invoke-ReviewExoStorageProvidersRestricted));
        }

        # If "Microsoft SharePoint Online" is selected.
        if ($Service -contains 'm365sharepoint' -or $Service.Count -eq 0)
        {
            # 7. Microsoft SharePoint Admin Center
            # 7.2 Policies
            # 7.2.1 Ensure modern authentication for SharePoint applications is required.
            # a8f1139f-9e08-4da9-bfea-1ddd811e6d68
            $null = $reviews.Add((Invoke-ReviewSpoLegacyAuthEnabled));

            # 7. Microsoft SharePoint Admin Center
            # 7.2 Policies
            # 7.2.2 Ensure SharePoint and OneDrive integration with Azure AD B2B is enabled.
            # 68e99561-878a-4bcd-bce1-d69a6c0e2282
            $null = $reviews.Add((Invoke-ReviewSpoEntraIdB2B));

            # 7. Microsoft SharePoint Admin Center
            # 7.2 Policies
            # 7.2.3 Ensure external content sharing is restricted.
            # f30646cc-e1f1-42b5-a3a5-4d46db01e822
            $null = $reviews.Add((Invoke-ReviewSpoExternalSharingRestricted));

            # 7. Microsoft SharePoint Admin Center
            # 7.2 Policies
            # 7.2.4 Ensure OneDrive content sharing is restricted.
            # fcf37f2f-6b1d-4616-85cd-0b5b33d8f028
            $null = $reviews.Add((Invoke-ReviewOneDriveSharingCapability));

            # 7. Microsoft SharePoint Admin Center
            # 7.2 Policies
            # 7.2.5 Ensure that SharePoint guest users cannot share items they don't own.
            # 1a27642f-0ab9-46ba-8d26-8e14a5b52994
            $null = $reviews.Add((Invoke-ReviewSpoGuestResharingRestricted));

            # 7. Microsoft SharePoint Admin Center
            # 7.2 Policies
            # 7.2.6 Ensure SharePoint external sharing is managed through domain whitelist/blacklists.
            # 2c6d9aa6-0698-468d-8b0f-8d40ba5daa7b
            $null = $reviews.Add((Invoke-ReviewSpoDomainSharingControl));

            # 7. Microsoft SharePoint Admin Center
            # 7.2 Policies
            # 7.2.7 Ensure link sharing is restricted in SharePoint and OneDrive.
            # c4b93e39-d8a1-459e-835e-e4545418c633
            $null = $reviews.Add((Invoke-ReviewSpoExternalLinkSharingRestricted));

            # 7. Microsoft SharePoint Admin Center
            # 7.2 Policies
            # 7.2.8 Ensure external sharing is restricted by security group.
            # d62a22ba-144b-44e6-8592-9e3692742a89
            $null = $reviews.Add((Invoke-ReviewSpoExternalSharingRestrictedGroup));

            # 7. Microsoft SharePoint Admin Center
            # 7.2 Policies
            # 7.2.9 Ensure guest access to a site or OneDrive will expire automatically.
            # af231488-4ca8-4496-8d10-09b65110d1ee
            $null = $reviews.Add((Invoke-ReviewSpoGuestAccessExpire));

            # 7. Microsoft SharePoint Admin Center
            # 7.2 Policies
            # 7.2.10 Ensure reauthentication with verification code is restricted.
            # 82712a94-8427-4871-8d09-f2b94e8e1bf1
            $null = $reviews.Add((Invoke-ReviewSpoReauthOtpRestricted));

            # 7. Microsoft SharePoint Admin Center
            # 7.3 Settings
            # 7.3.1 Ensure Office 365 SharePoint infected files are disallowed for download.
            # 7033c11e-71d9-407b-9a19-cde209d05426
            $null = $reviews.Add((Invoke-ReviewSpoInfectedFileDownloadDisabled));

            # 7. Microsoft SharePoint Admin Center
            # 7.3 Settings
            # 7.3.2 Ensure OneDrive sync is restricted for unmanaged devices.
            # d1412fb3-33a5-4b8f-a7c1-9a491b121d21
            $null = $reviews.Add((Invoke-ReviewOneDriveSyncRestrictedUnmanagedDevices));

            # 7. Microsoft SharePoint Admin Center
            # 7.3 Settings
            # 7.3.3 Ensure custom script execution is restricted on personal sites.
            # 2f538008-8944-4d45-9b79-4cd771851622
            $null = $reviews.Add((Invoke-ReviewOneDriveCustomScriptExecution));

            # 7. Microsoft SharePoint Admin Center
            # 7.3 Settings
            # 7.3.4 Ensure custom script execution is restricted on site collections.
            # 6339c889-76d7-450b-855d-b9e22869c94f
            $null = $reviews.Add((Invoke-ReviewSpoCustomScriptExecution));
        }

        # If "Microsoft Teams" is selected.
        if ($Service -contains 'm365teams' -or $Service.Count -eq 0)
        {
            # 8. Microsoft Teams Admin Center
            # 8.1 Teams
            # 8.1.1 Ensure external file sharing in Teams is enabled for only approved cloud storage services.
            # 36016fe3-30fe-4070-a446-441ae23cfe95
            $null = $reviews.Add((Invoke-ReviewTeamApprovedCloudStorage));

            # 8. Microsoft Teams Admin Center
            # 8.1 Teams
            # 8.1.2 Ensure users can't send emails to a channel email address.
            # 4623807d-6c30-4906-a33e-1e55fbbdfdec
            $null = $reviews.Add((Invoke-ReviewTeamUsersCantSendEmailToChannel));

            # 8. Microsoft Teams Admin Center
            # 8.2 Users
            # 8.2.1 Ensure 'external access' is restricted in the Teams admin center.
            # 1d4902a0-dcb6-4b1a-b77a-0662ba15a431
            $null = $reviews.Add((Invoke-ReviewTeamExternalSharingRestricted));

            # 8. Microsoft Teams Admin Center
            # 8.5 Meetings
            # 8.5.1 Ensure anonymous users can't join a meeting.
            # 087cd766-1d44-444d-a572-21312ddfb804
            $null = $reviews.Add((Invoke-ReviewTeamMeetingAnonymousJoin));

            # 8. Microsoft Teams Admin Center
            # 8.5 Meetings
            # 8.5.2 Ensure anonymous users and dial-in callers can't start a meeting.
            # 963797c1-0f06-4ae9-9446-7856eef4f7d7
            $null = $reviews.Add((Invoke-ReviewTeamMeetingAnonymousStartMeeting));

            # 8. Microsoft Teams Admin Center
            # 8.5 Meetings
            # 8.5.3 Ensure only people in my org can bypass the lobby.
            # 5252f126-4d4e-4a1c-ab56-743f8efe2b3e
            $null = $reviews.Add((Invoke-ReviewTeamMeetingAutoAdmittedUsers));

            # 8. Microsoft Teams Admin Center
            # 8.5 Meetings
            # 8.5.4 Ensure users dialing in can't bypass the lobby.
            # 710df2b2-b6f8-43f3-9d07-0079497f5c57
            $null = $reviews.Add((Invoke-ReviewTeamMeetingDialInBypassLobby));

            # 8. Microsoft Teams Admin Center
            # 8.5 Meetings
            # 8.5.5 Ensure meeting chat does not allow anonymous users.
            # 61b9c972-bb4e-4768-8db4-89a62fc09877
            $null = $reviews.Add((Invoke-ReviewTeamMeetingChatAnonymousUsers));

            # 8. Microsoft Teams Admin Center
            # 8.5 Meetings
            # 8.5.6 Ensure only organizers and co-organizers can present.
            # 8cd7d1c7-6491-433d-9d5b-68f1bf7bcfc3
            $null = $reviews.Add((Invoke-ReviewTeamMeetingOrganizerPresent));

            # 8. Microsoft Teams Admin Center
            # 8.5 Meetings
            # 8.5.7 Ensure external participants can't give or request control.
            # 89773e80-9004-4d41-bf8b-80d4dcbb141b
            $null = $reviews.Add((Invoke-ReviewTeamMeetingExternalControl));

            # 8. Microsoft Teams Admin Center
            # 8.6 Messaging
            # 8.6.1 Ensure users can report security concerns in Teams.
            # 3a107b4e-9bef-4480-b5c0-4aedd7a4a0bc
            $null = $reviews.Add((Invoke-ReviewTeamMessagingReportSecurityConcerns));
        }

        # If "Microsoft Fabric" is selected.
        if ($Service -contains 'm365fabric' -or $Service.Count -eq 0)
        {
            # Run only if the license is available.
            if ($licenses | Where-Object {
                $_.ServicePlanDisplayName -like 'Power BI Pro *' -or
                $_.ServicePlanDisplayName -like 'Power BI Premium*'})
            {
                # 9. Microsoft Fabric Admin Center
                # 9.1 Tenant settings
                # 9.1.1 Ensure guest user access is restricted.
                # 4d179407-ca60-4a37-981f-99584ea2d6ea
                $null = $reviews.Add((Invoke-ReviewFabricGuestAccessRestricted));

                # 9. Microsoft Fabric Admin Center
                # 9.1 Tenant settings
                # 9.1.2 Ensure external user invitations are restricted.
                # da8daeae-fc77-4bff-9733-19e8fe73b87b
                $null = $reviews.Add((Invoke-ReviewFabricExternalUserInvitationsRestricted));

                # 9. Microsoft Fabric Admin Center
                # 9.1 Tenant settings
                # 9.1.3 Ensure guest access to content is restricted.
                # 24e5ca61-a473-4fcc-b4ef-aad5235e573f
                $null = $reviews.Add((Invoke-ReviewFabricContentGuestAccessRestricted));

                # 9. Microsoft Fabric Admin Center
                # 9.1 Tenant settings
                # 9.1.4 Ensure 'Publish to web' is restricted.
                # fdd450f1-fb71-4450-a9e2-c82e916e86ab
                $null = $reviews.Add((Invoke-ReviewFabricPublishToWebRestricted));

                # 9. Microsoft Fabric Admin Center
                # 9.1 Tenant settings
                # 9.1.5 Ensure 'Interact with and share R and Python' visuals is 'Disabled'.
                # 134ffbee-2092-42a7-9309-7b9b04c14b4b
                $null = $reviews.Add((Invoke-ReviewFabricInteractPython));

                # 9. Microsoft Fabric Admin Center
                # 9.1 Tenant settings
                # 9.1.6 Ensure 'Allow users to apply sensitivity labels for content' is 'Enabled'.
                # 6aa91139-4667-4d38-887b-a22905da5bcc
                $null = $reviews.Add((Invoke-ReviewFabricSensitivityLabels));

                # 9. Microsoft Fabric Admin Center
                # 9.1 Tenant settings
                # 9.1.7 Ensure shareable links are restricted.
                # e9ec0d44-00a5-4305-9d15-a225f00a8364
                $null = $reviews.Add((Invoke-ReviewFabricLinksSharing));

                # 9. Microsoft Fabric Admin Center
                # 9.1 Tenant settings
                # 9.1.8 Ensure enabling of external data sharing is restricted.
                # 832a0d52-55b7-4a27-a6c7-a90e04bdaa7a
                $null = $reviews.Add((Invoke-ReviewFabricExternalDataSharingRestricted));

                # 9. Microsoft Fabric Admin Center
                # 9.1 Tenant settings
                # 9.1.9 Ensure 'Block ResourceKey Authentication' is 'Enabled'.
                # bbcbdabf-221c-412e-92d5-67367053ff27
                $null = $reviews.Add((Invoke-ReviewFabricBlockResourceKeyAuth));
            }
        }
    }
    END
    {
        # Get emoji.
        $emojiCheckmark = Get-Emoji -Type Checkmark;
        $emojiCrossmark = Get-Emoji -Type Crossmark;

        # Passed / Not passed.
        $passed = $reviews | Where-Object { $_.Review -eq $false };
        $notPassed = $reviews | Where-Object { $_.Review -eq $true };

        # Get score (%).
        $score = [math]::Round(($notPassed.Count / $reviews.Count) * 100);

        # Write to log.
        Write-Log -Message ('Review Assessment: {0} {1} passed | {2} {3} not passed' -f $passed.Count, $emojiCheckmark, $notPassed.Count, $emojiCrossmark) -Level Information -NoDateTime -NoLogLevel;
        Write-Log -Message ('Review Score: {0} out of 100' -f $score) -Level Information -NoDateTime -NoLogLevel;
        Write-Log -Category 'Review' -Message ('Finished the review process') -Level Debug;

        # Return the reviews.
        return $reviews;
    }
}