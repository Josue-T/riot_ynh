## YunoHost specific features

### Multi-users support

This application support the SSO. If you want to use the SSO, you need to define the path to the default homeserver as your homeserver witch is installed on your YunoHost instance.

## Additional informations

### Important Security Note

We do not recommend running Element from the same domain name as your Matrix
homeserver (Synapse).  The reason is the risk of XSS (cross-site-scripting)
vulnerabilities that could occur if someone caused Element to load and render
malicious user generated content from a Matrix API which then had trusted
access to Element (or other apps) due to sharing the same domain.

We have put some coarse mitigations into place to try to protect against this
situation, but it's still not good practice to do it in the first place.  See
https://github.com/vector-im/riot-web/issues/1977 for more details.
