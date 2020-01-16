#!/usr/bin/env bash

# Need run with root permissions this script
cd ..
PATH_PROJECT="$PWD"
echo "$PATH_PROJECT"

echo Enter some web-hostname for project but without spaces:
read HOST_PROJECT
if [ -z "$HOST_PROJECT" ]; then
  echo You entered bad host :"$HOST_PROJECT".
  HOST_PROJECT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  echo Set random project host: "$HOST_PROJECT"
fi
if [[ $HOST_PROJECT =~ [' ./;`_-%$#@!)(=+*^~?><\,'] ]]; then
  echo You entered bad host :"$HOST_PROJECT".
  HOST_PROJECT=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
  echo Set random project host: "$HOST_PROJECT"
fi
NAME_PROJECT_DEMAN="flask-project-$HOST_PROJECT-demon"
echo Project host : "$HOST_PROJECT"
echo Project dir: "$PATH_PROJECT"
PATH_TEMPLATE_PROJECT_DEMAN="$PATH_PROJECT/server_config/project-demon.service"

#Replace params in config files(one attempt)

sed -i -e "s|projectName|$HOST_PROJECT|g" "$PATH_TEMPLATE_PROJECT_DEMAN"
sed -i -e "s|userName|$SUDO_USER|g" "$PATH_TEMPLATE_PROJECT_DEMAN"
sed -i -e "s|pathProject|$PATH_PROJECT|g" "$PATH_TEMPLATE_PROJECT_DEMAN"

sed -i -e "s|pathProject|$PATH_PROJECT|g" "$PATH_PROJECT/server_config/project.ini"
sed -i -e "s|pathProject|$PATH_PROJECT|g" "$PATH_PROJECT/server_config/nginx.conf"
sed -i -e "s|projectName|$HOST_PROJECT|g" "$PATH_PROJECT/server_config/nginx.conf"

#Update all packeges and insatll python3 + pip3 + other lib (ssl-dev + ffi-dev) + setuptools + python3-venv + nginx
sudo apt update -y
sudo apt install -y nginx
sudo apt install -y python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools
sudo apt install -y python3-venv

#Install new environment with path "$PATH_PROJECT/venv" and install wheel,uwsgi,flask installations with a pip
python3 -m venv "$PATH_PROJECT/venv"
source "$PATH_PROJECT/venv/bin/activate"
pip install wheel
pip install uwsgi flask
deactivate

#Create a folder `logs` if it does not exist
sudo -u "$SUDO_USER" mkdir -p logs
PROJECT_DEMON_IN_SYSTEM="/etc/systemd/system/$NAME_PROJECT_DEMAN.service"
if [ ! -f "$PROJECT_DEMON_IN_SYSTEM" ]; then
  sudo ln "$PATH_PROJECT/server_config/project-demon.service" "$PROJECT_DEMON_IN_SYSTEM"
#Project dir on a different drive than the system, need to uncomment the previous line and comment next line.
#  sudo cp "$PATH_PROJECT/server_config/project-demon.service" "$PROJECT_DEMON_IN_SYSTEM"
  echo Create hardlink for project demon with :
  echo name : "$NAME_PROJECT_DEMAN" and
  echo path : "$PROJECT_DEMON_IN_SYSTEM"
fi
if [ ! -f "/etc/nginx/conf.d/$HOST_PROJECT.conf" ]; then
  sudo ln "$PATH_PROJECT/server_config/nginx.conf" "/etc/nginx/conf.d/$HOST_PROJECT.conf"
#Project dir on a different drive than the system, need to uncomment the previous line and comment next line.
#  sudo cp "$PATH_PROJECT/server_config/nginx.conf" "/etc/nginx/conf.d/$HOST_PROJECT.conf"
  echo Create hard link for a nginx-configuration file of this project with :
  echo path "/etc/nginx/conf.d/$HOST_PROJECT.conf"
  echo "$(hostname -i)       $HOST_PROJECT" >> /etc/hosts
  echo Write new host in file /etc/hosts
  sudo /etc/init.d/nginx stop
  sudo /etc/init.d/nginx start
fi
sudo systemctl start "$NAME_PROJECT_DEMAN"
#systemctl status flask-project
sudo systemctl enable "$NAME_PROJECT_DEMAN"
sudo -u "$SUDO_USER" firefox -new-tab "http://$HOST_PROJECT" &
exit