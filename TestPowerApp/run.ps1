# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

Write-host "Importing Microsoft.PowerApps.Administration.PowerShell"
Import-Module Microsoft.PowerApps.Administration.PowerShell -UseWindowsPowerShell

$pass = ConvertTo-SecureString -AsPlainText "Iamthe1!"
# $cred = New-Object System.Management.Automation.PsCredential("RamitSaha@UpperSky1992.onmicrosoft.com",$pass)

Write-Host "Connecting to PowerApps account"
Add-PowerAppsAccount -Username "RamitSaha@UpperSky1992.onmicrosoft.com" -Password $pass
Write-host "Getting environments"
$envs = Get-AdminPowerAppEnvironment
Write-Host $envs[0].DisplayName
# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"
