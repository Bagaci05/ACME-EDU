en
conf t

hostname S1

vlan 10
name LAN-A
vlan 20
name DMZ
exit 

monitor session 1 source interface g0/0 both 
monitor session 1 destination interface g3/2

int g0/0
switchport mode trunk
switchport trunk native vlan 100
exit

int g3/3
switchport mode access
switchport access vlan 10
exit

int g3/2
switchport mode access
switchport access vlan 20
exit
