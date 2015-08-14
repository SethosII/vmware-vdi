# purpose: outputs a .csv file containing all VMs associated with a user and their entitled users

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

# list is an array
$list = @()

foreach ($vm in Get-DesktopVM) {
	if ($vm.user_displayname -ne "") {
		# get name and user for all vms with assigned user
		$vmName = $vm.Name
		$user = $vm.user_displayname

		$list += $vmName + "," + $user
	}
}

# store the data
$list | Out-File -FilePath $folder"viewUsers.csv" -encoding "UTF8"
$list | Out-File -FilePath $remoteStore"viewUsers.csv" -encoding "UTF8"
