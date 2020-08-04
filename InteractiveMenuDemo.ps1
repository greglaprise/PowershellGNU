#This sets the variable for current directory location
$currentdir = $(get-location).path;

#This line sets the varible that grabs the Serial Number from the motherboard
$serialnumber = Get-WmiObject -Class Win32_bios | Select-Object -Property SerialNumber | Format-Table -AutoSize -Wrap

#This line sets the variable that grabs the IPv4 Address
$ipv4 = Get-WmiObject win32_networkadapterconfiguration | where { $_.ipaddress -like "1*" } | select description, ipaddress | Format-Table -AutoSize -Wrap

#fetch MAC Address
$mac = Get-WmiObject win32_networkadapterconfiguration | where { $_.macaddress -like "*:*"} | select description, macaddress

#This line sets the variable to grab system info
$computermodel = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -Property Name, Domain, Manufacturer, Model, SystemSKUNumber | Format-Table -AutoSize -Wrap

#This line joins computername with date it was taken
$outfile = "$(get-date -f yyyy-MM-dd) $env:COMPUTERNAME"

#this is the Get-Date line. It... gets the date...
$date = Get-Date

#Grab Video Driver Info
$video = gwmi win32_VideoController | select DeviceID,Name,DriverVersion,VideoModeDescription

#get windows version
$winver = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\" -Name ReleaseID).ReleaseId

#cleanup winver to be readable
$winver1 = Write-Output " " "Windows 10 Version: $winver"


function Show-Menu
{
    param (
        [string]$Title = 'Select Variable Query'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: Get Computer Info."
    Write-Host "2: Get Windows Version"
    Write-Host "3: Get IP Info"
    Write-Host "4: Export All Info to .txt"
    Write-Host "Q: Press 'Q' to quit."
}



do
 {
     Show-Menu
     $selection = Read-Host "Please make a selection"
     switch ($selection)
     {
         '1' {
             $computermodel
         } '2' {
             $winver1
         } '3' {
             $ipv4
         } '4' {
            $date | Out-file -filepath $currentdir\$outfile.txt

            $env:COMPUTERNAME | Out-file -filepath $currentdir\$outfile.txt -Append

            $winver1 | Out-file -filepath $currentdir\$outfile.txt -Append

            $ipv4 | Out-file -filepath $currentdir\$outfile.txt -Append

            $mac | Out-file -filepath $currentdir\$outfile.txt -Append

            $serialnumber | Out-file -filepath $currentdir\$outfile.txt -Append

            $computermodel | Out-file -filepath $currentdir\$outfile.txt -Append

            $video | Out-file -filepath $currentdir\$outfile.txt -Append
         } default {
            'Invalid Option'
         }
     }
     pause
 }
 until ($selection -eq 'q')