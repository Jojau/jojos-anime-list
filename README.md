# Jojo's Anime List

Une application Flutter.

## Commandes
```flutter run``` en ayant un simulateur (Android ou iOS par exemple) ouvert sur votre machine (nécéssite d'avoir installé flutter au préalable).

## Fonctionnalités développées :
Sur l'écran d'accueil 10 animes de l'hiver 2023 s'affichent. Ils sont récupérés de l'API MyAnimeList.

Pour chaque anime vous avez 3 actions possibles :
- L'ajouter à vos favoris. Il sera alors sauvegardé sur votre appareil, dans votre liste de favoris.
- Voir ses détails. Cela ouvre la page web de l'anime en question sur myanimelist.net.
- Le partager. Vous pourrez alors choisir dans quelle application (messages, emails ou autres) partager le nom de l'anime ainsi que le lien de sa page.

Vous avez également l'onglet favoris qui affiche les animes que vous aurez ajouté à vos favoris.

## Réponses aux consignes
Concernant les différentes contraintes du projet:
- L'appli est développée avec Flutter donc elle pourra être déclinée sur au moins deux types d'appareils si ce n'est plus.
- Des appels APIs sont présents: Un qui appelle une liste de 10 animes de la saison, ainsi qu'un appel par anime afin d'avoir ses détails (nombre et durées des épisodes, récurrence etc).
- Une animation est présente lorsque l'on bascule de l'onglet "liste" vers "favoris" et inversement, en utilisant le package "animations".
- La webview s'affiche lorque l'on tape sur "voir les détails" d'un anime.
- La barre de menu est présente en bas pour basculer d'un onglet à l'autre.
- Le bouton "partager" à été réalisé avec le package "share plus" et permet de partager un anime dans l'application de son choix.
- En bonus je me suis servie du package "path provider" pour sauvegarder des données simples dans le stockage de l'appareil.

Concernant les autres critères de notation:
- Propreté du code : Je pense avoir bien décomposé les différents écrans/widgets/onglets. Vous trouverez cepandant toujours le fichier Data/animes.dart qui contient un tableau d'anime dont je me servais avant d'avoir mis en place les appels vers l'API. Il ne me sert plus mais je ne l'ai pas effacé de l'arborescence.
- Qualité visuelle : Des améliorations pourraient être faites mais cela n'a pas été ma priorité.
- Fonctionnalités : Les fonctionnalités restent simples mais cohérentes. L'ajout aux favoris en local est un plus car le site MyAnimeList nécéssite un compte pour pouvoir faire cela - l'application permet donc d'avoir sa propre liste en local sans authentification.

## Améliorations possibles
- Revoir le style graphique de l'application.
- Ajouter un onlget "recherche" qui puisse permettre de rechercher un anime et de renvoyer une liste de résultats. L'ajout aux favoris aurait alors plus de sens, plutôt que de devoir choisir parmi une liste de 10 animes du moment.
