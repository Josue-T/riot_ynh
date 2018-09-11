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
            a=${a//'^'/'\^'}
            a=${a//'$'/'\$'}
        }

        # We get the name of the Lifecycle objet
        Lifecycle_object_name=$(egrep -o 'onLoggedIn:[\w\$]+\.setLoggedIn,' $final_path/bundles/*/bundle.js | egrep -o ':[\w\$]+\.' | egrep -o '[\w\$]')

        # We get the part witch we need to patch and create a regular expression
        a='case"start_login":this.setStateForNewView({view:unnamed_object.LOGIN}),this.notifyNewScreen("login");break;'
        escape_string
        match_string="${a//'unnamed_object'/'(\w+)'}"

        # We create a regular expression from the patch file
        a="$(cat ../sources/bundle_patch.js)"
        escape_string
        a="${a//'unnamed_object'/'\1'}"
        a="${a//'Lifecycle'/$Lifecycle_object_name}"
        a="$(echo "$a" | sed -r "s|//.*||g")"
        replace_string="$(echo $a)"
        sed --in-place -r "s|$match_string|$replace_string|g" $final_path/bundles/*/bundle.js
    fi
}

set_permission() {
    chown www-data:$app -R $final_path
    chmod u=rX,g=rX,o= -R $final_path
}
