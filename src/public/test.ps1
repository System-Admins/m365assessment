# Get all the files in the src (private) folder.
$ps1Files = Get-ChildItem -Path 'C:\Repositories\m365assessment\src\private' -Recurse -File -Filter *.ps1;
#$ps1Files = Get-ChildItem -Path '/Users/ath/Repositories/m365assessment/src/private' -Recurse -File -Filter *.ps1;

# Loop through each file
foreach ($ps1File in $ps1Files)
{
    # Dot source the file.
    . $ps1File.FullName;
}

######################################

#Uninstall-ModuleAll

# Install modules.
#Install-Modules;

# Connect to Microsoft.
#Connect-Tenant;

######################################

# Remove variable (just in case).
Remove-Variable -Name reviews -ErrorAction SilentlyContinue;

# Object array storing all the reviews.
$reviews = New-Object System.Collections.ArrayList;

######################################

# 1. Microsoft 365 Admin Center
# 1.1 Users
# 1.1.1 Ensure Administrative accounts are separate and cloud-only.
# 289efa41-e17f-43e7-a6b8-9ff8868d3511
$reviews.Add((Invoke-ReviewEntraAdminAccountCloudOnly)) | Out-Null;

# 1. Microsoft 365 Admin Center 
# 1.1 Users
# 1.1.3 Ensure that between two and four global admins are designated.
# d106f228-2f57-4009-a4c1-8d309a97c4f3
$reviews.Add((Invoke-ReviewEntraNumberOfGlobalAdmins)) | Out-Null;

# 1. Microsoft 365 Admin Center
# 1.1 Users
# 1.1.4 Ensure Guest Users are reviewed and approved.
# 7fe4d30e-42bd-44d4-8066-0b732dcbda4c
$reviews.Add((Invoke-ReviewEntraGuestUsers)) | Out-Null;

# 1. Microsoft 365 Admin Center
# 1.2 Teams and groups
# 1.2.1 Ensure that only organizationally managed/approved public groups exist.
# 90295b64-2528-4c22-aa96-a606633bc705
$reviews.Add((Invoke-ReviewEntraPublicGroup)) | Out-Null;

# 1. Microsoft 365 Admin Center
# 1.2 Teams and groups
# 1.2.2 Ensure sign-in to shared mailboxes is blocked.
# dc6727fe-333d-46ad-9ad6-f9b0ae23d03b
$reviews.Add((Invoke-ReviewEntraSharedMailboxSignInAllowed)) | Out-Null;

# 1. Microsoft 365 Admin Center
# 1.3 Settings
# 1.3.1 Ensure the 'Password expiration policy' is set to 'Set passwords to never expire (recommended)'.
# 7ccac596-ee68-4f28-abe7-713c2b75a39e
$reviews.Add((Invoke-ReviewEntraIdPasswordPolicy)) | Out-Null;

# 1. Microsoft 365 Admin Center
# 1.3 Settings
# 1.3.2 Ensure 'Idle session timeout' is set to '3 hours (or less)' for unmanaged devices.
# 645b1886-5437-43e5-8b8a-84c033173ff3
$reviews.Add((Invoke-ReviewEntraIdIdleSessionTimeout)) | Out-Null;

# 1. Microsoft 365 Admin Center
# 1.3 Settings
# 1.3.3 Ensure 'External sharing' of calendars is not available.
# 489b0b3d-cf78-46a5-8366-84908dc05d5a
$reviews.Add((Invoke-ReviewExoCalendarExternalSharing)) | Out-Null;

# 1. Microsoft 365 Admin Center
# 1.3 Settings
# 1.3.4 Ensure 'User owned apps and services' is restricted.
# 59a56832-8e8f-42ef-b03c-3a147059fe6f
$reviews.Add((Invoke-ReviewTenantUserOwnedAppsService)) | Out-Null;

# 1. Microsoft 365 Admin Center
# 1.3 Settings
# 1.3.5 Ensure internal phishing protection for Forms is enabled.
# 229fc460-ec0c-4e88-89db-0b8a883ba3e0
$reviews.Add((Invoke-ReviewFormsPhishingProtection)) | Out-Null;

# 1. Microsoft 365 Admin Center
# 1.3 Settings
# 1.3.6 Ensure the customer lockbox feature is enabled.
# f4cf24ca-cd8f-4ded-bfe0-6f45f3bcfed0
$reviews.Add((Invoke-ReviewTenantCustomerLockEnabled)) | Out-Null;

# 1. Microsoft 365 Admin Center
# 1.3 Settings
# 1.3.7 Ensure 'third-party storage services' are restricted in 'Microsoft 365 on the web'.
# 54b612c6-5306-45d4-b948-f3e75e09ab3b
$reviews.Add((Invoke-ReviewTenantThirdPartyStorage)) | Out-Null;

# 1. Microsoft 365 Admin Center
# 1.3 Settings
# 1.3.8 Ensure that Sways cannot be shared with people outside of your organization.
# d10b85ac-05df-4c78-91a5-5bc03f799ea2
$reviews.Add((Invoke-ReviewTenantSwayExternalSharing)) | Out-Null;

##############################################

# 2. Microsoft 365 Defender
# 2.1 Email and collaboration
# 2.1.1 Ensure Safe Links for Office Applications is Enabled.
# b29a3b32-4042-4ce6-86f6-eb85b183b4b5
$reviews.Add((Invoke-ReviewDefenderSafeLinksPolicyOfficeApps)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.1 Email and collaboration
# 2.1.2 Ensure the Common Attachment Types Filter is enabled.
# fd660655-99e8-4cbe-93a2-9fa3c5e34f40
$reviews.Add((Invoke-ReviewDefenderMalwareCommonAttachmentTypesFilter)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.1 Email and collaboration
# 2.1.3 Ensure notifications for internal users sending malware is Enabled.
# 01f7327e-f8cf-4542-b12a-41b40d03415d
$reviews.Add((Invoke-ReviewDefenderMalwareInternalUserNotifications)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.1 Email and collaboration
# 2.1.4 Ensure Safe Attachments policy is enabled.
# 383ea8f2-48e1-4a1f-bcc7-626fbeb0f331
$reviews.Add((Invoke-ReviewDefenderSafeAttachmentPolicyEnabled)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.1 Email and collaboration
# 2.1.5 Ensure Safe Attachments for SharePoint, OneDrive, and Microsoft Teams is Enabled.
# a4fb003f-b742-4a97-8a9a-c4e5a82171a4
$reviews.Add((Invoke-ReviewDefenderSafeAttachmentPolicyEnabledForApps)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.1 Email and collaboration
# 2.1.6 Ensure Exchange Online Spam Policies are set to notify administrators.
# a019303a-3b0a-4f42-999d-0d76b528ae28
$reviews.Add((Invoke-ReviewDefenderAntiSpamNotifyAdmins)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.1 Email and collaboration
# 2.1.7 Ensure that an anti-phishing policy has been created.
# 13954bef-f9cd-49f8-b8c8-626e87de6ba2
$reviews.Add((Invoke-ReviewDefenderAntiPhishingPolicy)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.1 Email and collaboration
# 2.1.8 Ensure that SPF records are published for all Exchange Domains.
# 9be729e4-0378-4c2c-afa1-92b2af71c4e9
$reviews.Add((Invoke-ReviewDefenderEmailDomainSpf)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.1 Email and collaboration
# 2.1.9 Ensure that DKIM is enabled for all Exchange Online Domains.
# 92adb77c-a12b-4dee-8ce8-2b5f748f22ec
$reviews.Add((Invoke-ReviewDefenderEmailDomainDkim)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.1 Email and collaboration
# 2.1.10 Ensure DMARC Records for all Exchange Online domains are published.
# 7f46d070-097f-4a6b-aad1-118b5b707f41
$reviews.Add((Invoke-ReviewDefenderEmailDomainDmarc)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.1 Email and collaboration
# 2.1.11 Ensure the spoofed domains report is reviewed weekly.
# c7d90aa7-bcb3-403c-96f4-bc828e6246ff
$reviews.Add((Invoke-ReviewDefenderEmailSpoofSenders)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.1 Email and collaboration
# 2.1.12 Ensure the 'Restricted entities' report is reviewed weekly.
# 86bab3de-8bac-442f-8495-496bd1ed75b9
$reviews.Add((Invoke-ReviewEmailRestrictedSenders)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.3 Audit
# 2.3.1 Ensure the Account Provisioning Activity report is reviewed at least weekly.
# 3483e87b-6069-4355-928f-dc9be4e31902
$reviews.Add((Invoke-ReviewDefenderAccountProvisioningActivity)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.3 Audit
# 2.3.2 Ensure non-global administrator role group assignments are reviewed at least weekly.
# 8104752c-9e07-4a61-99a1-7161a792d76e
$reviews.Add((Invoke-ReviewDefenderNonGlobalAdminRoleAssignment)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.4 Settings
# 2.4.1 Ensure Priority account protection is enabled and configured.
# 749ee441-71ea-4261-86da-1f1081c65bb3
$reviews.Add((Invoke-ReviewDefenderPriorityAccountProtectionConfig)) | Out-Null;

# 2. Microsoft 365 Defender
# 2.4 Settings
# 2.4.2 Ensure Priority accounts have 'Strict protection' presets applied.
# 9780f1b2-e2ea-4f6e-9bd9-7eb551b5d1e7
$reviews.Add((Invoke-ReviewDefenderPriorityAccounStrictPolicy)) | Out-Null;

##############################################

# 3. Microsoft Purview
# 3.1 Audit
# 3.1.1 Ensure Microsoft 365 audit log search is Enabled.
# 55299518-ad01-4532-aa35-422fd962c881
$reviews.Add((Invoke-ReviewPurviewUnifiedAuditLogIsEnabled)) | Out-Null;

# 3. Microsoft Purview
# 3.1 Audit
# 3.1.2 Ensure Microsoft 365 audit log search is Enabled.
# 6fe596b2-1ee0-46e1-9dba-316d1888d016
$reviews.Add((Invoke-ReviewPurviewUserRoleGroupChanges)) | Out-Null;

# 3. Microsoft Purview
# 3.2 Data Loss Prevention (DLP)
# 3.2.1 Ensure DLP policies are enabled.
# b9caf88c-0c9c-42a8-b6be-14953a8b76c3
$reviews.Add((Invoke-ReviewPurviewDlpPolicyEnabled)) | Out-Null;

# 3. Microsoft Purview
# 3.2 Data Loss Prevention (DLP)
# 3.2.2 Ensure DLP policies are enabled for Microsoft Teams.
# 48d970b5-a31b-41e9-9d66-eb8e02e0546d
$reviews.Add((Invoke-ReviewPurviewDlpTeamsPolicyEnabled)) | Out-Null;

# 3. Microsoft Purview
# 3.3 Information Protection
# 3.3.1 Ensure SharePoint Online Information Protection policies are set up and used.
# b01a1187-5921-4b29-95fd-73e1af3c5285
$reviews.Add((Invoke-ReviewPurviewInformationProtectionLabelPolicy)) | Out-Null;

##############################################

# 5. Microsoft Entra Admin Center
# 5.1 Identity
# 5.1.1 Overview.
# 5.1.1.1 Ensure Security Defaults is disabled on Azure Active Directory.
# bf8c7733-8ec0-4c86-9c4e-28bf4812a57a
$reviews.Add((Invoke-ReviewEntraSecurityDefaultEnabled)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.1 Identity
# 5.1.2 Users
# 5.1.2.2 Ensure third-party integrated applications are not allowed.
# 3caa1bff-bce3-4744-8898-00b0ebc49ff7
$reviews.Add((Invoke-ReviewEntraUsersCanRegisterAppsEnabled)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.1 Identity
# 5.1.2 Users
# 5.1.2.3 Ensure 'Restrict non-admin users from creating tenants' is set to 'Yes'.
# bf785c94-b3b4-4b1b-bf90-55031fdba42c
$reviews.Add((Invoke-ReviewEntraUsersAllowedToCreateTenants)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.1 Identity
# 5.1.2 Users
# 5.1.2.4 Ensure 'Restrict access to the Azure AD administration portal' is set to 'Yes'.
# 591c821b-52ca-48f3-806e-56a98d25c041
$reviews.Add((Invoke-ReviewEntraRestrictNonAdminUsersAdminPortal)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.1 Identity
# 5.1.2 Users
# 5.1.2.5 Ensure the option to remain signed in is hidden.
# 08798711-af3c-4fdc-8daf-947b050dca95
$reviews.Add((Invoke-ReviewEntraHideKeepMeSignedIn)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.1 Identity
# 5.1.2 Users
# 5.1.2.6 Ensure 'LinkedIn account connections' is disabled.
# 23d22457-f5e2-4f55-9aba-e483e8cbb11d
$reviews.Add((Invoke-ReviewEntraBlockLinkedInConnection)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.1 Identity
# 5.1.3 Groups
# 5.1.3.6 Ensure a dynamic group for guest users is created.
# a15e2ff5-2a03-495d-a4f2-4935742395d5
$reviews.Add((Invoke-ReviewEntraGuestDynamicGroup)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.1 Identity
# 5.1.5 Applications
# 5.1.5.1 Ensure the Application Usage report is reviewed at least weekly.
# 95d55daa-d432-44f5-907a-eda61b57696f
$reviews.Add((Invoke-ReviewEntraApplicationUsageReport)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.1 Identity
# 5.1.5 Applications
# 5.1.5.3 Ensure the admin consent workflow is enabled.
# ca409d22-6638-48ff-ad7c-4a61e3488b94
$reviews.Add((Invoke-ReviewEntraApplicationUserConsent)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.1 Identity
# 5.1.5 External Identities
# 5.1.6.1 Ensure that collaboration invitations are sent to allowed domains only.
# 54848e5b-7bb0-4a70-aeb1-63a1e54562d6
$reviews.Add((Invoke-ReviewEntraExternalCollaborationDomains)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.1 Identity
# 5.1.8 Hybrid Management
# 5.1.8.1 Ensure that password hash sync is enabled for hybrid deployments.
# ac82d275-9102-4df6-bf3c-ca012a74a306
$reviews.Add((Invoke-ReviewEntraHybridPasswordHashSync)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.2 Protection
# 5.2.3 Authentication Methods
# 5.2.3.1 Ensure Microsoft Authenticator is configured to protect against MFA fatigue.
# 0c1ccf40-64f3-4300-96e4-2f7f3272bf9a
$reviews.Add((Invoke-ReviewEntraAuthMethodMfaFatigue)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.2 Protection
# 5.2.3 Authentication Methods
# 5.2.3.2 Ensure custom banned passwords lists are used.
# bb23f25a-0c03-4607-a232-ef8902a0a899
$reviews.Add((Invoke-ReviewEntraAuthMethodCustomPasswordListEnforced)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.2 Protection
# 5.2.3 Authentication Methods
# 5.2.3.3 Ensure password protection is enabled for on-prem Active Directory.
# ee6975f8-842f-4096-a8a7-0ad093db82c0
$reviews.Add((Invoke-ReviewEntraAuthMethodPasswordProtectionOnPremAD)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.2 Protection
# 5.2.4 Password reset
# 5.2.4.1 Ensure 'Self service password reset enabled' is set to 'All'.
# 2425f84f-76cf-441b-891e-86142f14ff9e
$reviews.Add((Invoke-ReviewEntraSsprEnabledForAll)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.2 Protection
# 5.2.4 Password reset
# 5.2.4.2 Ensure the self-service password reset activity report is reviewed at least weekly.
# 9141c4a0-0323-4aa3-abb5-e6a0a2bedffa
$reviews.Add((Invoke-ReviewEntraPasswordResetAudit)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.2 Protection
# 5.2.6 Risky Activities
# 5.2.6.1 Ensure the Azure AD 'Risky sign-ins' report is reviewed at least weekly.
# ff9b1c25-464c-4c6a-a469-10aab9470e4c
$reviews.Add((Invoke-ReviewEntraRiskySignInReport)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.3 Identity Governance
# 5.3.1 Ensure 'Privileged Identity Management' is used to manage roles.
# 99dcdd37-60f6-450e-be03-13a85fcc5776
$reviews.Add((Invoke-ReviewEntraPimUsedToManageRoles)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.3 Identity Governance
# 5.3.2 Ensure 'Access reviews' for Guest Users are configured.
# 03a57762-4613-47fc-835d-5a5c3d0dbe61
$reviews.Add((Invoke-ReviewEntraAccessReviewGuestUsers)) | Out-Null;

# 5. Microsoft Entra Admin Center
# 5.3 Identity Governance
# 5.3.3 Ensure 'Access reviews' for high privileged Azure AD roles are configured.
# e8c91221-63d2-4797-8a86-7ef53c30a9d6
$reviews.Add((Invoke-ReviewEntraAccessReviewPrivilegedRoles)) | Out-Null;

##############################################

# 6. Microsoft Exchange Admin Center
# 6.1 Audit
# 6.1.1 Ensure 'AuditDisabled' organizationally is set to 'False'.
# 7cf11de7-eeb9-4e96-b406-7e69c232a9c0
$reviews.Add((Invoke-ReviewEntraAccessReviewPrivilegedRoles)) | Out-Null;

# 6. Microsoft Exchange Admin Center
# 6.1 Audit
# 6.1.2 / 6.1.3 Ensure mailbox auditing for users is Enabled.
# 2b849f34-8991-4a13-a6f1-9f7d0ea4bcef
$reviews.Add((Invoke-ReviewExoMailboxAuditEnabled)) | Out-Null;

# 6. Microsoft Exchange Admin Center
# 6.1 Audit
# 6.1.4 Ensure 'AuditBypassEnabled' is not enabled on mailboxes.
# a2c3a619-df82-4e0b-ac98-47ff51ea8c2a
$reviews.Add((Invoke-ReviewExoMailboxAuditBypassDisabled)) | Out-Null;

# 6. Microsoft Exchange Admin Center
# 6.2 Mail flow
# 6.2.1 Ensure all forms of mail forwarding are blocked and/or disabled.
# 45887263-5f2f-4306-946d-8f36acfb3691
$reviews.Add((Invoke-ReviewExoMailForwardDisabled)) | Out-Null;

# 6. Microsoft Exchange Admin Center
# 6.2 Mail flow
# 6.2.2 Ensure mail transport rules do not whitelist specific domains.
# 8bf19b9f-7c76-4cb6-8d9a-2a327db4d7d3
$reviews.Add((Invoke-ReviewExoTransportRuleWhitelistSpecificDomains)) | Out-Null;

# 6. Microsoft Exchange Admin Center
# 6.2 Mail flow
# 6.2.3 Ensure email from external senders is identified.
# a73f7dd0-6c32-44d1-ae18-197b775e28bb
$reviews.Add((Invoke-ReviewExoIdentifiedExternalSenders)) | Out-Null;

# 6. Microsoft Exchange Admin Center
# 6.3 Roles
# 6.3.1 Ensure users installing Outlook add-ins is not allowed.
# 36ee88d3-0ab8-41ea-90e7-fd9b14ed6a03
$reviews.Add((Invoke-ReviewExoOutlookAddinsIsNotAllowedRolePolicy)) | Out-Null;

# 6. Microsoft Exchange Admin Center
# 6.4 Reports
# 6.4.1 Ensure mail forwarding rules are reviewed at least weekly.
# b2798cfb-c5cc-41d4-9309-d1bd932a4a91
$reviews.Add((Invoke-ReviewExoMailForwardRules)) | Out-Null;

# 6. Microsoft Exchange Admin Center
# 6.5 Settings
# 6.5.1 Ensure modern authentication for Exchange Online is enabled.
# bd574cc3-88f8-4ce5-9b0c-5c9982c2de10
$reviews.Add((Invoke-ReviewExoModenAuthEnabled)) | Out-Null;

# 6. Microsoft Exchange Admin Center
# 6.5 Settings
# 6.5.2 Ensure MailTips are enabled for end users.
# bed51aa7-e6de-4542-96fc-ffe9d699763c
$reviews.Add((Invoke-ReviewExoMailTips)) | Out-Null;

# 6. Microsoft Exchange Admin Center
# 6.5 Settings
# 6.5.3 Ensure additional storage providers are restricted in Outlook on the web.
# d576ebed-fe29-44a7-9fdf-bb8b3c484894
$reviews.Add((Invoke-ReviewExoStorageProvidersRestricted)) | Out-Null;