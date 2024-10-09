# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()
Write-host "Importing Az Module"
Import-Module -Name Az.Accounts
Import-Module -Name Az.Resources
# Import-Module -Name Microsoft.PowerApps.Administration.PowerShell -UseWindowsPowerShell
$pass = ConvertTo-SecureString -AsPlainText "Iamthe1!"

# Add-PowerAppsAccount -Username RamitSaha@UpperSky1992.onmicrosoft.com -Password $pass
# Get-AdminPowerAppEnvironment -Default
$cred = New-Object System.Management.Automation.PsCredential("TestUser@UpperSky1992.onmicrosoft.com",$pass)
Write-host "Connecting to Az account"
Connect-AzAccount -Credential $cred -Tenant e3064b47-1417-45a4-a070-88965c33f5f4

# $users = Get-AzADUser

# foreach($user in $users){
#     Write-Host Hello $user.DisplayName
# }

Write-Host "Intializing portfolio, SOM and other users"
$portUsers = @('SumanaSaha@UpperSky1992.onmicrosoft.com', 'RanjanSaha@UpperSky1992.onmicrosoft.com')
$SOMOwners = @('ShanuMondal@UpperSky1992.onmicrosoft.com', 'DependraShome@UpperSky1992.onmicrosoft.com')
$otherUsers = @('SakyaRoy@UpperSky1992.onmicrosoft.com', 'anuradhasaha@UpperSky1992.onmicrosoft.com', 'RanjanSaha@UpperSky1992.onmicrosoft.com')

$appCount = 5
$x=1

Write-Host "Creating security groups and adding owners"

for($x -eq 0; $x -lt $appCount; $x++){
    $ppNew = "AZ-PP-GRP-SG-P-" + $x + "-Maker"
    $ppOld = "PAFL-P-" + $x + "-Group"
    $pbiNew = "AZ-PBI-GRP-SG-P-" + $x + "-Publisher"
    $pbiOld = "PBAS-P-" + $x + "-Group"
    Write-Host "Creating security groups for " $x
    $ppNewGroup = New-AzADGroup -DisplayName $ppNew -MailNickname ("AZPP" + $x)
    $ppOldGroup = New-AzADGroup -DisplayName $ppOld -MailNickname ("PAFL" + $x)
    $pbiNewGroup = New-AzADGroup -DisplayName $pbiNew -MailNickname ("AZPBI" + $x)
    $pbiOldGroup = New-AzADGroup -DisplayName $pbiOld -MailNickname ("PBAS" + $x)

    Write-Host "Adding owners to security groups for " $x
    foreach($pUser in $portUsers){
        $user = Get-AzADUser -Filter ("UserPrincipalName eq '" + $pUser + "'")
        New-AzADGroupOwner -GroupId $ppNewGroup.Id -OwnerId $user.Id
        New-AzADGroupOwner -GroupId $ppOldGroup.Id -OwnerId $user.Id
        New-AzADGroupOwner -GroupId $pbiNewGroup.Id -OwnerId $user.Id
        New-AzADGroupOwner -GroupId $pbiOldGroup.Id -OwnerId $user.Id
    }
    Write-Host "Checking conditions for adding users"
    for($y -eq 0; $y -lt $otherUsers.Count; $y++){
        $user = Get-AzADUser -Filter ("UserPrincipalName eq '" + $otherUsers[$y] + "'")
        If($x -le 2){
            If($y -le 1){
                continue
            }
        }
        elseif ($x -le 3) {
            If($y -le 2){
                continue
            }
        }
        else{
            break
        }
        Add-AzADGroupMember -TargetGroupObjectId $ppNewGroup.Id -MemberObjectId $user.Id
        Add-AzADGroupMember -TargetGroupObjectId $ppOldGroup.Id -MemberObjectId $user.Id
        Add-AzADGroupMember -TargetGroupObjectId $pbiNewGroup.Id -MemberObjectId $user.Id
        Add-AzADGroupMember -TargetGroupObjectId $pbiOldGroup.Id -MemberObjectId $user.Id
    }
}

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"
