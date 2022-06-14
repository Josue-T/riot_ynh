## Fonctionnalités spécifiques à YunoHost

### Prise en charge multi-utilisateurs

Cette application prend en charge le SSO. Si vous souhaitez utiliser le SSO, vous devez définir le chemin d'accès au serveur domestique par défaut car votre serveur domestique est installé sur votre instance YunoHost.

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
