#!/bin/bash
#
# Assumptions:
# jenkins home is at /var/lib/jenkins
jenkins_home_dir=/var/opt/jenkins
docker_image=marcotte/jenkins-docker 

if docker ps | grep "\\s${docker_image}\\s" ; then
  echo "ERROR: The server is running already."
  exit 1
fi
# add -d remove -i -t
docker run -d -p 8080:8080 --name jenkinsdocker \
  -v "${jenkins_home_dir}:/var/lib/jenkins" \
  ${docker_image}

(( $? != 0 )) && exit 1

docker ps 

