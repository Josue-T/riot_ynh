## Fonctionnalités spécifiques à YunoHost

### Prise en charge multi-utilisateurs

Maintenant, cette application prend en charge le SSO. Si vous souhaitez utiliser le sso, vous devez définir le chemin d'accès au serveur domestique par défaut car votre serveur domestique est installé sur votre instance YunoHost.

## Informations supplémentaires

### Note de sécurité importante

Nous vous déconseillons d'exécuter Element à partir du même nom de domaine que votre Matrix
serveur domestique (Synapse). La raison en est le risque de XSS (cross-site-scripting)
vulnérabilités qui pourraient survenir si quelqu'un provoquait le chargement et le rendu d'Element
un utilisateur malveillant a généré du contenu à partir d'une API Matrix qui avait alors fait confiance
accès à Element (ou à d'autres applications) en raison du partage du même domaine.

Nous avons mis en place des mesures d'atténuation grossières pour essayer de nous protéger contre ce
situation, mais ce n'est toujours pas une bonne pratique de le faire en premier lieu. Voir
https://github.com/vector-im/riot-web/issues/1977 pour plus de détails.

### Migration à partir de l'ancien nom d'application "Riot"

Comme cette application ne contient aucune donnée côté serveur, aucune migration n'a été effectuée pour migrer de "Riot" vers "Element".
Il vous suffira donc de supprimer Riot et d'installer Element sur le même domaine (vous pouvez modifier le chemin) pour pouvoir conserver les données sur votre navigateur Web.
Ainsi, le processus de migration vers l'élément est le suivant :

1. Obtenez le domaine de "Riot": `yunohost app setting riot domain`
2. Supprimer Riot : `yunohost app remove riot`
3. Élément d'installation : `yunohost app install element`
