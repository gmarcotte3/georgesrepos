# visExplorer jboss docker image. 
#
# this docker contains only a jboss running. the configuration is injected after it runs.
#
FROM ubuntu:14.04
MAINTAINER george Marcotte "george@gmarcotte.com"

# Install packages we need for backend
RUN \
  apt-get update && \
  apt-get install -y wget && \
  apt-get install -y supervisor 
#  apt-get install -y openjdk-7-jre 



#RUN \
#  apt-get install -y libmysql-java

ENV TZ=NZ
RUN \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# change the workers, we want rest_worker, no load balancing configured
# so we replace workers.properties and the jk.conf files.
RUN \
  apt-get install -y apache2 libapache2-mod-jk
  
#RUN \
#  mv /etc/apache2/mods-available/jk.conf /etc/apache2/mods-available/jk-original.conf

#COPY config/jk.conf /etc/apache2/mods-available/
#COPY config/workers.properties /etc/apache2/
RUN \
 	a2enmod jk

# Enabling the mod_jk and the proxies submodules for Apache
RUN \
	a2enmod rewrite && \
	a2enmod headers && \
	a2enmod proxy && \
	a2enmod proxy_http && \
	a2enmod proxy_ajp


# Creating directories for  Apache2 and Supervisor
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/supervisor

# Set Apache environment variables (can be changed on docker run with -e)
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_RUN_DIR /var/run/apache2
#ENV APACHE_SERVERADMIN admin@localhost
#ENV APACHE_SERVERNAME localhost
#ENV APACHE_SERVERALIAS docker.localhost
ENV APACHE_DOCUMENTROOT /var/www/html


#expose the apache ports
EXPOSE 80

## Add a sudo user
#RUN useradd -m --groups sudo --shell /bin/bash developer && \
#    echo developer:developer | chpasswd developer

### apache related stuff -------------------------
## Copying our apache default config file into the container
#COPY config/000-default.conf /etc/apache2/sites-available/
#
## enable the default site
#RUN \
#  a2ensite 000-default
#
## copy a base web to apache document root.
#COPY build-files/web /var/www/html
#
#COPY config/web/explorer/etc/customer.xml /var/www/html/explorer/etc/
#COPY config/web/maker/etc/customer.xml /var/www/html/maker/etc/
#
## Copy crossdomain.xml
#RUN chmod -R a+r /var/www/html
#

## docket stuff ------------
# Now let's add a configuration file for Supervisor.
COPY config/supervisord.conf /etc/supervisor/conf.d/

#start the supervisor services (jboss and apache2)
CMD ["/usr/bin/supervisord"]
