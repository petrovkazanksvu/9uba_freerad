docker-compose down
sed -i -e 's/\x20\x20\x20\x20volumes:/#\x20\x20\x20volumes:/;'`
         `'s/\x20\x20\x20\x20\x20\x20\x20-\x20${APP_PATH_HOST_users}:${APP_PATH_CONTAINER_users}/#\x20\x20\x20\x20\x20\x20-\x20${APP_PATH_HOST_users}:${APP_PATH_CONTAINER_users}/;'`
         `'s/\x20\x20\x20\x20\x20\x20\x20-\x20${APP_PATH_HOST_clients}:${APP_PATH_CONTAINER_clients}/#\x20\x20\x20\x20\x20\x20-\x20${APP_PATH_HOST_clients}:${APP_PATH_CONTAINER_clients}/'`
         ` ./docker-compose.yml
sudo rm -R freeradius/
docker-compose up -d
docker cp 9_com_fr_s_1_1:/etc/freeradius ./
docker-compose down
cd freeradius/3.0/
mv users users.sh
mv clients.conf clients.conf.sh
cd ../..
sed -i -e 's/#\x20\x20\x20volumes:/\x20\x20\x20\x20volumes:/;'`
         `'s/#\x20\x20\x20\x20\x20\x20-\x20${APP_PATH_HOST_users}:${APP_PATH_CONTAINER_users}/\x20\x20\x20\x20\x20\x20\x20-\x20${APP_PATH_HOST_users}:${APP_PATH_CONTAINER_users}/;'`
         `'s/#\x20\x20\x20\x20\x20\x20-\x20${APP_PATH_HOST_clients}:${APP_PATH_CONTAINER_clients}/\x20\x20\x20\x20\x20\x20\x20-\x20${APP_PATH_HOST_clients}:${APP_PATH_CONTAINER_clients}/'`
         ` ./docker-compose.yml
docker-compose up -d
docker exec -it 9_com_fr_s_1_1 bash
chown freerad:freerad /etc/freeradius/3.0/mods-config/files/authorize
service freeradius restart

exit
         sed -i -e 's/\x20\x20\x20\x20volumes:/#\x20\x20\x20volumes:/;'`
                  `'s/\x20\x20\x20\x20\x20\x20\x20-\x20${APP_PATH_HOST_users}:${APP_PATH_CONTAINER_users}/#\x20\x20\x20\x20\x20\x20-\x20${APP_PATH_HOST_users}:${APP_PATH_CONTAINER_users}/;'`
                  `'s/\x20\x20\x20\x20\x20\x20\x20-\x20${APP_PATH_HOST_clients}:${APP_PATH_CONTAINER_clients}/#\x20\x20\x20\x20\x20\x20-\x20${APP_PATH_HOST_clients}:${APP_PATH_CONTAINER_clients}/'`
                  ` ./docker-compose.yml

#Server
echo 'testing Cleartext-Password := "password"' >> /etc/freeradius/3.0/users
service freeradius restart
radtest testing password 127.0.0.1 0 testing123
echo -en 'client new {\nipaddr = 192.168.160.2\nsecret = testing123\n}\n' >> /etc/freeradius/3.0/clients.conf
service freeradius restart

#Client
radtest testing password 192.168.160.3 0 testing123
#111
