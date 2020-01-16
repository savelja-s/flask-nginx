# Flask-nginx project based on Flask.

### Requirements:
 - linux x64(debian|ubuntu)
 - `python3 + pip3 + other lib (ssl-dev + ffi-dev) + setuptools + python3-venv + nginx` (installed with server_config/install.sh script)

### Installation:

If the project folder is on a different drive than the system then you need to copy the configuration files. 
This requires uncomment lines(54,62) and comment lines(52,60) in file `server_config/install.sh` .

For setup project need run next commands:
```shell script
cd flask-nginx/server_config
sudo chmod +x ./install.sh
sudo ./install.sh
```