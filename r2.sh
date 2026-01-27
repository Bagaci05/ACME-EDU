en
conf t

hostname R2
ipv6 unicast-routing


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
crypto key generate rsa modulus 1024

line con 0 
 logging synchronous 
exec-timeout 10 0 
 login local 
line vty 0 15
 transport input ssh 
 exec-timeout 10 0 
 login authentication VTY-AUTH
 authorization exec VTY-AUTH
 accounting exec VTY-ACCT
exit 

ip ssh version 2

exec-timeout 10 0 
 login local 
no ip http server 
no ip http secure-server

int g0/0
ip address 192.168.2.1 255.255.255.0
ipv6 address 2001:db8:3::1/64
ipv6 address fe80::1 link-local
ipv6 ospf 10 area 0 
no sh
exit

int g1/0
ip address 10.0.0.2 255.255.255.0
ipv6 address 2001:db8:b::1/64
ipv6 address fe80::2 link-local
ipv6 ospf 10 area 0 
no sh
exit

router ospf 1 
 router-id 2.2.2.2 
 network 10.0.0.0 0.0.0.255 area 0 
 network 192.168.2.0 0.0.0.255 area 0 
 passive-interface g0/0 
exit

router ospfv3 10 
 router-id 2.2.2.2