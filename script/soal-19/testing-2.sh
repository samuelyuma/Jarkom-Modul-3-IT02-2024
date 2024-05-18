echo '
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
pm.max_children = 30
pm.start_servers = 5
pm.min_spare_servers = 3
pm.max_spare_servers = 10
pm.process_idle_timeout = 10s
' > /etc/php/8.0/fpm/pool.d/stilgar.conf

groupadd stilgar_user
useradd -g stilgar_user stilgar_user

service php7.3-fpm restart
