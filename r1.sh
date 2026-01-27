en
conf t

hostname R1

ipv6 unicast-routing

# AAA Config

aaa new-model
radius server RAD1
 address ipv4 192.168.1.130 auth-port 1812 acct-port 1813
 key cisco123
exit

aaa group server radius RAD-GRP
 server name RAD1
exit

aaa authentication login VTY-AUTH group RAD-GRP local
aaa authorization exec VTY-AUTH group RAD-GRP local if-authenticated
aaa accounting exec VTY-ACCT start-stop group RAD-GRP


no ip domain-lookup
service password-encryption
security passwords min-length 10
login block-for 60 attempts 3 within 60
banner motd ^CUnauthorized access prohibited.^C

enable secret Adm1nP@ss!
username admin privilege 15 secret Adm1nP@ss!
ip domain-name acme-edu.local
crypto key generate rsa 
1024

line con 0 
 logging synchronous 
 exec-timeout 10 0 
exit

line vty 0 15
 transport input ssh 
 exec-timeout 10 0 
 login authentication VTY-AUTH
 authorization exec VTY-AUTH
 accounting exec VTY-ACCT
exit 

ip ssh version 2


no ip http server 
no ip http secure-server


int g0/0 
no sh



int g0/0.10
encaps dot 10
ip address 192.168.1.1 255.255.255.128
ipv6 address 2001:db8:1::1/64
ipv6 address fe80::1 link-local
no sh



int g0/0.20 
encaps dot 20
ip address 192.168.1.129 255.255.255.128
ipv6 address 2001:db8:2::1/64
ipv6 address fe80::1 link-local
no sh



int g1/0
ip address 10.0.0.1 255.255.255.0
ipv6 address 2001:db8:b::1/64
ipv6 address fe80::1 link-local
no sh


int g2/0
ip address 172.16.0.2 255.255.255.252
ipv6 address 2001:db8:a::2/64
ipv6 address fe80::1 link-local
no sh
exit


ip dhcp exc 192.168.1.1
ip dhcp exc 192.168.1.129
ip dhcp exc 192.168.1.130


ip dhcp pool lanA
network 192.168.1.0 255.255.255.128
default 192.168.1.1
exit



ip dhcp pool DMZ
network 192.168.1.128 255.255.255.128
default 192.168.1.129
exit



router ospf 1
 router-id 1.1.1.1
 network 10.0.0.0 0.0.0.255 area 0
 network 192.168.1.0 0.0.0.127 area 0
 network 192.168.1.128 0.0.0.127 area 0
 network 172.16.0.0 0.0.0.3 area 0
 passive-interface g0/0 
exit



interface g0/0.10
 ipv6 ospf 10 area 0
 ip ospf priority 200 
interface g0/0.20
 ipv6 ospf 10 area 0
 ip ospf priority 200 
interface g1/0
 ipv6 ospf 10 area 0
interface g2/0
 ipv6 ospf 10 area 0
exit



router ospfv3 10
 router-id 1.1.1.1
exit



ip route 0.0.0.0 0.0.0.0 172.16.0.1
router ospf 1
 default-information originate
