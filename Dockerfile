from ubuntu:14.04 
maintainer pratheesh
run apt-get -y update  
run apt-get -y install apache2 
run apt-get -y install php5 
run apt-get -y install libapache2-mod-php5 
run apt-get -y install php5-gd 
run apt-get -y install php5-curl 
run apt-get -y install libssh2-php
run apt-get -y install rsync 
run apt-get -y install php5-mysql
run apt-get -y install php5-fpm
run apt-get -y install openssh-client=1:6.6p1-2ubuntu1
run apt-get install -y git 
run mkdir /var/www/html/wordpress

run sed -i "s|expose_php = On|expose_php = Off|g" /etc/php5/apache2/php.ini
run sed -i "s|allow_url_fopen = On|allow_url_fopen = Off|g" /etc/php5/apache2/php.ini

workdir /tmp
run git clone -b fs https://github.com/pratheeshts0/docker.git
workdir /tmp/docker

run cp wp-config-sample.php wp-config.php
run sed -i "s|define('DB_NAME', 'database_name_here');|define('DB_NAME', 'wordpress');|g" wp-config.php
run sed -i "s|define('DB_USER', 'username_here');|define('DB_USER', 'wordpressuser');|g" wp-config.php
run sed -i "s|define('DB_PASSWORD', 'password_here');|define('DB_PASSWORD', 'password');|g" wp-config.php
run sed -i "s|define('DB_HOST', 'localhost');|define('DB_HOST', '192.168.1.235');|g" wp-config.php
run sed -i "s|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g" /etc/php5/fpm/php.ini
run rsync -avP /tmp/docker/ /var/www/html/wordpress/
run mkdir /etc/apache2/ssl
workdir /etc/secure1

run git clone -b taken https://github.com/pratheeshts0/docker.git
run cp /etc/secure1/docker/secure.conf /etc/apache2/sites-available/
run cp /etc/secure1/docker/redirection.conf /etc/apache2/sites-available/
run cp /etc/secure1/docker/apache.crt /etc/apache2/ssl/
run cp /etc/secure1/docker/apache.key /etc/apache2/ssl/

workdir /root
run a2ensite secure.conf 
run a2ensite redirection.conf
run a2enmod dir
run a2enmod ssl
run chown -R www-data:www-data /var/www/html/
run chmod 755 -R /var/www/html/
expose 80 443
entrypoint service apache2 restart && service php5-fpm restart && bash
