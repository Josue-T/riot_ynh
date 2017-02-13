#!/bin/bash

## Adapt md5sum while you update app
md5sum="9207037616522dd12ba5c2425eb05331"
verctor_version="0.9.7"

init_script() {
    TRAP_ON	# Active trap pour arrêter le script si une erreur est détectée.

    # Source YunoHost helpers
    source /usr/share/yunohost/helpers

    # Retrieve arguments
    app=$YNH_APP_INSTANCE_NAME
    CHECK_VAR "$app" "app name not set"
}

get_source() {

    wget -q -O '/tmp/vector.tar.gz' "https://github.com/vector-im/riot-web/releases/download/v${verctor_version}/vector-v${verctor_version}.tar.gz"

    if [[ ! -e '/tmp/vector.tar.gz' ]] || [[ $(md5sum '/tmp/vector.tar.gz' | cut -d' ' -f1) != $md5sum ]]
    then
        ynh_die "Error : can't get Riot source"
    fi
    tar xzf '/tmp/vector.tar.gz'
    sudo cp -r vector-v${verctor_version}/. $final_path/
    sudo chown www-data -R $final_path
    sudo chmod 740 -R $final_path
}


CHECK_VAR () {	# Vérifie que la variable n'est pas vide.
# $1 = Variable à vérifier
# $2 = Texte à afficher en cas d'erreur
	test -n "$1" || (echo "$2" >&2 && false)
}

EXIT_PROPERLY () {	# Provoque l'arrêt du script en cas d'erreur. Et nettoye les résidus.
	exit_code=$?
	if [ "$exit_code" -eq 0 ]; then
			exit 0	# Quitte sans erreur si le script se termine correctement.
	fi
	trap '' EXIT
	set +eu
	echo -e "\e[91m \e[1m"	# Shell in light red bold
	echo -e "!!\n  $app install's script has encountered an error. Installation was cancelled.\n!!" >&2

	if type -t CLEAN_SETUP > /dev/null; then	# Vérifie l'existance de la fonction avant de l'exécuter.
		CLEAN_SETUP	# Appel la fonction de nettoyage spécifique du script install.
	fi

	# Compense le bug de ssowat qui ne supprime pas l'entrée de l'app en cas d'erreur d'installation.
	sudo sed -i "\@\"$domain$path/\":@d" /etc/ssowat/conf.json

	ynh_die
}

TRAP_ON () {	# Activate signal capture
	set -eu	# Exit if a command fail, and if a variable is used unset.
	trap EXIT_PROPERLY EXIT	# Capturing exit signals on shell script
}

# Ignore the yunohost-cli log to prevent errors with conditionals commands
# usage: NO_LOG COMMAND
# Simply duplicate the log, execute the yunohost command and replace the log without the result of this command
# It's a very badly hack...
# Petite copie perso à mon usage ;)
NO_LOG() {
  ynh_cli_log=/var/log/yunohost/yunohost-cli.log
  sudo cp -a ${ynh_cli_log} ${ynh_cli_log}-move
  eval $@
  exit_code=$?
  sudo mv ${ynh_cli_log}-move ${ynh_cli_log}
  return $?
}

CHECK_USER () {	# Vérifie la validité de l'user admin
# $1 = Variable de l'user admin.
	ynh_user_exists "$1" || (echo "Wrong admin" >&2 && false)
}

CHECK_PATH () {	# Vérifie la présence du / en début de path. Et son absence à la fin.
	if [ "${path:0:1}" != "/" ]; then    # Si le premier caractère n'est pas un /
		path="/$path"    # Ajoute un / en début de path
	fi
	if [ "${path:${#path}-1}" == "/" ] && [ ${#path} -gt 1 ]; then    # Si le dernier caractère est un / et que ce n'est pas le seul caractère.
		path="${path:0:${#path}-1}"	# Supprime le dernier caractère
	fi
}

CHECK_DOMAINPATH () {	# Vérifie la disponibilité du path et du domaine.
	sudo yunohost app checkurl $domain$path -a $app
}

CHECK_FINALPATH () {	# Vérifie que le dossier de destination n'est pas déjà utilisé.
	final_path=/var/www/$app
	if [ -e "$final_path" ]
	then
		echo "This path already contains a folder" >&2
		false
	fi
}

STORE_MD5_CONFIG () {	# Enregistre la somme de contrôle du fichier de config
# $1 = Nom du fichier de conf pour le stockage dans settings.yml
# $2 = Nom complet et chemin du fichier de conf.
	ynh_app_setting_set $app $1_file_md5 $(sudo md5sum "$2" | cut -d' ' -f1)
}

CHECK_MD5_CONFIG () {	# Créé un backup du fichier de config si il a été modifié.
# $1 = Nom du fichier de conf pour le stockage dans settings.yml
# $2 = Nom complet et chemin du fichier de conf.
	if [ "$(ynh_app_setting_get $app $1_file_md5)" != $(sudo md5sum "$2" | cut -d' ' -f1) ]; then
		sudo cp -a "$2" "$2.backup.$(date '+%d.%m.%y_%Hh%M,%Ss')"	# Si le fichier de config a été modifié, créer un backup.
	fi
}

FIND_PORT () {	# Cherche un port libre.
# $1 = Numéro de port pour débuter la recherche.
	port=$1
	while ! sudo yunohost app checkport $port ; do
		port=$((port+1))
	done
	CHECK_VAR "$port" "port empty"
}


### REMOVE SCRIPT

REMOVE_NGINX_CONF () {	# Suppression de la configuration nginx
	if [ -e "/etc/nginx/conf.d/$domain.d/$app.conf" ]; then	# Delete nginx config
		echo "Delete nginx config"
		sudo rm "/etc/nginx/conf.d/$domain.d/$app.conf"
		sudo service nginx reload
	fi
}

REMOVE_FPM_CONF () {	# Suppression de la configuration du pool php-fpm
	if [ -e "/etc/php5/fpm/pool.d/$app.conf" ]; then	# Delete fpm config
		echo "Delete fpm config"
		sudo rm "/etc/php5/fpm/pool.d/$app.conf"
	fi
	if [ -e "/etc/php5/fpm/conf.d/20-$app.ini" ]; then	# Delete php config
		echo "Delete php config"
		sudo rm "/etc/php5/fpm/conf.d/20-$app.ini"
	fi
	sudo service php5-fpm reload
}

REMOVE_LOGROTATE_CONF () {	# Suppression de la configuration de logrotate
	if [ -e "/etc/logrotate.d/$app" ]; then
		echo "Delete logrotate config"
		sudo rm "/etc/logrotate.d/$app"
	fi
}

SECURE_REMOVE () {      # Suppression de dossier avec vérification des variables
	chaine="$1"	# L'argument doit être donné entre quotes simple '', pour éviter d'interpréter les variables.
	no_var=0
	while (echo "$chaine" | grep -q '\$')	# Boucle tant qu'il y a des $ dans la chaine
	do
		no_var=1
		global_var=$(echo "$chaine" | cut -d '$' -f 2)	# Isole la première variable trouvée.
		only_var=\$$(expr "$global_var" : '\([A-Za-z0-9_]*\)')	# Isole complètement la variable en ajoutant le $ au début et en gardant uniquement le nom de la variable. Se débarrasse surtout du / et d'un éventuel chemin derrière.
		real_var=$(eval "echo ${only_var}")		# `eval "echo ${var}` permet d'interpréter une variable contenue dans une variable.
		if test -z "$real_var" || [ "$real_var" = "/" ]; then
			echo "Variable $only_var is empty, suppression of $chaine cancelled." >&2
			return 1
		fi
		chaine=$(echo "$chaine" | sed "s@$only_var@$real_var@")	# remplace la variable par sa valeur dans la chaine.
	done
	if [ "$no_var" -eq 1 ]
	then
		if [ -e "$chaine" ]; then
			echo "Delete directory $chaine"
			sudo rm -r "$chaine"
		fi
		return 0
	else
		echo "No detected variable." >&2
		return 1
	fi
}

REMOVE_BDD () {	# Suppression de la base de donnée et de l'utilisateur associé.
# $1 = Nom de la base de donnée
	# Utilise '$app' comme nom d'utilisateur et de base de donnée
	db_user=$1
	if mysqlshow -u root -p$(sudo cat $MYSQL_ROOT_PWD_FILE) | grep -q "^| $db_user"; then
		echo "Delete db"
		ynh_mysql_drop_db $db_user
		ynh_mysql_drop_user $db_user
	fi
}

REMOVE_SYS_USER () {   # Supprime l'utilisateur système dédié à l'app
    if ynh_system_user_exists "$app"	# Test l'existence de l'utilisateur
    then
    	sudo userdel $app
    fi
}
