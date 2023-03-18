This repository contains two PowerShell scripts that can be used to automate common tasks:

### **Auditor.ps1**
This script prompts the user for a username, number of days to collect events for, file save location and name, and whether the audit is on the local device or a remote device. It then calculates the start and end times for the event collection and collects logon, logoff, screen lock, and screen unlock events for the specified user on the local device or remote device.

The script creates an array to hold the report data, loops through each event, creates a report object, and finally exports the report to a CSV file.

### **Automation enable and disable user.ps1**
This script is designed to enable and disable Active Directory users based on a list of users and dates provided in two separate text files. To insert users in the "disable.txt" and "enable.txt" files, each username should be on a new line.

The script first imports the list of users to be disabled and the list of users to be enabled from the text files "C:\disable.txt" and "C:\enable.txt" respectively. The script then gets the current date and time and the current user who is running the script.

Next, the script loops through the list of users to be disabled and checks if the date next to each user in the list matches the current date. If the date matches, the script disables the user and adds them to a list of processed users.

The script then repeats the same process for the list of users to be enabled. After all users have been processed, the script generates a log of the enabled and disabled users and the date and time they were processed.

Finally, the script removes the processed users from the text files by creating a new list of users that do not match the processed user list. It then clears the original text files and writes the new list of users back to the files.

To use these scripts, simply clone the repository to your local machine and execute the script using a PowerShell console. Each script contains detailed instructions on how to use it, along with any required dependencies.

### **ForcelogoffAD.ps1**
This script is designed to check if a user is allowed to log on to a Windows domain at the current day and time. If the user is not allowed to log on, the script will log off the user. If the user's logon time is about to expire, the script will show a notification to the user.
