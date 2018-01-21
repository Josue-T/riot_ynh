Riot For yunohost
==================

[![Integration level](https://dash.yunohost.org/integration/riot.svg)](https://ci-apps.yunohost.org/jenkins/job/riot%20%28Community%29/lastBuild/consoleFull) 

[![Install Riot with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=riot)

Yunohost chattroom with matrix : [https://riot.im/app/#/room/#yunohost:matrix.org](https://riot.im/app/#/room/#yunohost:matrix.org)

[Yunohost project](https://yunohost.org/#/)

It's a webclient for matrix. For a matrix server you can install synapse on your server : https://github.com/YunoHost-Apps/synapse_ynh

Install
-------

From command line:

`sudo yunohost app install -l riot https://github.com/YunoHost-Apps/riot_ynh`

Upgrade
-------

From command line:

`sudo yunohost app upgrade riot -u https://github.com/YunoHost-Apps/riot_ynh`

Issue
-----

Any issue is welcome here : https://github.com/YunoHost-Apps/riot_ynh/issues

SSO support
-----------

Now this application support the sso. If you want to use the sso you need to define the path to the default homeserver as your homeserver witch is installed on your yunohost instance.

Important Security Note
-----------------------

We do not recommend running Riot from the same domain name as your Matrix
homeserver (synapse).  The reason is the risk of XSS (cross-site-scripting)
vulnerabilities that could occur if someone caused Riot to load and render
malicious user generated content from a Matrix API which then had trusted
access to Riot (or other apps) due to sharing the same domain.

We have put some coarse mitigations into place to try to protect against this
situation, but it's still not good practice to do it in the first place.  See
https://github.com/vector-im/riot-web/issues/1977 for more details.

License
-------

Riot-Web is published under the Apache License : https://github.com/vector-im/riot-web/blob/master/LICENSE

Todo for official App
---------------------

- Improve documentation
