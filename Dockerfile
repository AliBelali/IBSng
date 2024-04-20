FROM centos:6

#Add REPO because CentOS:6 End Of Life
RUN curl https://www.getpagespeed.com/files/centos6-eol.repo --output /etc/yum.repos.d/CentOS-Base.repo
RUN yum update -y

RUN yum install -y httpd postgresql postgresql-server postgresql-python php perl nano wget sed openssh-clients

RUN sed -i '1idate.timezone =”Asia/Tehran”' /etc/php.ini \
 && sed -i '1iServerName 127.0.0.1' /etc/httpd/conf/httpd.conf \
 && sed -i '114 s/./#&/' /etc/init.d/postgresql

COPY IBSng-A1.24.tar.bz2 /IBSng-A1.24.tar.bz2
RUN tar -xvjf IBSng-A1.24.tar.bz2 -C /usr/local/

ADD auto-db-conf.py /auto-db-conf.py
RUN chmod +x /auto-db-conf.py

RUN sed -i '114 s/./#&/' /etc/init.d/postgresql

RUN service postgresql initdb \
 && /etc/init.d/postgresql start \
 && sleep 4 \
 && sed -i '1ilocal IBSng ibs trust' /var/lib/pgsql/data/pg_hba.conf \
 && sleep 2 \
 && su postgres -c 'createuser -s -i -d -r -l -w ibs' \
 && su postgres -c 'createdb IBSng' \
 && su postgres -c 'createlang plpgsql IBSng' \
 && /auto-db-conf.py

RUN sed -i '1i#coding:utf-8' /usr/local/IBSng/core/lib/IPy.py \
 && sed -i '1i#coding:utf-8' /usr/local/IBSng/core/lib/mschap/des_c.py \
 && sed -i '25s+$timeArr=.*;+$timeArr="IRDT/4.0/DST";+g'  /usr/local/IBSng/interface/IBSng/inc/error.php
 
#RUN /usr/local/IBSng/scripts/setup.py
#compile
RUN /usr/local/IBSng/core/defs_lib/defs2sql.py -i /usr/local/IBSng/core/defs_lib/defs_defaults.py /usr/local/IBSng/db/defs.sql 1>/dev/null 2>/dev/null
RUN mkdir /var/log/IBSng
RUN chmod 770 /var/log/IBSng
RUN cp -f /usr/local/IBSng/addons/apache/ibs.conf /etc/httpd/conf.d
RUN chown -R root:root /usr/local/IBSng
RUN chown -R apache:apache /var/log/IBSng
RUN chown -R apache:apache /usr/local/IBSng/interface/smarty/templates_c
RUN chown -R apache:apache /var/www/html
RUN cp -f /usr/local/IBSng/addons/logrotate/IBSng /etc/logrotate.d/
RUN cp -f /usr/local/IBSng/init.d/IBSng.init.redhat /etc/init.d/IBSng


ADD IBSng_backup.sh /IBSng_backup.sh
ADD run.sh /run.sh
RUN chmod +x /run.sh \
 && chmod +x /IBSng_backup.sh \
 && mkdir /backup


CMD ["/run.sh"]
