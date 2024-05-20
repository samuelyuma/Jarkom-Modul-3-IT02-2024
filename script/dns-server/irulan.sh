echo nameserver 192.168.122.1 > /etc/resolv.conf

apt-get update
apt-get install bind9 -y

service bind9 start

echo '
// Soal 0
zone "atreides.it02.com" {
 	type master;
 	file "/etc/bind/it02/atreides.it02.com";
};

zone "harkonen.it02.com" {
 	type master;
 	file "/etc/bind/it02/harkonen.it02.com";
};
'> /etc/bind/named.conf.local

mkdir /etc/bind/it02

# Soal 0
cp /etc/bind/db.local /etc/bind/it02/atreides.it02.com
cp /etc/bind/db.local /etc/bind/it02/harkonen.it02.com

echo '
; BIND data file for Atreides domain to Leto (Soal 0)
$TTL    604800
@       IN      SOA     atreides.it02.com. atreides.it02.com. (
                        2				; Serial
                        604800			; Refresh
                        86400			; Retry
                        2419200         ; Expire
                        604800 )		; Negative Cache TTL
;
@			IN      NS      atreides.it02.com.
@			IN      A       192.234.2.2 ; IP Leto
www			IN      CNAME   atreides.it02.com.
' > /etc/bind/it02/atreides.it02.com

echo '
; BIND data file for Harkonen domain to Vladimir (Soal 0)
$TTL    604800
@       IN      SOA     harkonen.it02.com. harkonen.it02.com. (
                        2				; Serial
                        604800			; Refresh
                        86400			; Retry
                        2419200         ; Expire
                        604800 )		; Negative Cache TTL
;
@			IN      NS      harkonen.it02.com.
@			IN      A       192.234.1.2 ; IP Vladimir
www			IN      CNAME   harkonen.it02.com.
' > /etc/bind/it02/harkonen.it02.com

echo '
options {
	directory "/var/cache/bind";

	forwarders {
		192.168.122.1;
	};

	allow-query{any;};
	auth-nxdomain no;
	listen-on-v6 { any; };
};
' >/etc/bind/named.conf.options

service bind9 restart

# Soal 18
echo '
; BIND data file for Atreides domain to Stilgar (Soal 18)
$TTL    604800
@       IN      SOA     atreides.it02.com. atreides.it02.com. (
                        2				; Serial
                        604800			; Refresh
                        86400			; Retry
                        2419200         ; Expire
                        604800 )		; Negative Cache TTL
;
@			IN      NS      atreides.it02.com.
@			IN      A       192.234.4.3 ; IP Stilgar
www			IN      CNAME   atreides.it02.com.
' > /etc/bind/it02/atreides.it02.com