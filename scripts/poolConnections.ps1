# purpose: logs the number of currently logged in users for each pool

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

# current date like 2015/01/01 00:00:00
$date = Get-Date -UFormat "%Y/%m/%d %T"

foreach ($pool in Get-Pool) {
	$pool_id = $pool.pool_id

	# get all disconnected sessions
	$disconnected = (Get-RemoteSession -Pool_id $pool_id -State "DISCONNECTED" -ErrorAction SilentlyContinue | Measure-Object -Property session).Count
	if (!$disconnected) {
		# interpret none as zero
		$disconnected = 0
	}

	# get all connected sessions
	$connected = (Get-RemoteSession -Pool_id $pool_id -State "CONNECTED" -ErrorAction SilentlyContinue | Measure-Object -Property session).Count
	if (!$connected) {
		# interpret none as zero
		$connected = 0
	}

	# store data like 2015/01/01 00:00:00,20,10
	$output = $date + "," + $disconnected + "," + $connected
	Add-Content $folder"poolconnections\"$pool_id.csv "$output" -Encoding "UTF8"
	Add-Content $remoteStore"poolconnections\"$pool_id.csv "$output" -Encoding "UTF8"
}
