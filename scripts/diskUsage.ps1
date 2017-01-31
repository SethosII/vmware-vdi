# purpose: get virtual disk usage, sorted by "wasted" space (space used according to vsphere minus space used according to windows)

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

# silently connect to the vCenter
Connect-VIServer -Server $vcenter > $null

# list is an array
$list = @()

# powered off vms report not all values
foreach ($vm in (Get-VM -Name $vmNamingScheme | where {$_.PowerState -eq "PoweredOn" })) {
	$ActuallyUsedSpaceGB = 0
	foreach ($disk in $vm.Guest.Disks) {
		# only virtual disks are relevant
		if ($disk.Path -in $virtualDisks) {
			$ActuallyUsedSpaceGB += $disk.CapacityGB - $disk.FreeSpaceGB
		}
	}

	# vms with vmware tools not running report no guest values
	if ($ActuallyUsedSpaceGB -ne 0) {
		$WastedSpaceGB = $vm.UsedSpaceGB - $ActuallyUsedSpaceGB
		$list += "" + [math]::Round($WastedSpaceGB, 1) + "," + $vm.Name + "," + [math]::Round($ActuallyUsedSpaceGB, 1) + "," + [math]::Round($vm.UsedSpaceGB, 1) + "," + [math]::Round($vm.ProvisionedSpaceGB, 1)
	}
}

$list = $list | sort {[decimal]$_.substring(0, $_.IndexOf(","))}
$list | Out-File -FilePath $folder"diskUsage.csv" -Encoding "UTF8"
$list | Out-File -FilePath $remoteStore"diskUsage.csv" -Encoding "UTF8"
