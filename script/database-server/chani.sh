echo nameserver 192.168.122.1 > /etc/resolv.conf

apt-get update
apt-get install mariadb-server -y

service mysql start

echo "
CREATE USER 'kelompokit02'@'%' IDENTIFIED BY 'passwordit02';
CREATE USER 'kelompokit02'@'localhost' IDENTIFIED BY 'passwordit02';
CREATE DATABASE dbkelompokit02;
GRANT ALL PRIVILEGES ON *.* TO 'kelompokit02'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'kelompokit02'@'localhost';
FLUSH PRIVILEGES;
quit
" | mysql -u root -p

echo "
SHOW DATABASES;
quit
" | mysql -u kelompokit02 -p'passwordit02'

echo '
[mysqld]
skip-networking=0
skip-bind-address
' > /etc/mysql/my.cnf

service mysql restart