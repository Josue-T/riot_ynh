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
    ynh_replace_string --match_string __DEFAULT_SERVER__ --replace_string $default_home_server --target_file $final_path/config.json
}

install_source() {
    ynh_setup_source --dest_dir $final_path/
}

set_permission() {
    chown www-data:root -R $final_path
    chmod u=rX,g=rX,o= -R $final_path
}
