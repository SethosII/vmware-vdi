# purpose: outputs a .csv file containing all VMs associated with a user and their entitled users

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

foreach ($vm in Get-DesktopVM) {
	if ($vm.user_displayname -ne "") {
		$vmName = $vm.Name
		$user = $vm.user_displayname

		$list += $vmName + "," + $user + "`r`n"
	}
}

$list | Out-File -FilePath $remoteStore"viewUsers.csv" -encoding "UTF8"

