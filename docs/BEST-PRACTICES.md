# Bonnes pratiques CI/CD

Ce document regroupe les bonnes pratiques les plus utiles pour concevoir une chaine CI/CD propre, maintenable et securisee.

## 1. Versionner le pipeline avec le code

Le fichier `.gitlab-ci.yml` doit vivre avec le code applicatif.

Interet :

- historique clair
- revue de changements possible
- pipeline aligne avec la version du projet

## 2. Garder des jobs petits

Un job doit avoir une responsabilite claire.

Exemples :

- `lint`
- `test`
- `build`
- `package`
- `deploy-dev`

Eviter :

- un seul job qui fait tout

## 3. Separer validation, build et deploy

Bonne separation :

- validation pour verifier la qualite
- build pour produire un artefact
- deploy pour publier cet artefact

Cette separation facilite :

- le debug
- la reutilisation
- la tracabilite

## 4. Faire echouer tot

Les verifications les plus simples doivent passer en premier.

Ordre logique :

1. syntaxe
2. lint
3. tests
4. build
5. deploiement

## 5. Eviter les secrets dans le code

Les secrets ne doivent pas etre commits.

Utiliser :

- les variables GitLab CI/CD
- les variables masquees
- les variables protegees pour les branches sensibles

## 6. Utiliser des images explicites

Preferer :

- des images connues
- des versions explicites

Eviter :

- `latest` partout sans controle

Note :

- dans un lab, `latest` peut depanner
- dans une chaine serieuse, les versions explicites sont preferables

## 7. Garder les pipelines rapides

Un pipeline trop lent perd sa valeur pedagogique et operationnelle.

Bonnes pratiques :

- limiter les etapes inutiles
- ne pas dupliquer les traitements
- paralleliser seulement quand cela a du sens

## 8. Produire des artefacts tracables

Exemples :

- rapports de tests
- binaire
- archive
- image Docker

Interet :

- savoir exactement ce qui a ete produit
- redeployer le meme resultat

## 9. Ajouter un smoke test apres deploy

Un deploiement n'est pas valide seulement parce que `docker compose up -d` ne renvoie pas d'erreur.

Verifier ensuite :

- reponse HTTP
- page de login
- endpoint applicatif
- statut du conteneur

## 10. Garder le deploy maitrise

En environnement de lab, un job de deploy manuel sur la branche par defaut est une bonne approche.

Pourquoi :

- on garde la maitrise
- on evite les deploiements accidentels
- on comprend mieux la difference entre CI et CD

## 11. Proteger la production

En globalite, une bonne chaine separe les environnements.

Modele simple :

- developpement
- recette
- preproduction
- production

Ce qui doit changer entre environnements :

- variables
- approbations
- niveau de verification
- controle d'acces

## 12. Prevoir le rollback

Une bonne pratique ne consiste pas seulement a deployer.

Il faut aussi savoir :

- revenir a une version precedente
- restaurer la configuration
- verifier le retour a l'etat stable

## 13. Standardiser les conventions

Choisir des conventions simples :

- noms de jobs coherents
- noms de stages coherents
- dossiers d'exemples previsibles
- variables nommees explicitement

## 14. Observer et documenter

Une CI/CD bien faite doit laisser :

- des logs lisibles
- un historique exploitable
- une documentation d'usage
- une documentation d'exploitation

## 15. Penser securite des runners

Dans ce lab, le runner a acces au socket Docker de l'hote.

C'est pratique, mais sensible.

En environnement reel :

- isoler les runners
- limiter les permissions
- separer les runners par niveau de confiance

## Resume

Les meilleures pratiques globales sont simples a retenir :

- pipeline versionne
- jobs courts
- secrets hors du code
- deploy controle
- verification post-deploiement
- documentation claire
