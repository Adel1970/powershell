Param(
#[Parameter(Mandatory, HelpMessage = "Write the path to whereever you save the script. e.g. C:\Users\USERNAME\Documents\WindowsPowerShell\deleteTemp.ps1")]
[string]$path,
[string]$frequency,
[string]$times
)
if(-not $path){
    write-host "Write the path to whereever you save the script. e.g. C:\Users\USERNAME\Documents\WindowsPowerShell\deleteTemp.ps1"
    while (-not $path){
        $path = Read-host "Enter the path to deleteTemp script"
    }
}
$period = ""
if(-not $frequency){
    write-host "How often do you want this script to run"
    while (-not ($frequency) -AND -not($frequency -eq "-Monthly") -AND -not ($frequency -eq "-Weekly") -AND -not ($frequency -eq "-Daily")){
        $frequency = Read-Host "Enter 'm' for -Monthly, 'w' for -Weekly 'd' for -Daily"
        if ($frequency -eq "m"){
            $frequency = "-Monthly"
            $period = "month"
        }
        if($frequency -eq "w"){
            $frequency = "-Weekly"
            $period = "week"
        }
        if($frequency -eq "d"){
            $frequency = "-Daily"
            $period = "day"
        }
    }
}
if(-not $times){
    write-host "How many times do you want this script to run per $period"
    while (-not $times -or -not ($times -is [int])){
            $toNumber = Read-host "Enter a number e.g. 1, 2, 3 etc."
            [int]$times = [convert]::ToInt32($toNumber, 10)
        }      
    }

if($frequency -eq "-Daily"){
    $arr = New-Object System.Collections.ArrayList
    $i = 0
    while($i -lt $times){
        $time = Read-Host "Enter the $($i+1) time of the day, e.g. 7:30AM"
        $arr.Add($time)
        $i++
    }
}
if($frequency -eq "-Weekly"){
    $daysOfWeek = New-Object System.Collections.ArrayList
    $i = 0
    while($i -lt $times){
        $day = Read-Host "Enter the $($i+1) day of the week, e.g. sunday"
        $dayOfWeek = @{
            day = $day
            time = Read-Host "Enter time on $day, e.g. 03:30AM"
        }
        $daysOfWeek.Add($dayOfWeek)
        $i++
    }
}
if($frequency -eq "-Monthly"){
    $daysOfMonth = New-Object System.Collections.ArrayList
    $i = 0
    while($i -lt $times){
        $dayOfMonth = @{
            day = Read-Host "Enter the $($i+1) day of the month, on which you want the script to run, e.g. 01"
            time = Read-Host "Enter time on that day, e.g. 05:30AM"
        }
        $daysOfMonth.Add($dayOfMonth)
        $i++
    }
}

$TaskName = "deleteTemp"
$User = "$env:username"
$ScriptPath = $path
$Trigger = New-ScheduledTaskTrigger -Weekly -WeeksInterval 1 -DaysOfWeek Sunday -At 7:30am
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-executionpolicy bypass -noprofile -file $ScriptPath" 

Register-ScheduledTask -TaskName $TaskName -Trigger $Trigger -User $User -Action $Action -RunLevel Highest -Force