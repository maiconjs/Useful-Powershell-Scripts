# Import the Active Directory module
Import-Module ActiveDirectory

# Set the server and share locations
$server = "server.example.com"
$share = "\\$server\AuditLogs"

# Check if the client is connected to the Active Directory network
if (Test-Connection $server -Quiet)
{
    # Get the logon and logoff events from the security log
    $logonEvents = Get-EventLog -LogName Security -InstanceId 4624 -After (Get-Date).AddDays(-7)
    $logoffEvents = Get-EventLog -LogName Security -InstanceId 4634 -After (Get-Date).AddDays(-7)

    # Filter the events to include only the relevant properties
    $logonData = $logonEvents | Select-Object TimeGenerated, UserName, ComputerName
    $logoffData = $logoffEvents | Select-Object TimeGenerated, UserName, ComputerName

    # Combine the logon and logoff data
    $auditData = $logonData + $logoffData | Sort-Object TimeGenerated

    # Get the current user's username
    $user = Get-WmiObject Win32_ComputerSystem | Select-Object -ExpandProperty UserName

    # Create a log file name based on the user's username
    $logFile = "$share\Audit_$user.log"

    # Save the audit data to a log file
    $auditData | Out-File $logFile -Append
}