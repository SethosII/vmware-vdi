# purpose: set a IOPS limit for all vms in a list
#Param(
#	[string]$DiskLimitIOPerSecond,
#	[string]$File
#)
# Params disabled for scheduled task

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

# file layout
#vmName
#<name1>
#<name2>
$file = $folder + "scripts\iopsLimits.csv"
echo $file
$diskLimitIOPerSecond = 100

. $folder"scripts\printMatch.ps1" vdidesktop > $file

Connect-VIServer -Server $vcenter

if ($File -eq "") {
	echo "please specify a file with the vms to apply the limit to, first line has to be vmName"
	exit
}
$vms = Import-Csv $file | Group-Object -Property vmName

if ($DiskLimitIOPerSecond -eq "") {
	echo "please specify a IOPS limit to apply to the specified vms, the value will be applied to all disks, provide -1 to remove the limit"
	exit
}

foreach ($group in $vms){
	$vm = Get-DesktopVM -Name $group.Name
	$spec = New-Object VMware.Vim.VirtualMachineConfigSpec
	$vm.ExtensionData.Config.Hardware.Device |  where {$_ -is [VMware.Vim.VirtualDisk]} | %{
		$dev = New-Object VMware.Vim.VirtualDeviceConfigSpec
		$dev.Operation = "edit"
		$dev.Device = $_
		$dev.Device.StorageIOAllocation.Limit = $diskLimitIOPerSecond
		$spec.DeviceChange += $dev
	}
	$vm.ExtensionData.ReconfigVM_Task($spec)
}
