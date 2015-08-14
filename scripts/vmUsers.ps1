# purpose: print all users that connected in the last x days
Param(
	[string]$date = ((Get-Date).addDays(-150).toString("yyyy.MM.dd") -replace "\.","/")
)

# load necessary plugin
. "C:\Program Files\VMware\VMware View\Server\extras\PowerShell\add-snapin.ps1"
. "C:\path\scripts\constants.ps1"

# silently connect to the vCenter
Connect-VIServer -Server $vcenter > $null

# get all usage files
$usageFileLocation = $folder + "vmusage\"
$files = Get-ChildItem $usageFileLocation

# to store last found user for better performance
$cachedUser = ""

# logins is an array
$logins = @()

foreach ($file in $files) {
	$content = Get-Content "$usageFileLocation$file"
	foreach ($i in ($content.length - 1)..0) {
		# get date from the current line
		$line = $content[$i]
		$dateLine = $line.Split(",")[0]

		if ((Get-Date $dateLine) -gt (Get-Date $date)) {
			# date is within given range
			$user = $line.Split(",")[1]
			if ($user -ne $cachedUser) {
				# add user to the list and update cache
				$logins += $user
				$cachedUser = $user
			}
		} else {
			# all further lines contain older entries, stop
			break
		}
	}
}

# store each user only once without certain users
$logins = $logins | sort -Unique | Select-String -NotMatch $exclude -Encoding "UTF8"
$logins | Out-File -FilePath $folder"vmUsers.csv" -Encoding "UTF8"
$logins | Out-File -FilePath $remoteStore"vmUsers.csv" -Encoding "UTF8"
