# purpose: remove all pool entitlements without an assigned vm

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\Users\Public\Documents\scripts\constants.ps1"

foreach ($pool in Get-Pool) {
	# arrays
	$remove = @()
	$user = @()

	# get all users
	foreach ($vm in Get-DesktopVM -Pool_id $pool.pool_id) {
		if ($vm.user_displayname -ne "") {
			$user += $vm.user_displayname
		}
	}

	# check if entitlement has a user
	foreach ($entitlement in Get-PoolEntitlement -Pool_id $pool.pool_id) {
		if ($entitlement.displayName -notin $user) {
			$remove += $entitlement.sid
		}
	}

	# remove entitlements without a user
	foreach ($sid in $remove) {
		Remove-PoolEntitlement -Pool_id $pool.pool_id -Sid $sid
	}
}
