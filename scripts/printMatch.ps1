# purpose: print all vms containing a certain string
Param(
	[string]$match
)

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

if ($match -eq "") {
	echo "please provide a string to look for matches"
	exit
}

foreach ($vm in Get-DesktopVM) {
	if ($vm.name -match $match) {
		echo $vm.name
	}
}
