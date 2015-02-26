# purpose: store all vms without login for 30/60/90 days

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

foreach ($days in @(30,60,90)) {
echo $days
	$date = (Get-Date).addDays(-$days).toString("yyyy.MM.dd") -replace "\.", "/"
	& $folder"scripts\lastLogin.ps1" $date > $folder"unused\"$days.txt
}
