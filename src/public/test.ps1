# Get all the files in the src (private) folder.
$ps1Files = Get-ChildItem -Path 'C:\Repositories\m365assessment\src\private' -Recurse -File -Filter *.ps1;

# Loop through each file
foreach ($ps1File in $ps1Files)
{
    # Dot source the file.
    . $ps1File.FullName;
}

######################################

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
$reviews.Add((Invoke-ReviewDefenderEmailRestrictedSenders)) | Out-Null;