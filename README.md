# flask-nginx
### Installation

```shell script
sudo apt update && \
sudo apt install python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools && \
sudo apt install python3-venv && \
cd flask-nginx && /
python3.6 -m venv venv && \
source venv/bin/activate && \ 
pip install wheel && \
pip install uwsgi flask
```


```shell script
sudo ln /home/serhiy/www/flask-nginx/server_config/project-demon.service /etc/systemd/system/flask-project.service
sudo ln /home/serhiy/www/flask-nginx/server_config/nginx.conf /etc/nginx/conf.d/flask-project.conf
sudo journalctl -u flask-project.service
sudo systemctl start flask-project
sudo systemctl status flask-project
sudo systemctl enable flask-project
```