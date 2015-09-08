#!/bin/bash

set -e

[ "$DEBUG" == "1" ] && set -x && set +e

if [ "${MAX_CACHE_MEM}" == "**ChangeMe**" -o -z "${MAX_CACHE_MEM}" ]; then
   MAX_CACHE_MEM=512M
fi

echo "=> Starting Varnish with these parameters:"
echo "MAX_CACHE_MEM = ${MAX_CACHE_MEM}"

/usr/bin/supervisord
