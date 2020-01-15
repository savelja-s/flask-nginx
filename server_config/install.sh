#!/usr/bin/env bash
PATH_PROJECT="$PWD/.."
#need run with root permissions

#replace params in config files
sed -i -e 's|projectName|flask-project|g' "$PATH_PROJECT/server_config/project-demon.service"
sed -i -e 's|userName|serhiy|g' "$PATH_PROJECT/server_config/project-demon.service"
sed -i -e "s|pathProject|$PATH_PROJECT|g" "$PATH_PROJECT/server_config/project-demon.service"

sed -i -e "s|pathProject|$PATH_PROJECT|g" "$PATH_PROJECT/server_config/project.ini"
sed -i -e "s|pathProject|$PATH_PROJECT|g" "$PATH_PROJECT/server_config/nginx.conf"


echo "Project dir: $PATH_PROJECT"
apt update && \
apt install nginx && \
apt install python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools && \
apt install python3-venv && \
cd .. && \
mkdir logs
ln "$PATH_PROJECT/server_config/project-demon.service" /etc/systemd/system/flask-project.service
ln "$PATH_PROJECT/server_config/nginx.conf" /etc/nginx/conf.d/flask-project.conf
systemctl start flask-project
#systemctl status flask-project
systemctl enable flask-project

python3 -m venv "$PATH_PROJECT/venv" && \
source "$PATH_PROJECT/venv/bin/activate" && \
pip install wheel && \
pip install uwsgi flask && \
deactivate
exit