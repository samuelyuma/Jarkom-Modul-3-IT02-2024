# Jarkom-Modul-3-IT02-2024

Kelompok IT02 :
| Nama | NRP |
| -------------------- | ---------- |
| Samuel Yuma Krismata | 5027221029 |
| Marselinus Krisnawan Riandika | 5027221056 |

## Daftar Isi

[Soal 0](#soal-0)</br>
[Soal 1](#soal-1)</br>
[Soal 2](#soal-2)</br>
[Soal 3](#soal-3)</br>
[Soal 4](#soal-4)</br>
[Soal 5](#soal-5)</br>
[Soal 6](#soal-6)</br>
[Soal 7](#soal-7)</br>
[Soal 8](#soal-8)</br>
[Soal 9](#soal-9)</br>
[Soal 10](#soal-10)</br>
[Soal 11](#soal-11)</br>
[Soal 12](#soal-12)</br>
[Soal 13](#soal-13)</br>
[Soal 14](#soal-14)</br>
[Soal 15](#soal-15)</br>
[Soal 16](#soal-16)</br>
[Soal 17](#soal-17)</br>
[Soal 18](#soal-18)</br>
[Soal 19](#soal-19)</br>
[Soal 20](#soal-20)</br>

### Topologi

![Topologi](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/f06ac378-12fe-44f0-861c-83a71af0045e)

### Network Configuration

#### Arakis (Router / DHCP Relay)

```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.234.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.234.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.234.3.1
	netmask 255.255.255.0

auto eth4
iface eth4 inet static
	address 192.234.4.1
	netmask 255.255.255.0
```

#### Mohiam (DHCP Server)

```
auto eth0
iface eth0 inet static
	address 192.234.3.3
	netmask 255.255.255.0
	gateway 192.234.3.1
```

#### Irulan (DNS Server)

```
auto eth0
iface eth0 inet static
	address 192.234.3.2
	netmask 255.255.255.0
	gateway 192.234.3.1
```

#### Chani (Database Server)

```
auto eth0
iface eth0 inet static
	address 192.234.4.2
	netmask 255.255.255.0
	gateway 192.234.4.1
```

#### Stilgar (Load Balancer)

```
auto eth0
iface eth0 inet static
	address 192.234.4.3
	netmask 255.255.255.0
	gateway 192.234.4.1
```

#### Leto (Laravel Worker)

```
auto eth0
iface eth0 inet static
	address 192.234.2.2
	netmask 255.255.255.0
	gateway 192.234.2.1
```

#### Duncan (Laravel Worker)

```
auto eth0
iface eth0 inet static
	address 192.234.2.3
	netmask 255.255.255.0
	gateway 192.234.2.1
```

#### Jessica (Laravel Worker)

```
auto eth0
iface eth0 inet static
	address 192.234.2.4
	netmask 255.255.255.0
	gateway 192.234.2.1
```

#### Vladimir (PHP Worker)

```
auto eth0
iface eth0 inet static
	address 192.234.1.2
	netmask 255.255.255.0
	gateway 192.234.1.1
```

#### Rabban (PHP Worker)

```
auto eth0
iface eth0 inet static
	address 192.234.1.3
	netmask 255.255.255.0
	gateway 192.234.1.1
```

#### Feyd (PHP Worker)

```
auto eth0
iface eth0 inet static
	address 192.234.1.4
	netmask 255.255.255.0
	gateway 192.234.1.1
```

#### Dmitri & Paul (Client)

```
auto eth0
iface eth0 inet dhcp
```

### Konfigurasi Tambahan

Perlu dilakukan konfigurasi pada node Arakis agar setiap node yang ada dalam jaringan dapat mengakses internet luar. Untuk itu, tambahkan command berikut pada node Arakis:

```
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.234.0.0/16
```

Selain itu, perlu dilakukan konfigurasi nameserver pada setiap node. Untuk itu, tambahkan line berikut pada file `/etc/resolv.conf` di semua node, (kecuali node Dmitri dan Paul):

```
nameserver 192.168.122.1
```

## Soal 0

Planet Caladan sedang mengalami krisis karena kehabisan spice, klan atreides berencana untuk melakukan eksplorasi ke planet arakis dipimpin oleh duke leto mereka meregister domain name **atreides.yyy.com** untuk worker laravel mengarah pada Leto **Atreides**. Namun ternyata tidak hanya klan atreides yang berusahan melakukan eksplorasi, Klan harkonen sudah mendaftarkan domain name **harkonen.yyy.com** untuk worker PHP mengarah pada Vladimir **Harkonen**.

## Setup DNS pada Irulan (DNS Server)

a. Instalasi dependencies yang diperlukan

```
apt-get update
apt-get install bind9 -y
```

b. Menjalankan service dari bind9

```
service bind9 start
```

c. Menambahkan line berikut pada file `etc/bind/named.conf.local`

```
zone "atreides.it02.com" {
 	type master;
 	file "/etc/bind/it02/atreides.it02.com";
};

zone "harkonen.it02.com" {
 	type master;
 	file "/etc/bind/it02/harkonen.it02.com";
};
```

d. Membuat DNS record pada `/etc/bind/it02/atreides.it02.com`

```
$TTL    604800
@       IN      SOA     atreides.it02.com. atreides.it02.com. (
                        2				; Serial
                        604800			; Refresh
                        86400			; Retry
                        2419200         ; Expire
                        604800 )		; Negative Cache TTL
;
@		IN      NS      atreides.it02.com.
@		IN      A       192.234.2.2 ; IP Leto
www		IN      CNAME   atreides.it02.com.
```

e. Membuat DNS record pada `/etc/bind/it02/harkonen.it02.com`

```
$TTL    604800
@       IN      SOA     harkonen.it02.com. harkonen.it02.com. (
                        2				; Serial
                        604800			; Refresh
                        86400			; Retry
                        2419200         ; Expire
                        604800 )		; Negative Cache TTL
;
@		IN      NS      harkonen.it02.com.
@		IN      A       192.234.1.2 ; IP Vladimir
www		IN      CNAME   harkonen.it02.com.
```

f. Merestart service dari bind9

```
service bind9 restart
```

## Soal 1

Lakukan konfigurasi sesuai dengan peta yang sudah diberikan. Semua **CLIENT** harus menggunakan konfigurasi dari DHCP Server

### Setup DHCP Server (Mohiam)

a. Instalasi dependencies yang diperlukan

```
apt-get update
apt-get install isc-dhcp-server -y
```

b. Menjalankan service dari isc-dhcp-server

```
service isc-dhcp-server start
```

c. Menambahkan line berikut pada file `/etc/default/isc-dhcp-server`

```
INTERFACES="eth0"
```

d. Menambahkan line berikut pada file `/etc/dhcp/dhcpd.conf`

```
subnet 192.234.1.0 netmask 255.255.255.0 {
	option routers 192.234.1.0;
	option broadcast-address 192.234.1.255;
	option domain-name-servers 192.234.3.2;
}

subnet 192.234.2.0 netmask 255.255.255.0 {
	option routers 192.234.2.0;
	option broadcast-address 192.234.2.255;
	option domain-name-servers 192.234.3.2;
}

subnet 192.234.3.0 netmask 255.255.255.0 {}

subnet 192.234.4.0 netmask 255.255.255.0 {}
```

e. Merestart service dari isc-dhcp-server

```
service isc-dhcp-server restart
```

### Setup DHCP Relay (Arakis)

a. Instalasi dependencies yang diperlukan

```
apt-get update
apt-get install isc-dhcp-relay -y
```

b. Menjalankan service dari isc-dhcp-relay

```
service isc-dhcp-relay start
```

c. Menambahkan line berikut pada file `/etc/default/isc-dhcp-relay`

```
SERVERS="192.234.3.3"
INTERFACES="eth1 eth2 eth3 eth4"
OPTIONS=""
```

d. Menambahkan line berikut pada file `/etc/sysctl.conf`

```
net.ipv4.ip_forward=1
```

e. Merestart service dari isc-dhcp-relay

```
service isc-dhcp-relay restart
```

f. Menampilkan status dari isc-dhcp-relay

```
service isc-dhcp-relay status
```

## Soal 2

Client yang melalui House Harkonen mendapatkan range IP dari [prefix IP].1.14 - [prefix IP].1.28 dan [prefix IP].1.49 - [prefix IP].1.70

### Setup DHCP Server (Mohiam)

a. Edit konfigurasi `subnet 192.234.1.0` pada file `/etc/dhcp/dhcpd.conf` menjadi seperti berikut

```
subnet 192.234.1.0 netmask 255.255.255.0 {
	range 192.234.2.15 192.234.2.25;
	range 192.234.2.200 192.234.2.210;
	option routers 192.234.1.0;
	option broadcast-address 192.234.1.255;
}
```

e. Merestart service dari isc-dhcp-server

```
service isc-dhcp-server restart
```

## Soal 3

Client yang melalui House Atreides mendapatkan range IP dari [prefix IP].2.15 - [prefix IP].2.25 dan [prefix IP].2.200 - [prefix IP].2.210

### Setup DHCP Server (Mohiam)

### Setup DHCP Server (Mohiam)

a. Edit konfigurasi `subnet 192.234.2.0` pada file `/etc/dhcp/dhcpd.conf` menjadi seperti berikut

```
subnet 192.234.2.0 netmask 255.255.255.0 {
	range 192.234.1.14 192.234.1.28;
	range 192.234.1.49 192.234.1.70;
	option routers 192.234.2.0;
	option broadcast-address 192.234.2.255;
}
```

e. Merestart service dari isc-dhcp-server

```
service isc-dhcp-server restart
```

### Testing

![Soal 2 dan 3](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/b3325169-fd76-4f28-8c41-00959b782ea7)

## Soal 4

Client mendapatkan DNS dari Princess Irulan dan dapat terhubung dengan internet melalui DNS tersebut

### Setup DHCP Server (Mohiam)

a. Edit konfigurasi `subnet 192.234.1.0` dan `subnet 192.234.2.0` pada file `/etc/dhcp/dhcpd.conf` menjadi seperti berikut

```
subnet 192.234.1.0 netmask 255.255.255.0 {
	range 192.234.2.15 192.234.2.25;
	range 192.234.2.200 192.234.2.210;
	option routers 192.234.1.0;
	option broadcast-address 192.234.1.255;
	option domain-name-servers 192.234.3.2;
}

subnet 192.234.2.0 netmask 255.255.255.0 {
	range 192.234.1.14 192.234.1.28;
	range 192.234.1.49 192.234.1.70;
	option routers 192.234.2.0;
	option broadcast-address 192.234.2.255;
	option domain-name-servers 192.234.3.2;
}
```

e. Merestart service dari isc-dhcp-server

```
service isc-dhcp-server restart
```

### Testing

![Soal 4](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/0c2c0e1b-9d0a-4d51-bc16-2a41c1be08f2)

## Soal 5

Durasi DHCP server meminjamkan alamat IP kepada Client yang melalui House Harkonen selama 5 menit sedangkan pada client yang melalui House Atreides selama 20 menit. Dengan waktu maksimal dialokasikan untuk peminjaman alamat IP selama 87 menit.

### Setup DHCP Server (Mohiam)

a. Edit konfigurasi `subnet 192.234.1.0` dan `subnet 192.234.2.0` pada file `/etc/dhcp/dhcpd.conf` menjadi seperti berikut

```
subnet 192.234.1.0 netmask 255.255.255.0 {
	range 192.234.2.15 192.234.2.25;
	range 192.234.2.200 192.234.2.210;
	option routers 192.234.1.0;
	option broadcast-address 192.234.1.255;
	option domain-name-servers 192.234.3.2;
	default-lease-time 1200;
	max-lease-time 5220;
}

subnet 192.234.2.0 netmask 255.255.255.0 {
	range 192.234.1.14 192.234.1.28;
	range 192.234.1.49 192.234.1.70;
	option routers 192.234.2.0;
	option broadcast-address 192.234.2.255;
	option domain-name-servers 192.234.3.2;
	default-lease-time 300;
	max-lease-time 5220;
}
```

e. Merestart service dari isc-dhcp-server

```
service isc-dhcp-server restart
```

### Testing

![Soal 5](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/1a199a22-c357-4485-9867-7684ebd3e198)

## Soal 6

Vladimir Harkonen memerintahkan setiap worker(harkonen) PHP, untuk melakukan konfigurasi virtual host untuk website berikut dengan menggunakan php 7.3

### Setup PHP Worker (Vladimir, Rabban, & Feyd)

a. Instalasi dependencies yang diperlukan

```
apt-get update
apt-get install lynx nginx wget unzip php7.3 php-fpm -y
```

b. Menjalankan service dari php-fpm dan nginx

```
service php7.3-fpm start
service nginx start
```

c. Untuh file `harkonen.zip` dan letakkan isinya pada directory `/var/www/html/`

```
mkdir -p /var/www/html/download/

wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1lmnXJUbyx1JDt2OA5z_1dEowxozfkn30' -O /var/www/html/download/harkonen.zip

unzip /var/www/html/download/harkonen.zip -d /var/www/html/download/

mv /var/www/html/download/modul-3/* /var/www/html/

rm -rf /var/www/html/download/
```

d. Menambahkan line berikut pada file `/etc/nginx/sites-available/jarkom-it02.conf`

```
server {
    listen 80;

    root /var/www/html;

    index index.php index.html index.htm;

    server_name _;

	location / {
		try_files \$uri \$uri/ /index.php?\$query_string;
	}

	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
	}

    error_log /var/log/nginx/jarkom-it02_error.log;
    access_log /var/log/nginx/jarkom-it02_access.log;
}
```

e. f. Buat symlink `jarkom-it02` pada `/etc/nginx/sites-available/` di `/etc/nginx/sites-enabled`

```
ln -s /etc/nginx/sites-available/load-balancer-it02 /etc/nginx/sites-enabled
```

f. Hapus `default` pada `/etc/nginx/sites-enabled/`

```
rm /etc/nginx/sites-enabled/default
```

g. Restart service nginx dan php-fpm

```
service nginx restart
service php7.3-fpm restart
```

### Testing

Testing dilakukan dengan menjalankan command berikut

```
lynx 192.234.1.2
```

![Soal 6 - 1](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/05f74bf6-5573-4b62-ab81-e2643c4fb395)

```
lynx 192.234.1.3
```

![Soal 6 - 2](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/df6e6115-f90c-4db3-a5f4-7c284e8fcc69)

```
lynx 192.234.1.4
```

![Soal 6 - 3](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/b29ac9e9-f098-4678-8d68-7af8712c795e)

## Soal 7

Aturlah agar Stilgar dari fremen dapat dapat bekerja sama dengan maksimal, lalu lakukan testing dengan 5000 request dan 150 request/second.

### Setup Load Balancer (Stilgar)

a. Instalasi dependencies yang diperlukan

```
apt-get update
apt-get install lynx nginx php7.3 php-fpm -y
```

b. Menjalankan service dari php-fpm dan nginx

```
$ service php7.3-fpm start
$ service nginx start
```

c. Menambahkan line berikut pada file `/etc/nginx/sites-available/load-balancer-it02.conf`

```
upstream worker {
	# least_conn;
    # ip_hash;
    # hash $request_uri consistent;
	# random two least_conn;
	server 192.234.1.2; # IP Vladimir
	server 192.234.1.3; # IP Rabban
	server 192.234.1.4; # IP Feyd
}

server {
	listen 80;

	root /var/www/html;

    index index.html index.htm index.nginx-debian.html;

    server_name _;

	location / {
		# Soal 10
		auth_basic "Restricted Content";
		auth_basic_user_file /etc/nginx/supersecret/htpasswd;
		proxy_pass http://worker;
	}
}
```

e. f. Buat symlink `load-balancer-it02` pada `/etc/nginx/sites-available/` di `/etc/nginx/sites-enabled`

```
ln -s /etc/nginx/sites-available/load-balancer-it02 /etc/nginx/sites-enabled
```

f. Hapus `default` pada `/etc/nginx/sites-enabled/`

```
rm /etc/nginx/sites-enabled/default
```

g. Restart service nginx dan php-fpm

```
service nginx restart
service php7.3-fpm restart
```

### Testing

Testing dilakukan dengan menjalankan command berikut

```
ab -n 1000 -c 100 http://192.234.4.3/
```

![Soal 7](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/9954fdb4-babb-4e98-9b6d-58b23977fc9f)

## Soal 8

Karena diminta untuk menuliskan peta tercepat menuju spice, buatlah analisis hasil testing dengan 500 request dan 50 request/second masing-masing algoritma Load Balancer dengan ketentuan sebagai berikut:

-   Nama Algoritma Load Balancer
-   Report hasil testing pada Apache Benchmark
-   Grafik request per second untuk masing masing algoritma.
-   Analisis

## Soal 9

Dengan menggunakan algoritma Least-Connection, lakukan testing dengan menggunakan 3 worker, 2 worker, dan 1 worker sebanyak 1000 request dengan 10 request/second, kemudian tambahkan grafiknya pada peta.

## Soal 10

Selanjutnya coba tambahkan keamanan dengan konfigurasi autentikasi di LB dengan dengan kombinasi username: “secmart” dan password: “kcksyyy”, dengan yyy merupakan kode kelompok. Terakhir simpan file “htpasswd” nya di /etc/nginx/supersecret/

### Setup Load Balancer (Stilgar)

a. Instalasi dependencies yang diperlukan

```
apt-get update
apt-get install apache2-utils -y
```

b. Membuat folder supersecret

```
mkdir -p /etc/nginx/supersecret
```

c. Buat file `htpasswd` dengan username dan password yang telah ditentukan

```
htpasswd -cb /etc/nginx/supersecret/htpasswd secmart kcksit02
```

d. Menjalankan service dari php-fpm dan nginx

```
service php7.3-fpm start
service nginx start
```

e. Edit konfigurasi `server` pada file `/etc/nginx/sites-available/load-balancer-it02.conf` menjadi seperti berikut

```
server {
	listen 80;

	root /var/www/html;

    index index.html index.htm index.nginx-debian.html;

    server_name _;

	location / {
		auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/supersecret/htpasswd;
        proxy_pass http://worker;
	}
}
```

f. Restart service nginx dan php-fpm

```
service nginx restart
service php7.3-fpm restart
```

### Testing

Testing dilakukan dengan menjalankan command berikut

```
lynx 192.234.4.3
```

![Soal 10 - 1](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/2b2cd024-fdee-49d0-b6ad-bef7acbd3432)
![Soal 10 - 2](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/f7ddcaba-65f1-421f-8d7f-7cfbb4a6404e)
![Soal 10 - 3](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/51fe6f16-eedc-468f-8fd4-cac6ed2295b1)

## Soal 11

Lalu buat untuk setiap request yang mengandung /dune akan di proxy passing menuju halaman https://www.dunemovie.com.au/.

### Setup Load Balancer (Stilgar)

a. Edit konfigurasi `server` pada file `/etc/nginx/sites-available/load-balancer-it02.conf` menjadi seperti berikut

```
server {
    listen 80;

    root /var/www/html;

    index index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/supersecret/htpasswd;
        proxy_pass http://worker;
	}

    location /dune {
        proxy_pass https://www.dunemovie.com.au/;
        proxy_set_header Host www.dunemovie.com.au;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
	}
}
```

b. Restart service nginx dan php-fpm

```
service nginx restart
service php7.3-fpm restart
```

### Testing

Testing dilakukan dengan menjalankan command berikut

```
lynx 192.234.4.3/dune
```

![Soal 11](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/9394edaf-a543-4aca-ba9b-ae8f5eadc2e3)

## Soal 12

Selanjutnya LB ini hanya boleh diakses oleh client dengan IP [Prefix IP].1.37, [Prefix IP].1.67, [Prefix IP].2.203, dan [Prefix IP].2.207.

a. Edit konfigurasi `server` pada file `/etc/nginx/sites-available/load-balancer-it02.conf` menjadi seperti berikut

```
server {
    listen 80;

    root /var/www/html;

    index index.html index.htm index.nginx-debian.html;

    server_name _;

	location / {
		allow 192.234.1.37;
		allow 192.234.1.67;
		allow 192.234.2.203;
		allow 192.234.2.207;
		deny all;

        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/supersecret/htpasswd;
        proxy_pass http://worker;
	}

	location /dune {
        proxy_pass https://www.dunemovie.com.au/;
        proxy_set_header Host www.dunemovie.com.au;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
	}
}
```

b. Restart service nginx dan php-fpm

```
service nginx restart
service php7.3-fpm restart
```

### Testing

Testing dijalankan dengan menggunakan command berikut

```
lynx 192.234.4.3
```

![Soal 12 - 1](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/1fbdf586-fde4-44fa-84bb-4fe18045ab34)

**FYI**: Section atas adalah client **Paul** dan section bawah adalah client **Dmitri**

Untuk membuatnya dapat mengakses load balancer, IP client harus dimasukkan pada daftar **allow** di server. Adapun untuk mendapatkan IP client dapat dilakukan dengan cara berikut:

a. Akses load balancer menggunakan client dengan command `lynx 192.234.4.3`

b. Masukkan command `tail -f /var/log/nginx/access.log` di console load balancer

![Soal 12 - 2](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/fbf0d870-6882-4371-b6ff-d1adfd62ac91)

b. Perhatikan pada baris terakhir dan catat IPnya. IP tersebut adalah IP dari client (Paul), yaitu `192.234.2.16`

d. Masuk ke file `load-balancer-it02` dengan command `nano /etc/nginx/sites-available/load-balancer-it02
`
c. Tambahkan IP tersebut pada bagian `# IP Client`

```
location / {
	allow 192.234.1.37;
	allow 192.234.1.67;
	allow 192.234.2.203;
	allow 192.234.2.207;
	# IP Client
	deny all;

	auth_basic "Restricted Content";
	auth_basic_user_file /etc/nginx/supersecret/htpasswd;
	proxy_pass http://worker;
}
```

sehingga nantinya menjadi

```
location / {
	allow 192.234.1.37;
	allow 192.234.1.67;
	allow 192.234.2.203;
	allow 192.234.2.207;
	allow 192.234.2.16;
	deny all;

	auth_basic "Restricted Content";
	auth_basic_user_file /etc/nginx/supersecret/htpasswd;
	proxy_pass http://worker;
}
```

d. Save file tersebut dan restart service nginx dengan `service nginx restart`

e. Akses kembali load balancer menggunakan client sebelumnya dengan command `lynx 192.234.4.3`

![Soal 12 - 3](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/4053ebc8-f5f3-4208-b516-6b5da99a5651)

**FYI**: Section atas adalah client **Paul** dan section bawah adalah client **Dmitri** dan dapat dilihat bahwa client **Paul** sudah dapat mengakses load balancer.

## Soal 13

Semua data yang diperlukan, diatur pada Chani dan harus dapat diakses oleh Leto, Duncan, dan Jessica.

### Setup Database Server (Chani)

a. Instalasi dependencies yang diperlukan

```
apt-get update
apt-get install mariadb-server -y
```

b. Memulai service dari mysql

```
service mysql start
```

c. Membuat konfigurasi `mysql` sebagai berikut

```
CREATE USER 'kelompokit02'@'%' IDENTIFIED BY 'passwordit02';
CREATE USER 'kelompokit02'@'localhost' IDENTIFIED BY 'passwordit02';
CREATE DATABASE dbkelompokit02;
GRANT ALL PRIVILEGES ON *.* TO 'kelompokit02'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'kelompokit02'@'localhost';
FLUSH PRIVILEGES;
```

d. Akses ke database mysql dengan username `kelompokit02` dan `passwordit02` lalu tampilkan semua database dengan command

```
SHOW DATABASES;
```

e. Tambahkan line berikut pada file `/etc/mysql/my.cnf`

```
[mysqld]
skip-networking=0
skip-bind-address
```

d. Restart service dari mysql

```
service mysql restart
```

### Setup Laravel Worker (Leto, Duncan, Jessica)

a. Instalasi dependencies yang diperlukan

```
apt-get update
apt-get install mariadb-server -y
```

### Testing

![Soal 13 - 1](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/a3c1f2fa-bb23-418e-8a75-ea1241fb345d)

Testing dilakukan dengan menjalankan command berikut pada client

```
mariadb --host=192.234.4.2 --port=3306 --user=kelompokit02 --password
```

![Soal 13 - 2](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/f23931f3-ad8d-439e-926d-604a73d2b5ee)

## Soal 14

Leto, Duncan, dan Jessica memiliki **atreides** Channel sesuai dengan quest guide. Jangan lupa melakukan instalasi PHP8.0 dan Composer

### Setup Laravel Worker (Leto, Duncan, Jessica)

a. Instalasi dependencies yang diperlukan

```
apt-get update
apt-get install lsb-release ca-certificates apt-transport-https software-properties-common gnupg2 -y
```

b. Unduh GPG-key dan tambahkan dengan perintah berikut

```
curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
```

c. Instalasi php dan nginx

```
apt-get update
apt-get install php8.0-mbstring php8.0-xml php8.0-cli php8.0-common php8.0-intl php8.0-opcache php8.0-readline php8.0-mysql php8.0-fpm php8.0-curl unzip wget -y
apt-get install nginx -y
```

d. Jalankan service dari nginx dan php

```
service nginx start
service php8.0-fpm start
```

e. Instalasi Composer 2

```
wget https://getcomposer.org/download/2.0.13/composer.phar
chmod +x composer.phar
mv composer.phar /usr/bin/composer
```

f. Clone repository yang akan dideploy pada directory `/var/www` dan masuk ke directory repository tersebut

```
apt-get install git -y
cd /var/www/
git clone https://github.com/martuafernando/laravel-praktikum-jarkom
cd laravel-praktikum-jarkom
```

g. Jalankan composer dan buat file `.env` baru dengan command

```
composer update
cp .env.example .env
```

dan masukkan konfigurasi berikut ke dalam file `.env`

```
DB_CONNECTION=mysql
DB_HOST=192.234.4.2
DB_PORT=3306
DB_DATABASE=dbkelompokit02
DB_USERNAME=kelompokit02
DB_PASSWORD=passwordit02
```

h. Jalankan konfigurasi dari php artisan

```
php artisan migrate:fresh
php artisan db:seed --class=AiringsTableSeeder
php artisan key:generate
php artisan jwt:secret
```

i. Tambahkan line berikut pada file `/etc/nginx/sites-available/deployment`

```
server {
	listen <port>;

	root /var/www/laravel-praktikum-jarkom/public;

	index index.php index.html index.htm;

	server_name _;

	location / {
		try_files $uri $uri/ /index.php?$query_string;
	}

	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
	}

	location ~ /\.ht {
        deny all;
	}

    error_log /var/log/nginx/deployment_error.log;
    access_log /var/log/nginx/deployment_access.log;
}
```

**FYI**: `<port>` tersebut perlu disesuaikan lagi untuk setiap laravel worker dengan detail sebagai berikut:

-   Port `81` untuk worker **Leto**
-   Port `82` untuk worker **Duncan**
-   Port `83` untuk worker **Jessica**

j. Atur symlink untuk enable pada site

```
ln -s /etc/nginx/sites-available/deployment /etc/nginx/sites-enabled/
```

k. Atur perizinan untuk mengelola dan mengakses direktori penyimpanan

```
chown -R www-data.www-data /var/www/laravel-praktikum-jarkom/storage
```

l. Jalankan service dari php-fpm dan restart service dari nginx

```
service php8.0-fpm start
service nginx restart
```

### Testing

Testing dilakukan dengan menjalankan command berikut sesuai laravel worker

-   Worker **Leto**: `lynx localhost:81`
-   Worker **Duncan**: `lynx localhost:82`
-   Worker **Jessica**: `lynx localhost:83`

![Soal 14](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/ae33ba95-02bb-4b99-80fb-4ee76e781385)

**FYI**: Section kiri adalah worker **Leto**, section kanan atas adalah worker **Duncan**, dan section kanan bawah adalah worker **Jessica**

## Soal 15

**atreides** Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second. Tambahkan response dan hasil testing pada grimoire.

**POST /auth/register**

### Setup Laravel Worker (Leto, Duncan, Jessica)

a. Tambahkan line berikut pada file `/var/www/laravel-praktikum-jarkom/auth.json`

```
{
    "username": "kelompokit02",
    "password": "passwordit02"
}
```

## Soal 16

**atreides** Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second. Tambahkan response dan hasil testing pada grimoire.

**POST /auth/login**

## Soal 17

**atreides** Channel memiliki beberapa endpoint yang harus ditesting sebanyak 100 request dengan 10 request/second. Tambahkan response dan hasil testing pada grimoire.

**GET /me**

## Soal 18

Untuk memastikan ketiganya bekerja sama secara adil untuk mengatur **atreides** Channel maka implementasikan Proxy Bind pada Eisen untuk mengaitkan IP dari Leto, Duncan, dan Jessica.

### Setup DNS Server (Irulan)

a. Mengedit konfigurasi DNS record pada `/etc/bind/it02/proxy-bind.it02.com` dengan mengarahkannya ke IP Stilgar

```
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
```

c. Restart service dari bind9

```
service bind9 restart
```

### Setup Load Balancer (Stilgar)

a. Edit konfigurasi file `/etc/nginx/sites-available/load-balancer-it02` menjadi seperti berikut

```
upstream worker {
	server 192.234.1.2; # IP Vladimir
	server 192.234.1.3; # IP Rabban
	server 192.234.1.4; # IP Feyd
}

server {
	listen 80;

	root /var/www/html;

	index index.html index.htm index.nginx-debian.html;

	server_name atreides.it02.com www.atreides.it02.com;

	location / {
		proxy_pass http://worker;
	}
}
```

b. Restart service dari nginx

```
service nginx restart
```

### Testing

Testing ini dilakukan dengan menjalankan command berikut

```
ab -n 500 -c 50 -p auth.json -T application/json http://atreides.it02.com/api/auth/login
```

![Soal 18](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/836622b2-146d-42af-bd61-61949f5aee55)

## Soal 19

Untuk meningkatkan performa dari Worker, coba implementasikan PHP-FPM pada Leto, Duncan, dan Jessica. Untuk testing kinerja naikkan

-   pm.max_children
-   pm.start_servers
-   pm.min_spare_servers
-   pm.max_spare_servers
    sebanyak tiga percobaan dan lakukan testing sebanyak 100 request dengan 10 request/second kemudian berikan hasil analisisnya pada PDF.

### Setup Load Balancer (Stilgar)

a. Tambahkan line berikut pada file `/etc/php/8.0/fpm/pool.d/stilgar.conf`

```
[stilgar]
user = stilgar_user
group = stilgar_user
listen = /var/run/php7.3-fpm-stilgar-site.sock
listen.owner = www-data
listen.group = www-data
php_admin_value[disable_functions] = exec,passthru,shell_exec,system
php_admin_flag[allow_url_fopen] = off

; Choose how the process manager will control the number of child processes.

pm = dynamic
pm.max_children = <value>
pm.start_servers = <value>
pm.min_spare_servers = <value>
pm.max_spare_servers = <value>
pm.process_idle_timeout = 10s
```

**FYI**: Nilai dari `<value>` tersebut diatur pada saat melakukan percobaan sebagai berikut

#### Percobaan Pertama

```
pm.max_children = 10
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 5
```

#### Percobaan Kedua

```
pm.max_children = 30
pm.start_servers = 5
pm.min_spare_servers = 3
pm.max_spare_servers = 10
```

#### Percobaan Ketiga

```
pm.max_children = 50
pm.start_servers = 10
pm.min_spare_servers = 5
pm.max_spare_servers = 20
```

## Soal 20

Nampaknya hanya menggunakan PHP-FPM tidak cukup untuk meningkatkan performa dari worker maka implementasikan Least-Conn pada Stilgar. Untuk testing kinerja dari worker tersebut dilakukan sebanyak 100 request dengan 10 request/second.

### Setup Load Balancer (Stilgar)

a. Edit bagian `upstream worker` pada file `/etc/nginx/sites-available/load-balancer-it02` menjadi seperti berikut

```
upstream worker {
	least_conn;
	server 192.234.1.2; # IP Vladimir
	server 192.234.1.3; # IP Rabban
	server 192.234.1.4; # IP Feyd
}
```

b. Restart service dari nginx

```
service nginx restart
```

### Testing

Testing ini dilakukan dengan menjalankan command berikut

```
ab -n 100 -c 10 http://192.234.4.3/
```

**Sebelum menggunakan algoritma `least_conn`**

![Soal 20 - 1](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/8624c2fd-9488-4529-876f-a094624361a1)

**Sesudah menggunakan algoritma `least_conn`**

![Soal 20 - 2](https://github.com/samuelyuma/Jarkom-Modul-3-IT02-2024/assets/118542326/3c0581ed-73f6-47c5-9622-3144e4d9ecf9)

Dari screenshot tersebut, dapat dilihat bahwa ...
