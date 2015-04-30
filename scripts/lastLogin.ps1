# purpose: print the last time a user was connected to a vm since given time and the note field
Param(
	[string]$date = ((Get-Date).addDays(1).toString("yyyy.MM.dd") -replace "\.","/")
)

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

# silently connect to the vCenter
Connect-VIServer -Server $vcenter > $null

$usageFileLocation = $folder + "vmusage\"
$files = Get-ChildItem $usageFileLocation

$lastLogin = ""
foreach ($file in $files) {
	$lastLogin += "$file".Split(".")[0] + " : "
	$lastLogin += Get-Content "$usageFileLocation$file" | Select-String -NotMatch $exclude -Encoding UTF8 | Select -last 1
	$lastLogin += "`n"
}

$vms = Get-DesktopVM -Name vdi*
$lastLogin = $lastLogin.Split("`n")

foreach ($line in $lastLogin) {
	$dateLine = $line.Split(" ")[2]
	if (!$dateLine) {
		# set empty date to start of logging
		$dateLine = $beginningOfLogging
	}

	$name = $line.Split(" ")[0]
	$line += " " + ($vms | Select-Object Name, Description | where {$_.name -match $name}).Description

	if ((Get-Date $dateLine) -lt (Get-Date $date)) {
		$line
	}
}

