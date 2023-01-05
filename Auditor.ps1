#The purpose of this script is to capture the events of logon, logoff, screen lock, and screen unlock on a local or remote device, and generate a .csv file.

# Prompt the user for the username
$Username = Read-Host "Informe o nome de usuario"

# Prompt the user for the number of days to collect events for
$Days = Read-Host "Informe o numero de dias para coletar eventos"

# Prompt the user for the file save location and name
$FilePath = Read-Host "Informe o local, o nome do arquivo e o formato .csv | ex: C:\Users\Public\report.csv"

# Prompt the user to specify if the audit is on the local device
$Local = Read-Host "A coleta sera deste dispositivo? (Se a coleta for para um dispositivo remoto responda N) (Y/N)"

# Calculate the start and end times for the event collection
$EndTime = Get-Date
$StartTime = $EndTime.AddDays(-$Days)

if ($Local -eq "Y") {
  # Get logon, logoff, screen lock, and screen unlock events for the specified user on the local device
  $Events = Get-WinEvent -FilterHashtable @{Logname='Security';ID=4624,4647,4800,4801;Data="$Username"; StartTime=$StartTime; EndTime=$EndTime}
} else {
  # Prompt the user for the name or IP of the remote device
  $RemoteDevice = Read-Host "Informe o nome ou IP do dispositivo remoto"

  # Get logon, logoff, screen lock, and screen unlock events for the specified user on the remote device
  $Events = Get-WinEvent -ComputerName $RemoteDevice -FilterHashtable @{Logname='Security';ID=4624,4647,4800,4801;Data="$Username"; StartTime=$StartTime; EndTime=$EndTime}
}

# Create an array to hold the report data
$Report = @()

# Loop through each event and create a report object
foreach ($Event in $Events) {
    switch ($Event.Id) {
        4624 {$eventType = "Login"}
        4647 {$eventType = "Logoff"}
        4800 {$eventType = "Bloqueio de tela"}
        4801 {$eventType = "Desbloqueio de tela"}
    }

    $Properties = @{
        'Data e Hora' = $Event.TimeCreated
        'Usuario' = $Username
        'Dispositivo' = $Event.MachineName
        'Evento' = $eventType
        'EventID' = $Event.Id
    }
    $Report += New-Object -TypeName PSObject -Property $Properties
}

# Export the report to a CSV file
$Report | Export-Csv -Path $FilePath -NoTypeInformation -Encoding Unicode
