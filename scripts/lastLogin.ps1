# purpose: print the last time a user was connected to a vm since given time and the note field
Param(
	[string]$date = ((Get-Date).addDays(1).toString("yyyy.MM.dd") -replace "\.","/")
)

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

# silently connect to the vCenter
Connect-VIServer -Server $vcenter > $null

# get all files
$usageFileLocation = $folder + "vmusage\"
$files = Get-ChildItem $usageFileLocation

# lastLogin is an array
$lastLogin = @()

# get last login for each file
foreach ($file in $files) {
	$name = $file.Name.Split(".")[0]
	$dateAndUser = Get-Content "$usageFileLocation$file" | Select-String -NotMatch $exclude -Encoding "UTF8" | Select -Last 1
	if (!$dateAndUser) {
		$dateAndUser = (Get-Content "$usageFileLocation$file")[0]
	}

	# store data like vdi1,2015/01/01 00:00:00,domain.local\user
	$lastLogin += $name + "," + $dateAndUser
}

# cache all vms for faster execution
$vms = Get-VM

foreach ($line in $lastLogin) {
	$dateLine = $line.Split(",")[1].Split(" ")[0]
	if (!$dateLine) {
		# set empty date to start of logging
		$dateLine = $beginningOfLogging
	}

	$name = $line.Split(",")[0]

	# add notes of each vm, new-line is replaced with a space
	$line += "," + ($vms | where {$_.Name -eq $name}).Notes -replace "\n"," "

	# print all vms not used for at least the specified amount days and still exist
	if ((Get-Date $dateLine) -lt (Get-Date $date) -and ($vms | where { $_.Name -eq $name})) {
		$line
	}
}
