$user = "username"
$domain = "domainname"

# Query the logon hours for the user
$userObj = Get-ADUser -Identity $user -Properties LogonHours
$logonHours = $userObj.LogonHours

# Get the current day and time
$dayOfWeek = (Get-Date).DayOfWeek
$timeOfDay = Get-Date -Format "HH:mm"

# Check if the user is allowed to log on at this time
if ($logonHours[$dayOfWeek] -notcontains $timeOfDay)
{
    # Log off the user
    Write-Output "Logging off user $user"
    logoff $user /server:$domain
}