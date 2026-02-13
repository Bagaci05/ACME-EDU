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

int g1/0
ip address 192.168.2.1 255.255.255.0
ipv6 address 2001:db8:3::1/64
ipv6 address fe80::1 link-local
ipv6 ospf 10 area 0 
no sh
exit

int s2/0
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
passive-interface g1/0 
exit

ip access-list standard VTY_ONLY 
permit 192.168.1.0 0.0.0.255 
deny any log 
exit

ip access-list extended BRANCH_POLICY 
deny ip 192.168.2.0 0.0.0.255 192.168.1.0 0.0.0.255 log 
permit udp 192.168.2.0 0.0.0.255 any eq 53 
permit tcp 192.168.2.0 0.0.0.255 any eq 53 
permit tcp 192.168.2.0 0.0.0.255 any eq 80 
permit tcp 192.168.2.0 0.0.0.255 any eq 443 
permit icmp 192.168.2.0 0.0.0.255 any 
deny ip any any log
exit

interface g1/0 
ip access-group BRANCH_POLICY in 
exit

line vty 0 4 
access-class VTY_ONLY in 
exit

router ospfv3 10 
router-id 2.2.2.2

username R1 password ChapSecret! 
interface s2/0
encapsulation ppp 
ppp authentication chap 
no shutdown 
exit

ip access-list extended VPN-TRAFFIC 
permit ip 192.168.2.0 0.0.0.255 192.168.1.0 0.0.0.255

crypto isakmp policy 10 
encr aes 
hash sha 
authentication pre-share 
group 2 
lifetime 86400 
crypto isakmp key IpsecPSK! address 10.0.0.1
crypto ipsec transform-set TS esp-aes esp-sha-hmac 
mode tunnel
crypto map CMAP 10 ipsec-isakmp 
set peer 10.0.0.1
set transform-set TS 
match address VPN-TRAFFIC 
interface s2/0
crypto map CMAP 
end
wr