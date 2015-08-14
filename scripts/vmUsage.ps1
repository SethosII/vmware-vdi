# purpose: logs the currently connected user for each vm in all pools

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

# current date like 2015/01/01 00:00:00
$date = Get-Date -UFormat "%Y/%m/%d %T"

# get all vms and sessions of all pools
foreach ($pool in Get-Pool) {
	$sessions += Get-RemoteSession -Pool_id $pool.pool_id -ErrorAction SilentlyContinue
	$vms += Get-DesktopVM -Pool_id $pool.pool_id
}

foreach ($vm in $vms) {
	# entry when no user is logged in
	$username = $nobody

	# get vm dns name
	$vmname = $vm.HostName
	
	# check if vm has an active session and get the user name
	foreach ($session in $sessions) {
		if ($vmname -eq $session.DNSName ) {
			$username = $session.Username
		}
	}

	# store data like 2015/01/01 00:00:00,domain.local\user
	$output = $date + "," + $username
	Add-Content $folder"vmusage\"$vmname.csv "$output" -Encoding "UTF8"
	Add-Content $remoteStore"vmusage\"$vmname.csv "$output" -Encoding "UTF8"
}
