# Remove variable (just in case).
Remove-Variable -Name reviews -ErrorAction SilentlyContinue;

# Object array storing all the reviews.
$reviews = New-Object System.Collections.ArrayList;

######################################

# 1. Microsoft 365 Admin Center
# 1.1 Users
# 1.1.1 Ensure Administrative accounts are separate and cloud-only.
# 289efa41-e17f-43e7-a6b8-9ff8868d3511
$reviews.Add((Invoke-ReviewEntraIdAdminAccountCloudOnly)) | Out-Null;

# 1. Microsoft 365 Admin Center 
# 1.1 Users
# 1.1.3 Ensure that between two and four global admins are designated.
# d106f228-2f57-4009-a4c1-8d309a97c4f3
$reviews.Add((Invoke-ReviewEntraIdNumberOfGlobalAdmins)) | Out-Null;

# 1. Microsoft 365 Admin Center
# 1.1 Users
# 1.1.4 nsure Guest Users are reviewed and approved.
# 7fe4d30e-42bd-44d4-8066-0b732dcbda4c
$reviews.Add((Invoke-ReviewEntraIdGuestUsers)) | Out-Null;

# 1. Microsoft 365 Admin Center
# 1.2 Teams and groups
# 1.2.1 Ensure that only organizationally managed/approved public groups exist.
# 90295b64-2528-4c22-aa96-a606633bc705
$reviews.Add((Invoke-ReviewEntraIdPublicGroup)) | Out-Null;

# 1. Microsoft 365 Admin Center
# 1.2 Teams and groups
# 1.2.2 Ensure sign-in to shared mailboxes is blocked.
# dc6727fe-333d-46ad-9ad6-f9b0ae23d03b
$reviews.Add((Invoke-ReviewEntraIdSharedMailboxSignInAllowed)) | Out-Null;

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