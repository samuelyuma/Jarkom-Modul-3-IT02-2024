echo nameserver 192.168.122.1 > /etc/resolv.conf

apt-get update
apt-get install isc-dhcp-server -y

echo '
INTERFACESv4="eth0"
' > /etc/default/isc-dhcp-server

echo '
# Switch 1 - Harkonen
subnet 192.234.1.0 netmask 255.255.255.0 {
	range 192.234.1.14 192.234.1.28;
	range 192.234.1.49 192.234.1.70;
	option routers 192.234.1.1;
	option broadcast-address 192.234.1.255;
	option domain-name-servers 192.234.3.2; # IP Irulan
	default-lease-time 300; # 5 menit
	max-lease-time 5220; # 87 menit
}

# Switch 2 - Atreides
subnet 192.234.2.0 netmask 255.255.255.0 {
	range 192.234.2.15 192.234.2.25;
	range 192.234.2.200 192.234.2.210;
	option routers 192.234.2.1;
	option broadcast-address 192.234.2.255;
	option domain-name-servers 192.234.3.2; # IP Irulan
	default-lease-time 1200; # 30 menit
	max-lease-time 5220; # 87 menit
}

# Switch 3
subnet 192.234.3.0 netmask 255.255.255.0 {}

# Switch 4
subnet 192.234.4.0 netmask 255.255.255.0 {}
' >  /etc/dhcp/dhcpd.conf

service isc-dhcp-server start