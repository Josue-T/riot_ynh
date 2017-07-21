#!/bin/bash

# Retrieve arguments
app=$YNH_APP_INSTANCE_NAME
final_path="/var/www/$app"

config_nginx() {
	cp ../conf/nginx.conf /etc/nginx/conf.d/$domain.d/$app.conf

	ynh_replace_string __PATH__ $path /etc/nginx/conf.d/$domain.d/$app.conf
	ynh_replace_string __FINALPATH__ $final_path /etc/nginx/conf.d/$domain.d/$app.conf
}

config_riot() {
	cp ../conf/config.json $final_path/config.json
	ynh_replace_string __DEFAULT_SERVER__ $default_home_server $final_path/config.json
}