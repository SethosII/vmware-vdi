# purpose: outputs a .csv file containing all VMs associated with a user, their entitled users and the IP address

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

# list is an array
$list = @()

foreach ($vm in Get-DesktopVM) {
	if ($vm.user_displayname -ne "") {
		# get name user and IP address for all vms with assigned user
		$vmName = $vm.Name
		$user = $vm.user_displayname
		$ip = $vm.IPAddress

		$list += $vmName + "," + $user + "," + $ip
	}
}

# store the data
$list | Out-File -FilePath $folder"vmIP.csv" -encoding "UTF8"
$list | Out-File -FilePath $remoteStore"vmIP.csv" -encoding "UTF8"
