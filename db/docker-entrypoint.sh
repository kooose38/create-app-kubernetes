#! /bin/sh
INIT_FLAG_FILE=/data/db/inti-completes
INIT_LOG_FILE=/data/db/init-mongod.log

start_mongod_as_deamon(){
echo
echo "-----Start MongoDB-----"
echo
mongod \
   --fork \
   --logpath ${INIT_LOG_FILE} \
   --quiet \
   --bind_ip 0.0.0.0 \
   --smallfiles;
}

create_user(){
echo
echo "-----Create User------"
echo
if [ ! "$MONGO_INTIDB_ROOT_USERNAME" ] || [ ! "$MONGO_INTIDB_ROOT_PASSWORD" ]; then
   return
fi
mongo "${MONGO_INTIDB_DATABASE}" <<-EOS
   db.createUser({
      user: "${MONGO_INTIDB_ROOT_USERNAME}",
      pwd: "${MONGO_INTIDB_ROOT_PASSWORD}",
      roles: [{ role: "root", db: "${MONGO_INTIDB_DATABASE:-admin}" }]
   })
EOS
}

create_initilize_flag(){
echo
echo "----create initlize flag file----"
echo
cat <<-EOF > "${INIT_FLAG_FILE}"
[$(date +%Y-m%-%dT%H:%M:%S.%3N)] Initialize scripts if finised.
EOF
}

stop_mongod(){
echo
echo "----Stop MongoDB----"
echo
mongod --shutdown
}

if [ ! -e ${INIT_FLAG_FILE} ]; then
   echo
   echo "-----Initilize MongoDB-----"
   echo
   start_mongod_as_deamon
   create_user
   create_initilize_flag
   stop_mongod
fi

exec "$@"