# Element pour YunoHost

[![Niveau d'intégration](https://dash.yunohost.org/integration/element.svg)](https://dash.yunohost.org/appci/app/element) ![](https://ci-apps.yunohost.org/ci/badges/element.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/element.maintain.svg)  
[![Installer Element avec YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=element)

*[Read this readme in english.](./README.md)*
*[Lire ce readme en français.](./README_fr.md)*

> *Ce package vous permet d'installer Element rapidement et simplement sur un serveur YunoHost.
Si vous n'avez pas YunoHost, regardez [ici](https://yunohost.org/#/install) pour savoir comment l'installer et en profiter.*

## Vue d'ensemble

Element is a new type of messaging app. You choose where your messages are stored, putting you in control of your data. It gives you access to the Matrix open network, so you can talk to anyone. Element provides a new level of security, adding cross-signed device verification to default end-to-end encryption.

**Version incluse :** 1.8.4~ynh1

**Démo :** https://app.element.io/

## Captures d'écran

![](./doc/screenshots/homepage-all-platforms-1_1.png)

## Avertissements / informations importantes


## YunoHost specific features

### Multi-users support

Now this application support the SSO. If you want to use the sso you need to define the path to the default homeserver as your homeserver witch is installed on your YunoHost instance.

## Additional informations

### Important Security Note

We do not recommend running Element from the same domain name as your Matrix
homeserver (synapse).  The reason is the risk of XSS (cross-site-scripting)
vulnerabilities that could occur if someone caused Element to load and render
malicious user generated content from a Matrix API which then had trusted
access to Element (or other apps) due to sharing the same domain.

We have put some coarse mitigations into place to try to protect against this
situation, but it's still not good practice to do it in the first place.  See
https://github.com/vector-im/riot-web/issues/1977 for more details.

### Migration from old app name "Riot"

As this app don't contains any data on the server side no migration was made to migrate from "Riot" to "Element".
So you just will need to remove Riot and install Element on the same domain (you can change the path) to be able to keep the data on your web browser.
So the process to migrate to element is the following:

1. Get the domain of "Riot": `yunohost app setting riot domain`
2. Remove Riot: `yunohost app remove riot`
3. Install Element: `yunohost app install element`

## Documentations et ressources

* Site officiel de l'app : https://element.io
* Documentation officielle de l'admin : https://element.io/help
* Dépôt de code officiel de l'app : https://github.com/vector-im/element-web/
* Documentation YunoHost pour cette app : https://yunohost.org/app_element
* Signaler un bug : https://github.com/YunoHost-Apps/element_ynh/issues

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche testing](https://github.com/YunoHost-Apps/element_ynh/tree/testing).

Pour essayer la branche testing, procédez comme suit.
```
sudo yunohost app install https://github.com/YunoHost-Apps/element_ynh/tree/testing --debug
ou
sudo yunohost app upgrade element -u https://github.com/YunoHost-Apps/element_ynh/tree/testing --debug
```

**Plus d'infos sur le packaging d'applications :** https://yunohost.org/packaging_apps