#!/bin/bash
# run the locally built image.

web_dir=/var/dweb/html

docker_image=marcotte/apachedocker

if docker ps | grep "\\s${docker_image}\\s" ; then
  echo "ERROR: The server is running already."
  exit 1
fi
# change dns server ip as needed
#  
docker run -d -p 80:80 --name "apachedocker" \
  -v "${web_dir}:/var/www/html" \
  ${docker_image}

(( $? != 0 )) && exit 1

docker ps -a
