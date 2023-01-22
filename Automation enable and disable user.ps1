# This script enables or disables Active Directory users based on two input text files.
# The "disable" file contains a list of Active Directory users that will be disabled,
# and the "enable" file contains a list of Active Directory users that will be enabled. 
# It also generates a log file containing the date and time of the changes, the user who made the change,
# and the users that were affected. The contents of the input files are cleared after the script is executed.
# This script is useful to run in conjunction with the Windows Task Scheduler to automate the process of enabling/disabling users.

# Get current date and time
$date = Get-Date -Format "dd-MM-yyyy HH:mm:ss"

# Get current user
$user = (Get-WmiObject -Class Win32_ComputerSystem).UserName

# Import list of users to disable
$disableList = Get-Content "C:\disable.txt"

# Import list of users to enable
$enableList = Get-Content "C:\enable.txt"

# Disable users
foreach($user in $disableList) {
    Disable-ADAccount -Identity $user
}

# Enable users
foreach($user in $enableList) {
    Enable-ADAccount -Identity $user
}

# Clear the contents of the text files
Clear-Content "C:\disable.txt"
Clear-Content "C:\enable.txt"

# Generate log
foreach($user in $disableList) {
    Write-Output "$date: $user disabled by $user" | Out-File -Append "C:\log.txt"
}
foreach($user in $enableList) {
    Write-Output "$date: $user enabled by $user" | Out-File -Append "C:\log.txt"
}

# log the cleaning of files
Write-Output "$date : Clearing contents of C:\disable.txt and C:\enable.txt by $user" | Out-File -Append "C:\log.txt"
