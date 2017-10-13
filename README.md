Riot For yunohost
==================

Yunohost chattroom with matrix : [https://riot.im/app/#/room/#yunohost:matrix.org](https://riot.im/app/#/room/#yunohost:matrix.org)

[Yunohost project](https://yunohost.org/#/)

It's a webclient for matrix. For a matrix server you can install synapse on your server : https://github.com/YunoHost-Apps/synapse_ynh

**Mise à jour du package:**
sudo yunohost app upgrade riot -u https://github.com/YunoHost-Apps/riot_ynh


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

- SSO auth see issue : https://github.com/vector-im/riot-web/issues/3830
- Improve documentation



