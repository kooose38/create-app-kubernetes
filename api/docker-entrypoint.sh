#! /bin/sh

if [ -n "${MONGODB_HOSTS}" ]; then
   node ./lib/database/wait.js
else
   echo "WARN: MONGODB_HOSTS is not defined."
fi

exec "$@"