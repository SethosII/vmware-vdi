# purpose: logs the currently connected user for each vm in specified pools

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

$date = Get-Date -UFormat "%Y/%m/%d %T"

$sessions = Get-RemoteSession -Pool_id desktoppool -ErrorAction SilentlyContinue
$sessions += Get-RemoteSession -Pool_id performancepool -ErrorAction SilentlyContinue
$sessions += Get-RemoteSession -Pool_id performancepool32bit -ErrorAction SilentlyContinue
$sessions += Get-RemoteSession -Pool_id fulldesktop -ErrorAction SilentlyContinue
$sessions += Get-RemoteSession -Pool_id migratedesktop -ErrorAction SilentlyContinue

$vms = Get-DesktopVM -Pool_id desktoppool
$vms += Get-DesktopVM -Pool_id performancepool
$vms += Get-DesktopVM -Pool_id performancepool32bit
$vms += Get-DesktopVM -Pool_id fulldesktop
$vms += Get-DesktopVM -Pool_id migratedesktop

# somehow not working
#$sessions = ""
#$vms = ""
#foreach ($pool in Get-Pool) {
#	$sessions += Get-RemoteSession -Pool_id $pool.pool_id -ErrorAction SilentlyContinue
#	$vms += Get-DesktopVM -Pool_id $pool.pool_id
#}

foreach ($vm in $vms) {
	$username = $nobody
	$vmname = $vm.HostName
	foreach ($session in $sessions) {
		if ($vmname -eq $session.DNSName ) {
			$username = $session.Username
		}
	}
	$output = $date + "," + $username
	Add-Content $folder"vmusage\"$vmname.csv "$output" -Encoding "UTF8"
	Add-Content $remoteStore"vmusage\"$vmname.csv "$output" -Encoding "UTF8"
}

