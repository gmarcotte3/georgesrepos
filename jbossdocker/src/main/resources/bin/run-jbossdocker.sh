#!/bin/bash
# run the locally built image.

docker_image=marcotte/jbossdocker

if docker ps | grep "\\s${docker_image}\\s" ; then
  echo "ERROR: The server is running already."
  exit 1
fi
# change --dns server ip as needed
docker run -d -p 8080:8080 -p 9990:9990  --name "jbossdocker" \
  ${docker_image}

(( $? != 0 )) && exit 1

docker ps -a
