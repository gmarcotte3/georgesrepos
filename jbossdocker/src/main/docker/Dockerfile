# visExplorer jboss docker image. 
#
# this docker contains only a jboss running. the configuration is injected after it runs.
#
FROM ubuntu:14.04
MAINTAINER george Marcotte "george.marcotte@vizexplorer.com"

# Install packages we need for backend
RUN \
  apt-get update && \
  apt-get install -y wget && \
  apt-get install -y openjdk-7-jre supervisor 

# install ssh so we can access this from outside
#RUN \
#  apt-get install -y openssh-server
#
#RUN \
#  apt-get install -y apache2 libapache2-mod-jk
#
#RUN \
#  apt-get install -y libmysql-java

ENV TZ=NZ
RUN \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#RUN \
#  mv /etc/apache2/mods-available/jk.conf /etc/apache2/mods-available/jk-original.conf
#
## change the workers, we want rest_worker, no load balancing configured
## so we replace workers.properties and the jk.conf files.
#COPY config/jk.conf /etc/apache2/mods-available/
#COPY config/workers.properties /etc/apache2/
#
## Enabling the mod_jk and the proxies submodules for Apache
#RUN \
#	a2enmod rewrite && \
#	a2enmod headers && \
#	a2enmod proxy && \
#	a2enmod proxy_http && \
#	a2enmod jk && \
#	a2enmod proxy_ajp
#
## Creating directories for  Apache2 and Supervisor
#RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/log/supervisor
#
## Set Apache environment variables (can be changed on docker run with -e)
#ENV APACHE_RUN_USER www-data
#ENV APACHE_RUN_GROUP www-data
#ENV APACHE_LOG_DIR /var/log/apache2
#ENV APACHE_PID_FILE /var/run/apache2.pid
#ENV APACHE_LOCK_DIR /var/lock/apache2
#ENV APACHE_RUN_DIR /var/run/apache2
##ENV APACHE_SERVERADMIN admin@localhost
##ENV APACHE_SERVERNAME localhost
##ENV APACHE_SERVERALIAS docker.localhost
#ENV APACHE_DOCUMENTROOT /var/www/html
##ENV APACHE_DOCUMENTROOT /opt/vizexplorer/app/ui

#expose the jboss/apache ports
#EXPOSE 80 8080 9990 22
EXPOSE 8080 9990

# Add a sudo user
RUN useradd -m --groups sudo --shell /bin/bash developer && \
    echo developer:developer | chpasswd developer

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

## jboss related stuff ----------------------
# Copy local jboss (pre-configured and with viz-apps deployed) folder into
# the image /opt/vizexplorer folder
#COPY build-files/jboss7 /opt/vizexplorer/jboss7/

#RUN \
#    mkdir -p /opt/vizexplorer && \
#    cd /opt/vizexplorer/ && \
#    wget http://172.16.2.139/downloads/jboss7.tar && \
#    tar xvf jboss7.tar

RUN \
  mkdir -p /opt/vizexplorer && \
  wget -O /tmp/jboss.tar.gz http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz

RUN \
	tar zxf /tmp/jboss.tar.gz -C /opt/vizexplorer && \
	mv /opt/vizexplorer/jboss-as-7.1.1.Final /opt/vizexplorer/jboss7


## Copy bis2.properties
#COPY config/bis2.properties \
#     /opt/vizexplorer/jboss7/modules/net/bis2/resources/config/

## copy vizbybis.xml
#COPY config/vizbybis.xml \
#/opt/vizexplorer/jboss7/modules/net/bis2/resources/config/

## Copy standalone.xml
#COPY config/standalone.xml \
#     /opt/vizexplorer/jboss7/standalone/configuration/

# Copy config files for user accounts
COPY config/application-roles.properties \
     /opt/vizexplorer/jboss7/standalone/configuration/
COPY config/application-users.properties \
     /opt/vizexplorer/jboss7/standalone/configuration/

# set the home directory for jboss
ENV JBOSS_HOME /opt/vizexplorer/jboss7
RUN \
    echo "JBOSS_HOME=\"/opt/vizexplorer/jboss7\"" >> /etc/environment

## Copy the .ear and .war files
#COPY build-specific/*.war /opt/vizexplorer/jboss7/standalone/deployments/
#COPY build-specific/*.ear /opt/vizexplorer/jboss7/standalone/deployments/
#
## rename the war file.
#RUN \
#    cd /opt/vizexplorer/jboss7/standalone/deployments/ && \
#    warfilename=`ls -1 *.war` && \
#    mv $warfilename ROOT.war

## docket stuff ------------
# Now let's add a configuration file for Supervisor.
COPY config/supervisord.conf /etc/supervisor/conf.d/

#start the supervisor services (jboss and apache2)
CMD ["/usr/bin/supervisord"]
