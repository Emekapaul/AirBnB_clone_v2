#!/usr/bin/env bash
# duplicate web-01 to web-02
# these scripts are an upgrade from the web-server scripts...

function install() {
	command -v "$1" &> /dev/null

	#shellcheck disable=SC2181
	if [ $? -ne 0 ]; then
		sudo apt-get update -y -qq && \
			sudo apt-get install -y "$1" -qq
		echo -e "\n"
	fi
}

install nginx #install nginx

# allowing nginx on firewall
sudo ufw allow 'Nginx HTTP'

# Give the user ownership to website files for easy editing
if [ -d "/var/www" ]; then
	sudo chown -R "$USER":"$USER" /var/www
	sudo chmod -R 755 /var/www
else
	sudo mkdir -p /var/www
	sudo chown -R "$USER":"$USER" /var/www
	sudo chmod -R 755 /var/www
fi

# create directory if not present
if [ -d "/var/www/html" ]; then
    cp /var/www/html/index.nginx-debian.html /var/www/html/index.nginx-debian.html.bckp
else
    mkdir -p "/var/www/html"
fi

echo "Hello World!" > /var/www/html/index.nginx-debian.html

# create error page
echo "Ceci n'est pas une page" > /var/www/html/error_404.html

# backup default server config file
sudo cp /etc/nginx/sites-enabled/default nginx-sites-enabled_default.backup

server_config=\
"server {
		listen 80 default_server;
		listen [::]:80 default_server;
		root /var/www/html;
		index index.html index.htm index.nginx-debian.html
		server_name_;
		add_header X-Served-By \$hostname;
		location / {
			try_files \$uri \$uri/ =404;
		}
		if (\$request_filename ~ redirect_me){
			rewrite ^ https://youtube.com permanent;
		}
		error_page 404 /error_404.html;
		location = /error_404.html {
			internal;
		}
}"

#shellcheck disable=SC2154
echo "$server_config" | sudo dd status=none of=/etc/nginx/sites-available/default

sudo mkdir -p /data/web_static/{releases/test,shared}
echo "Holberton School" \
    | sudo tee /data/web_static/releases/test/index.html > /dev/null

sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
sudo chown -R ubuntu:ubuntu /data/
#shellcheck disable=SC1004
sudo sed -i '
\|location /hbnb_static| b end
\|location /|! b
i\
\t\tlocation /hbnb_static {\
\t\t\talias /data/web_static/current/;\
\t\t}
:end; n; b end
' /etc/nginx/sites-available/default
if [ "$(pgrep -c nginx)" -le 0 ]; then
	sudo service nginx start
else
	sudo service nginx restart
fi
