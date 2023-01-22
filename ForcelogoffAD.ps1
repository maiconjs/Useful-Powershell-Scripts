# This script checks if a user is allowed to logon to a Windows domain at the current day and time.
# If the user is not allowed to logon, the script will log off the user.
# If the user's logon time is about to expire, the script will show a notification to the user.

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
        Write-Output "Sua sessão Windows expirará em 15 minutos"
        [System.Windows.Forms.MessageBox]::Show("Sua sessão Windows expirará em 15 minutos", "Aviso de expiração da sessão")
    }
}
