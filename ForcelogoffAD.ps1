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
else
{
    # Check if the user's time is about to expire
    $expirationTime = $logonHours[$dayOfWeek] -split "-" | Select-Object -Last 1
    if ($timeOfDay -ge $expirationTime -and $timeOfDay -lt $($expirationTime - 15))
    {
        # Show a notification to the user
        Write-Output "Your Windows session will expire in 15 minutes."
        [System.Windows.Forms.MessageBox]::Show("Your Windows session will expire in 15 minutes.", "Session Expiration Warning")
    }
}
