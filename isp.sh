en
conf t

hostname ISP

ipv6 unicast-routing

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
line vty 0 4 
 transport input ssh 
exec-timeout 10 0 
 login local 
no ip http server 
no ip http secure-server

int g1/0
ip address 172.16.0.1 255.255.255.252
ipv6 address 2001:db8:a::1/64
ipv6 address fe80::2 link-local
ipv6 ospf 10 area 0
no sh
exit

int g0/0
ip address 172.16.0.5 255.255.255.252
ipv6 address 2001:db8:4::1/64
ipv6 address fe80::1 link-local
ipv6 ospf 10 area 0
no sh 
exit

router ospf 1
 router-id 3.3.3.3
 network 172.16.0.0 0.0.0.3 area 0
 network 172.16.0.4 0.0.0.3 area 0
exit

ipv6 router ospf 10
 router-id 3.3.3.3
exit