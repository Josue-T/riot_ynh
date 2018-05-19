# Delete a file checksum from the app settings
#
# $app should be defined when calling this helper
#
# usage: ynh_remove_file_checksum file
# | arg: file - The file for which the checksum will be deleted
ynh_delete_file_checksum () {
	local checksum_setting_name=checksum_${1//[\/ ]/_}	# Replace all '/' and ' ' by '_'
	ynh_app_setting_delete $app $checksum_setting_name
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
