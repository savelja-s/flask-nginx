#!/usr/bin/env bash

# Need run with root permissions this script
rm project.ini
rm nginx.conf
rm project-demon.service
rm project.sock
rm project-demon.pid
#remove all nginx conf files in folder `/etc/nginx/conf.d/`
rm /etc/nginx/conf.d/*
#remove virtual hosts in foldr /etc/hosts
sed -i '$d' /etc/hosts
#clear all logs files
cat /dev/null > ../logs/accsess.log
cat /dev/null > ../logs/error.log
cat /dev/null > ../logs/uwsgi.log
#remove demons file in system dirs
rm /etc/systemd/system/flask-project-*
rm /etc/systemd/system/multi-user.target.wants/flask-project-*
systemctl daemon-reload