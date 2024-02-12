# Object array storing all the reviews.
$reviews = New-Object System.Collections.ArrayList;

######################################

# Ensure Administrative accounts are separate and cloud-only.
$reviewAdminAccountCloudOnly = Invoke-ReviewAdminAccountCloudOnly;

# If review are required.
if ($null -ne $reviewAdminAccountCloudOnly)
{
    # Remove variable.
    Remove-Variable -Name review -ErrorAction SilentlyContinue;

    # Create new review object.
    $review = [Review]::new();

    # Add to object.
    $review.Id = '289efa41-e17f-43e7-a6b8-9ff8868d3511';
    $review.Category = 'Microsoft 365 Admin Center'
    $review.Title = 'Ensure Administrative accounts are separate and cloud-only';
    $review.Url = ('https://someurl.com/{0}' -f $review.Id);
    $review.Data = $reviewAdminAccountCloudOnly;

    # Add to object array.
    $reviews.Add($review) | Out-Null;
}

######################################

# Ensure that between two and four global admins are designated.
$reviewNumberOfGlobalAdmins = Invoke-ReviewNumberOfGlobalAdmins;

# If review are required.
if ($false -eq $reviewNumberOfGlobalAdmins.Valid)
{
    # Remove variable.
    Remove-Variable -Name review -ErrorAction SilentlyContinue;
        
    # Create new review object.
    $review = [Review]::new();

    # Add to object.
    $review.Id = 'f2f56ef5-5957-46b7-a555-5f5404e367f2';
    $review.Category = 'Microsoft 365 Admin Center'
    $review.Title = 'Ensure that between two and four global admins are designated';
    $review.Url = ('https://someurl.com/{0}' -f $review.Id);
    $review.Data = $reviewNumberOfGlobalAdmins;

    # Add to object array.
    $reviews.Add($review) | Out-Null;
}

######################################

# Ensure Guest Users are reviewed.
$reviewGuestUsers = Invoke-ReviewGuestUsers;

# If review are required.
if ($null -ne $reviewGuestUsers)
{
    # Remove variable.
    Remove-Variable -Name review -ErrorAction SilentlyContinue;
        
    # Create new review object.
    $review = [Review]::new();

    # Add to object.
    $review.Id = 'a2032723-e080-4948-a829-513ac2e085c8';
    $review.Category = 'Microsoft 365 Admin Center'
    $review.Title = 'Ensure Guest Users are reviewed';
    $review.Url = ('https://someurl.com/{0}' -f $review.Id);
    $review.Data = $reviewGuestUsers;

    # Add to object array.
    $reviews.Add($review) | Out-Null;
}

######################################

# Ensure that only organizationally managed/approved public groups exist.
$reviewPublicGroup = Invoke-ReviewPublicGroup;

# If review are required.
if ($null -ne $reviewPublicGroup)
{
    # Remove variable.
    Remove-Variable -Name review -ErrorAction SilentlyContinue;
        
    # Create new review object.
    $review = [Review]::new();

    # Add to object.
    $review.Id = 'ce8b25cf-2daa-45dc-aaeb-e381b3970594';
    $review.Category = 'Microsoft 365 Admin Center'
    $review.Title = 'Ensure that only organizationally managed/approved public groups exist';
    $review.Url = ('https://someurl.com/{0}' -f $review.Id);
    $review.Data = $reviewPublicGroup;

    # Add to object array.
    $reviews.Add($review) | Out-Null;
}

######################################

# Ensure sign-in to shared mailboxes is blocked.
$reviewSharedMailboxSignInAllowed = Invoke-ReviewSharedMailboxSignInAllowed;

# If review are required.
if ($null -ne $reviewSharedMailboxSignInAllowed)
{
    # Remove variable.
    Remove-Variable -Name review -ErrorAction SilentlyContinue;
        
    # Create new review object.
    $review = [Review]::new();

    # Add to object.
    $review.Id = '01b48032-3e2e-4361-a976-6915b7e0df73';
    $review.Category = 'Microsoft 365 Admin Center'
    $review.Title = 'Ensure sign-in to shared mailboxes is blocked';
    $review.Url = ('https://someurl.com/{0}' -f $review.Id);
    $review.Data = $reviewSharedMailboxSignInAllowed;

    # Add to object array.
    $reviews.Add($review) | Out-Null;
}