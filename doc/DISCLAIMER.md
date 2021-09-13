
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
