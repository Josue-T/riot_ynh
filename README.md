Element For yunohost
=================

[![Integration level](https://dash.yunohost.org/integration/element.svg)](https://dash.yunohost.org/appci/app/element) ![](https://ci-apps.yunohost.org/ci/badges/element.status.svg) ![](https://ci-apps.yunohost.org/ci/badges/element.maintain.svg)  
[![Install Element with YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=element)

> *This package allow you to install Element quickly and simply on a YunoHost server.  
If you don't have YunoHost, please see [here](https://yunohost.org/#/install) to know how to install and enjoy it.*

Overview
--------

It's a webclient for matrix. For a matrix server you can install synapse on your server : https://github.com/YunoHost-Apps/synapse_ynh

Yunohost chattroom with matrix : [https://app.element.io/#/room/#yunohost:matrix.org](https://app.element.io/#/room/#yunohost:matrix.org)

**Shipped version:** 1.8.5

Screenshots
-----------

#### Own your conversations

All-in-one secure chat app for teams, friends and organisations. Keeps conversations in your control, safe from data-mining and ads. Talk to everyone through the open global Matrix network, protected by proper end-to-end encryption.

![](https://element.io/images/homepage-all-platforms-1-p-800.png)
![](https://element.io/images/ios-room-chat-012x-p-500.png)
![](https://element.io/images/pixel4-rooms-light-012x-p-500.png)

**Element gives you the privacy you expect from a conversation in your own home, but with everyone across the globe.**

##### Keep it personal

Group chat, video calls and sharing to stay in touch and coordinate with family and friends.

![](https://element.io/images/for-personal.png)

##### Revolutionise the workplace

Highly effective teamwork within a company, across a business ecosystem or an entire government.

![](https://element.io/images/temp-img-pro-use-01.png)

##### Host your community

From clubs to social movements, keep everyone together with a platform everyone can use.

![](https://element.io/images/temp-community-image-02.png)

Demo
----

* [Official demo](https://app.element.io/)

Documentation
-------------

 * Official documentation: https://element.io/help
 * YunoHost documentation: There no other documentations, feel free to contribute.

YunoHost specific features
--------------------------

### Multi-users support

Now this application support the sso. If you want to use the sso you need to define the path to the default homeserver as your homeserver witch is installed on your yunohost instance.

### Supported architectures

* x86-64 - [![Build Status](https://ci-apps.yunohost.org/ci/logs/element%20%28Apps%29.svg)](https://ci-apps.yunohost.org/ci/apps/element/)
* ARMv8-A - [![Build Status](https://ci-apps-arm.yunohost.org/ci/logs/element%20%28Apps%29.svg)](https://ci-apps-arm.yunohost.org/ci/apps/element/)

<!--## Limitations

* Any known limitations.-->

Additional informations
-----------------------

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

Links
-----

 * Report a bug: https://github.com/YunoHost-Apps/element_ynh/issues
 * App website: https://element.io/
 * YunoHost website: https://yunohost.org/

---

Install
-------

From command line:

`sudo yunohost app install -l element https://github.com/YunoHost-Apps/element_ynh`

Upgrade
-------

From command line:

`sudo yunohost app upgrade element -u https://github.com/YunoHost-Apps/element_ynh`

Developers infos
----------------

Please do your pull request to the [testing branch](https://github.com/YunoHost-Apps/element_ynh/tree/testing).

To try the testing branch, please proceed like that.
```
sudo yunohost app install https://github.com/YunoHost-Apps/element_ynh/tree/testing --debug
or
sudo yunohost app upgrade element -u https://github.com/YunoHost-Apps/element_ynh/tree/testing --debug
```

License
-------

Element-Web is published under the Apache License : https://github.com/vector-im/riot-web/blob/master/LICENSE

Todo for official App
---------------------

- Improve documentation
