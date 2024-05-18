echo nameserver 192.168.122.1 > /etc/resolv.conf

apt-get update
apt-get install lynx nginx wget unzip php7.3 php-fpm -y

service php7.3-fpm start

service nginx start

mkdir -p /var/www/html/download/

wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=1lmnXJUbyx1JDt2OA5z_1dEowxozfkn30' -O /var/www/html/download/harkonen.zip

unzip /var/www/html/download/harkonen.zip -d /var/www/html/download/

mv /var/www/html/download/modul-3/* /var/www/html/

rm -rf /var/www/html/download/

echo '
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
' > /etc/nginx/sites-available/jarkom-it02.conf

ln -s /etc/nginx/sites-available/jarkom-it02.conf /etc/nginx/sites-enabled

rm /etc/nginx/sites-enabled/default

service nginx restart

service php7.3-fpm restart