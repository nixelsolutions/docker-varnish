#!/bin/bash

set -e

[ "$DEBUG" == "1" ] && set -x && set +e

if [ "${MAX_CACHE_SIZE}" == "**ChangeMe**" -o -z "${MAX_CACHE_SIZE}" ]; then
   echo "*** ERROR: you need to define MAX_CACHE_SIZE environment variable - Exiting ..."
   exit 1
fi

if [ "${HTTP_PORT}" == "**ChangeMe**" -o -z "${HTTP_PORT}" ]; then
   echo "*** ERROR: you need to define HTTP_PORT environment variable - Exiting ..."
   exit 1
fi

echo "=> Starting Varnish with these parameters:"
echo "MAX_CACHE_SIZE = ${MAX_CACHE_SIZE}"
echo "HTTP_PORT = ${HTTP_PORT}"

/usr/bin/supervisord
