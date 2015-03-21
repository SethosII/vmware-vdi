# purpose: logs the number of currently logged in users for each pool

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

$date = Get-Date -UFormat "%Y/%m/%d %T"

foreach ($pool in Get-Pool) {
	$pool_id = $pool.pool_id
	$disconnected = (Get-RemoteSession -Pool_id $pool_id -State "DISCONNECTED" -ErrorAction SilentlyContinue).Count
	if (!$disconnected) {
		$disconnected = 0
	}

	$connected = (Get-RemoteSession -Pool_id $pool_id -State "CONNECTED" -ErrorAction SilentlyContinue).Count
	if (!$connected) {
		$connected = 0
	}

	$output = $date + "," + $disconnected + "," + $connected

	Add-Content $folder"poolconnections\"$pool_id.csv "$output" -Encoding "UTF8"
}
