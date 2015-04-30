# purpose: store all vms without login for 30/60/90 days

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

foreach ($days in @(30,60,90)) {
	$date = (Get-Date).addDays(-$days).toString("yyyy.MM.dd") -replace "\.", "/"
	$list = & $folder"scripts\lastLogin.ps1" $date
	$list | Out-File -FilePath $folder"unused\"$days.txt -encoding "UTF8"
	$list | Out-File -FilePath $remoteStore"unused\"$days.txt -encoding "UTF8"
}

