en
conf t

int g1/0
ip add 10.69.0.1 255.255.255.0
ipv6 address 2001:db8:FFF::1/64
ipv6 address fe80::1 link-local
ipv6 ospf 10 area 0
no sh

int g2/0
ip address 172.16.0.6 255.255.255.252
ipv6 address 2001:db8:4::2/64
ipv6 address fe80::2 link-local
ipv6 ospf 10 area 0
no sh 
exit

router ospf 1
 router-id 6.6.6.6
 network 10.69.0.0 0.0.0.255 area 0
 network 172.16.0.4 0.0.0.3 area 0
exit