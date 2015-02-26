# purpose: logs the number of currently logged in users for each pool

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

$date = Get-Date -UFormat "%Y/%m/%d %T"

foreach ($pool in Get-Pool) {
	$pool_id = $pool.pool_id
	$count = (Get-RemoteSession -Pool_id $pool_id -ErrorAction SilentlyContinue | Where {$_.state -eq "CONNECTED"}).Count

	if (!$count) {
		$count = 0
	}
	$output = $date + "," + $count

	Add-Content $folder"poolconnections\"$pool_id.csv "$output" -Encoding "UTF8"
}
