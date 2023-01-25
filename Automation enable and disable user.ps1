# This script is designed to enable and disable Active Directory users based on a list of users and dates provided in two separate text files.
# The script first imports the list of users to be disabled and the list of users to be enabled from the text files "C:\disable.txt" and "C:\enable.txt" respectively.
# The script then gets the current date and time, and the current user who is running the script.
# Next, the script loops through the list of users to be disabled and checks if the date next to each user in the list matches the current date.
# If the date matches, the script disables the user and adds them to a list of processed users.
# The script then repeats the same process for the list of users to be enabled.
# After all users have been processed, the script generates a log of the enabled and disabled users, and the date and time they were processed.
# Finally, the script removes the processed users from the text files by creating a new list of users that do not match the processed user list, and then clears the original text files and writes the new list of users back to the files.
# To insert users in the "disable.txt" and "enable.txt" files, each username should be on a new line.
# For example, if you want to disable users "user1" and "user2", the "disable.txt" file should contain:
# user1 23-01-2023
# user2 25-01-2023
# And if you want to enable users "user3" and "user4", the "enable.txt" file should contain:
# user3 28-01-2023
# user4 02-05-2023

# Get current date
$currentDate = Get-Date -Format "dd-MM-yyyy"
$currentTime = Get-Date -Format "HH:mm:ss"


# Import list of users to disable
$disableList = Get-Content "C:\disable.txt"

# Import list of users to enable
$enableList = Get-Content "C:\enable.txt"

# Create empty lists to store the processed enable and disable users
$processedEnableUsers = @()
$processedDisableUsers = @()

# Disable users
foreach($item in $disableList) {
    $data = $item -split " "
    $user = $data[0]
    $date = $data[1]
    if($date -eq $currentDate) {
        Disable-ADAccount -Identity $user
        $processedDisableUsers += $item
    }
}

# Enable users
foreach($item in $enableList) {
    $data = $item -split " "
    $user = $data[0]
    $date = $data[1]
    if($date -eq $currentDate) {
        Enable-ADAccount -Identity $user
        $processedEnableUsers += $item
    }
}

# Generate log
foreach($item in $processedEnableUsers) {
    Write-Output "${currentDate} ${currentTime}: $item enabled by $env:USERNAME" | Out-File -Append "C:\log.txt"
}
foreach($item in $processedDisableUsers) {
    Write-Output "${currentDate} ${currentTime}: $item disabled by $env:USERNAME" | Out-File -Append "C:\log.txt"
}

# Remove the processed users from the text files
$newDisableList = $disableList | Where-Object {$_ -notmatch ($processedDisableUsers -join "|")}
$newEnableList = $enableList | Where-Object {$_ -notmatch ($processedEnableUsers -join "|")}

# Delete processed users from disable list
$processedDisableUsers | ForEach-Object {
    $line = $_
    if($line -match $currentDate) {
        $disableList = $disableList -replace $line,''
    }
}
$disableList | Set-Content "D:\disable.txt"

# Delete processed users from enable list
$processedEnableUsers | ForEach-Object {
    $line = $_
    if($line -match $currentDate) {
        $enableList = $enableList -replace $line,''
    }
}
$enableList | Set-Content "D:\enable.txt"

# log the cleaning of files
Write-Output "$currentDate $currentTime : Clearing contents of C:\disable.txt and C:\enable.txt by $env:USERNAME" | Out-File -Append "C:\log.txt"
