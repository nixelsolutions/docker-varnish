#!/bin/bash

set -e

[ "$DEBUG" == "1" ] && set -x && set +e

if [ "${BACKEND_SERVERS}" == "**ChangeMe**" -o -z "${BACKEND_SERVERS}" ]; then
   echo "*** ERROR: you need to define BACKEND_SERVERS environment variable - Exiting ..."
   exit 1
fi

if [ "${BACKEND_PORT}" == "**ChangeMe**" -o -z "${BACKEND_PORT}" ]; then
   echo "*** ERROR: you need to define BACKEND_PORT environment variable - Exiting ..."
   exit 1
fi

if [ "${MAX_CACHE_SIZE}" == "**ChangeMe**" -o -z "${MAX_CACHE_SIZE}" ]; then
   echo "*** ERROR: you need to define MAX_CACHE_SIZE environment variable - Exiting ..."
   exit 1
fi

if [ "${HTTP_PORT}" == "**ChangeMe**" -o -z "${HTTP_PORT}" ]; then
   echo "*** ERROR: you need to define HTTP_PORT environment variable - Exiting ..."
   exit 1
fi

echo "=> Configuring Varnish..."
echo -e "vcl 4.0;\n" > /etc/varnish/default.vcl
backends=0
default_director="director default_director round-robin {"
for backend in `echo ${BACKEND_SERVERS} | sed "s/,/ /g"`; do
   echo "=> Adding backend $backend to Varnish configuration..."
   backend_id=$((backends++))
   echo "backend web${backend_id} { .host = ${backend}; .port = ${BACKEND_PORT};}" >> /etc/varnish/default.vcl
   default_director="${default_director}\n  { .backend = web${backend_id};}"
done
default_director="${default_director}\n}"
echo -e "\n${default_director}" >> /etc/varnish/default.vcl
cat /etc/varnish/template.vcl >> /etc/varnish/default.vcl

echo "=> Starting Varnish with these parameters:"
echo "MAX_CACHE_SIZE = ${MAX_CACHE_SIZE}"
echo "HTTP_PORT = ${HTTP_PORT}"
echo "BACKEND_SERVERS = ${BACKEND_SERVERS}"

/usr/bin/supervisord
