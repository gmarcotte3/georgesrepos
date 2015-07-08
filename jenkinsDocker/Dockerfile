# Jenkins server docker
#
# 
FROM ubuntu:14.04
MAINTAINER george Marcotte "george.marcotte@vizexplorer.com"

ENV DEBIAN_FRONTEND noninteractive

# update repositories
RUN apt-get -y update
RUN apt-get -y upgrade

# Install packages we need for backend
RUN \
  apt-get install -y supervisor

RUN \
  apt-get install -y openjdk-7-jdk

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

RUN \
  apt-get install -y daemon

RUN \
  apt-get install -y ant

ENV ANT_HOME /usr/share/ant

RUN \
  apt-get install -y git

RUN \
  apt-get install -y wget

# install maven 3.2.5 directly
COPY config/apache-maven-3.2.5-bin.tar.gz /usr/local/
RUN \
   cd /usr/local && \
   tar xvf apache-maven-3.2.5-bin.tar.gz && \
   rm apache-maven-3.2.5-bin.tar.gz 

# set the envoronment variable directly because /etc/environment not working
ENV M2_HOME /usr/local/apache-maven-3.2.5
RUN \
    cd /usr/bin && \
    ln -s /usr/local/apache-maven-3.2.5/bin/mvn mvn



# Creating directories for  Apache2 and Supervisor
RUN mkdir -p /var/log/supervisor

#COPY config/apache-tomcat-8.0.17.tar.gz /opt/
#RUN \
#   cd /opt && \
#   tar xvf apache-tomcat-8.0.17.tar.gz

# install jenkins here
RUN \
    wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -  && \
    sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list' && \
    apt-get update && \
    apt-get install jenkins 

#COPY config/jenkins_1.617_all.deb /opt/
#RUN \
#    cd /opt && \
#    dpkg -i jenkins_1.617_all.deb


## docket stuff ------------
# Now let's add a configuration file for Supervisor.
COPY config/supervisord.conf /etc/supervisor/conf.d/

#expose the jboss/apache ports
EXPOSE 8080

#start the supervisor services (jenkins)
CMD ["/usr/bin/supervisord"]
