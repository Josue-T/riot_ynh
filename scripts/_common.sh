#!/bin/bash

# Retrieve arguments
app=$YNH_APP_INSTANCE_NAME
final_path="/var/www/$app"

config_nginx() {
    if [ "$path_url" != "/" ]
    then
        ynh_replace_string "^#sub_path_only" "" "../conf/nginx.conf"
    fi
    ynh_add_nginx_config
}

config_riot() {
    cp ../conf/config.json $final_path/config.json
    ynh_replace_string __DEFAULT_SERVER__ $default_home_server $final_path/config.json
    chown www-data -R $final_path/config.json
    chmod 640 -R $final_path/config.json
}

# Substitute/replace a string (or expression) by another in a file
#
# usage: ynh_replace_string match_string replace_string target_file
# | arg: match_string - String to be searched and replaced in the file
# | arg: replace_string - String that will replace matches
# | arg: target_file - File in which the string will be replaced.
#
# As this helper is based on sed command, regular expressions and
# references to sub-expressions can be used
# (see sed manual page for more information)
ynh_replace_string () {
	local delimit=@
	local match_string=$1
	local replace_string=$2
	local workfile=$3

	# Escape the delimiter if it's in the string.
	match_string=${match_string//${delimit}/"\\${delimit}"}
	replace_string=${replace_string//${delimit}/"\\${delimit}"}

	sudo sed --in-place "s${delimit}${match_string}${delimit}${replace_string}${delimit}g" "$workfile"
}