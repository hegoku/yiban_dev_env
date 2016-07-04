FROM centos:6.8
RUN yum -y install wget
RUN rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm
RUN wget http://mirrors.hust.edu.cn/epel//5/x86_64/epel-release-5-4.noarch.rpm
RUN rpm -ivh epel-release-5-4.noarch.rpm
RUN yum -y install httpd
RUN yum -y install libmcrypt php56w.x86_64 php56w-cli.x86_64 php56w-common.x86_64 php56w-gd.x86_64 php56w-ldap.x86_64 php56w-mbstring.x86_64 php56w-mcrypt.x86_64 php56w-mysql.x86_64 php56w-pdo.x86_64
RUN rm epel-release-5-4.noarch.rpm

COPY php.ini /etc/php.ini
COPY httpd.conf /etc/httpd/conf/httpd.conf

RUN yum -y install gcc
RUN yum -y install php56w-devel.x86_64

RUN wget https://pecl.php.net/get/yaf-2.3.5.tgz
RUN tar -zxvf yaf-2.3.5.tgz \
    && rm yaf-2.3.5.tgz \
    && cd yaf-2.3.5 \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && cd ../ \
    && rm -R yaf-2.3.5 \
    && rm package.xml

RUN wget https://pecl.php.net/get/redis-2.2.8.tgz
RUN tar -zxvf redis-2.2.8.tgz \
    && rm redis-2.2.8.tgz \
    && cd redis-2.2.8 \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && cd ../ \
    && rm package.xml \
    && rm -R redis-2.2.8

RUN yum clean all



EXPOSE 80
COPY httpd-foreground /usr/local/bin/
CMD ["httpd-foreground"]
