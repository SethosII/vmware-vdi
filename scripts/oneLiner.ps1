# documentation: https://www.vmware.com/support/developer/PowerCLI/index.html

# connect to vCenter
Connect-VIServer -Server "server"

# connect to the view broker remotely
Enter-PSSession -ComputerName "viewBroker" -Credential (Get-Credential)

# open vm console from powershell in browser window (needs browser plugin)
Open-VMConsoleWindow -VM "vmName"

# move vms between datastores (with shutdown of guest and start afterwards
foreach ($vm in Get-VM -Datastore "oldDatastore") {Shutdown-VMGuest -VM $vm -Confirm:$false; Move-VM -VM $vm -Datastore (Get-Datastore -Name "newDatastore") ; Start-VM -VM $vm -Confirm:$false}

# change network for all vms on specific host
Get-VM |  where {$_.VMHost.Name -eq "127.0.0.1" } | Get-NetworkAdapter | where {$_.NetworkName -eq "oldNet" } | Set-NetworkAdapter -NetworkName "newNet" -Confirm:$false

# get specific informations for vms, some possible properties:
# Name, PowerState, Description, Guest, NumCpu, MemoryGB, HardDisks, NetworkAdapters, Host, Folder, ResourcePool
foreach ($vm in Get-VM -Name "vdi*") {echo $vm.Name $vm.Guest.IPAddress}

# move all powered down vms to a certain host
Get-VM -Name "vdi*" | where {$_.PowerState -eq "PoweredOff" } | Move-VM -Destination "IP address"

# count objects
(<objects> | Measure-Object -Property "property").Count

# get properties of objects
<object> | Format-List *

# wait for certain amount of time
Start-Sleep <time in seconds>

# ADSI-Edit
# Connect to...: Name: View, Connection Point/Distinguished Name: dc=vdi, dc=vmware, dc=int, Computer/Domain: localhost
# VM Dataset: pae-displayname=<vmname>
# persistent Disk: pae-DataDiskDatastorePath=<*vmname*>
# change vCenter folder: DC=vdi..., OU=Server Groups, CN=<Pool>, pae-VmPath set to folder in vCenter
# add VM to automated pool: DC=vdi..., OU=Server Groups, CN=<Pool>, pae-ServerPoolType to 5 (manual), add vm set pool type back to original
