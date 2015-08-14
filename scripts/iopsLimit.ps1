# purpose: set an IOPS limit for all vms in a list
Param(
	[Parameter(Mandatory=$true)][string]$DiskLimitIOPerSecond,
	[Parameter(Mandatory=$true)][string]$match
)

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

# silently connect to the vCenter
Connect-VIServer -Server $vcenter > $null

foreach ($vm in (Get-VM) -match $match){
	$spec = New-Object VMware.Vim.VirtualMachineConfigSpec

	# get all disks and set the new IOPS limit
	$disks = $vm.ExtensionData.Config.Hardware.Device | where {$_ -is [VMware.Vim.VirtualDisk]}
	foreach ($disk in $disks) {
		$dev = New-Object VMware.Vim.VirtualDeviceConfigSpec
		$dev.Operation = "edit"
		$dev.Device = $disk
		$dev.Device.StorageIOAllocation.Limit = $diskLimitIOPerSecond
		$spec.DeviceChange += $dev
	}

	# reconfigure vms asynchronously
	$vm.ExtensionData.ReconfigVM_Task($spec)
}
