#!/bin/bash

#=================================================
# SET ALL CONSTANTS
#=================================================

app=$YNH_APP_INSTANCE_NAME
final_path="/var/www/$app"

#=================================================
# DEFINE ALL COMMON FONCTIONS
#=================================================

config_riot() {
    cp ../conf/config.json $final_path/config.json
    ynh_replace_string __DEFAULT_SERVER__ $default_home_server $final_path/config.json
}

install_source() {
    ynh_setup_source $final_path/
    
    # if the default homeserver is external we dont add the sso support
    if [[ $(yunohost domain list | grep "$default_home_server") ]]
    then
        # We copy the certificate if it is a self signed certificate
        cert_path=$(readlink -f /etc/yunohost/certs/$default_home_server/crt.pem)
        test -n $cert_path && cp "$cert_path" $final_path/crt.pem
        chmod 600 $final_path/crt.pem
        chown $app:root $final_path/crt.pem
        
        cp ../sources/get_user_token.php $final_path/
        
        # Patch the riot bundle.js file
        # This file is a minified javascript so it's not possible to use the standrad patch because everything is only on one line.
        # The other problem is that some variable a renamed to be more short.
        # Here this variable is named unamed_object. By the regular expression we will be able to get this name and to put in the new code.
        
        # To make the code more readable (for debug), we can use the tool js-beautify available here : https://github.com/beautify-web/js-beautify
        
        # We escape all char witch could be a problem in regular expression.
        escape_string() {
            a=${a//'\'/'\\'}
            a=${a//'&'/"\&"}
            a=${a//'('/'\('}
            a=${a//')'/'\)'}
            a=${a//'{'/'\{'}
            a=${a//'}'/'\}'}
            a=${a//'.'/'\.'}
            a=${a//'*'/'\*'}
        }
        
        # We get the part witch we need to patch and create a regular expression
        a='case"start_login":this.setStateForNewView({view:unnamed_object.LOGIN}),this.notifyNewScreen("login");break;'
        escape_string
        match_string="${a//'unnamed_object'/'(\w+)'}"

        # We create a regular expression from the patch file
        a="$(cat ../sources/bundle_patch.js)"
        escape_string
        a="${a//'unnamed_object'/'\1'}"
        a="$(echo "$a" | sed -r "s|//.*||g")"
        replace_string="$(echo $a)"
        sed --in-place -r "s|$match_string|$replace_string|g" $final_path/bundles/*/bundle.js
    fi
}

set_permission() {
    chown www-data:$app -R $final_path
    chmod u=rX,g=rX,o= -R $final_path
}


# Create a dedicated nginx config
#
# usage: ynh_add_nginx_config "list of others variables to replace"
#
# | arg: list of others variables to replace separeted by a space
# |      for example : 'path_2 port_2 ...'
#
# This will use a template in ../conf/nginx.conf
#   __PATH__      by  $path_url
#   __DOMAIN__    by  $domain
#   __PORT__      by  $port
#   __NAME__      by  $app
#   __FINALPATH__ by  $final_path
#
#  And dynamic variables (from the last example) :
#   __PATH_2__    by $path_2
#   __PORT_2__    by $port_2
#
ynh_add_nginx_config () {
	local finalnginxconf="/etc/nginx/conf.d/$domain.d/$app.conf"
	local others_var=${1:-}
	ynh_backup_if_checksum_is_different "$finalnginxconf"
	sudo cp ../conf/nginx.conf "$finalnginxconf"

	# To avoid a break by set -u, use a void substitution ${var:-}. If the variable is not set, it's simply set with an empty variable.
	# Substitute in a nginx config file only if the variable is not empty
	if test -n "${path_url:-}"; then
		# path_url_slash_less is path_url, or a blank value if path_url is only '/'
		local path_url_slash_less=${path_url%/}
		ynh_replace_string "__PATH__/" "$path_url_slash_less/" "$finalnginxconf"
		ynh_replace_string "__PATH__" "$path_url" "$finalnginxconf"
	fi
	if test -n "${domain:-}"; then
		ynh_replace_string "__DOMAIN__" "$domain" "$finalnginxconf"
	fi
	if test -n "${port:-}"; then
		ynh_replace_string "__PORT__" "$port" "$finalnginxconf"
	fi
	if test -n "${app:-}"; then
		ynh_replace_string "__NAME__" "$app" "$finalnginxconf"
	fi
	if test -n "${final_path:-}"; then
		ynh_replace_string "__FINALPATH__" "$final_path" "$finalnginxconf"
	fi

	# Replace all other variable given as arguments
	for v in $others_var
	do
        ynh_replace_string "__${v^^}__" "${!v}" "$finalnginxconf"
	done
	
    if [ "${path_url:-}" != "/" ]
    then
        ynh_replace_string "^#sub_path_only" "" "$finalnginxconf"
    fi

	ynh_store_file_checksum "$finalnginxconf"

	sudo systemctl reload nginx
}
