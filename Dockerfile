# https://phpipam.net/phpipam-installation-on-centos-7/
FROM centos:7
ARG  MYSQL_HOST=database
ARG  MYSQL_DB=phpipam
ARG  MYSQL_PORT=3306
ARG  MYSQL_USER=phpipam
ARG  MYSQL_PASSWORD=phpipam
RUN [\
    "yum", "install", "-q", "-y",\
    "httpd",\
    "php",\
    "php-cli",\
    "php-gd",\
    "php-common",\
    "php-ldap",\
    "php-pdo",\
    "php-pear",\
    "php-snmp",\
    "php-xml",\
    "php-mysql",\
    "php-mbstring"\
    ]
RUN ["bash", "-c", "echo -e \"\ndate.timezone = Etc/UTC\" >> /etc/php.ini"]
RUN ["ln", "-s", "/dev/stdout", "/var/log/httpd/access_log"]
RUN ["ln", "-s", "/dev/stderr", "/var/log/httpd/error_log"]
COPY [".", "/var/www/html/"]
RUN ["chown", "apache:apache", "-R", "/var/www/html/"]
RUN ["cp", "/var/www/html/config.dist.php", "/var/www/html/config.php"]
RUN ["sed", "-E", "/^\\$db\\['(host|user|pass|name|port)'/d", "-i", "/var/www/html/config.php"]
RUN ["bash", "-c", "echo -e \"\n\\$db['host'] = '$MYSQL_HOST';\" >> /var/www/html/config.php"]
RUN ["bash", "-c", "echo \"\\$db['user'] = '$MYSQL_USER';\" >> /var/www/html/config.php"]
RUN ["bash", "-c", "echo \"\\$db['pass'] = '$MYSQL_PASSWORD';\" >> /var/www/html/config.php"]
RUN ["bash", "-c", "echo \"\\$db['name'] = '$MYSQL_DB';\" >> /var/www/html/config.php"]
RUN ["bash", "-c", "echo \"\\$db['port'] = '$MYSQL_PORT';\" >> /var/www/html/config.php"]
CMD ["/sbin/httpd", "-DFOREGROUND", "-e", "info"]

