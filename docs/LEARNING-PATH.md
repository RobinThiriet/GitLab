# Parcours d'apprentissage GitLab CI/CD

Ce document propose une progression simple pour apprendre GitLab CI/CD avec le lab local.

## Prerequis

Avant de commencer :

- GitLab doit etre accessible sur `http://localhost:8080`
- le runner doit etre enregistre et actif
- vous devez pouvoir creer un projet GitLab

## Exercice 1

Objectif :

- comprendre le declenchement automatique d'un pipeline

Actions :

1. creer un projet GitLab vide
2. ajouter le contenu de [examples/basic/.gitlab-ci.yml](/root/GitLab/examples/basic/.gitlab-ci.yml)
3. faire un commit
4. observer le pipeline

Resultat attendu :

- un pipeline avec un seul job
- un job qui passe au vert

Ce que vous apprenez :

- role du fichier `.gitlab-ci.yml`
- declenchement sur `push`
- lecture du log de job

## Exercice 2

Objectif :

- decouper un pipeline en plusieurs `stages`

Actions :

1. partir de l'exemple basic
2. ajouter les stages `lint`, `test`, `build`
3. creer un job par stage

Resultat attendu :

- les jobs s'executent dans l'ordre des stages

Ce que vous apprenez :

- notion de stage
- ordonnancement des jobs
- lecture du graphe de pipeline

## Exercice 3

Objectif :

- publier et reutiliser des `artifacts`

Actions :

1. utiliser [examples/intermediate/.gitlab-ci.yml](/root/GitLab/examples/intermediate/.gitlab-ci.yml)
2. faire produire un fichier dans le job `build`
3. consommer ce fichier dans le job `package`

Resultat attendu :

- un artifact disponible dans l'interface GitLab

Ce que vous apprenez :

- conservation temporaire de fichiers
- transfert de sorties entre jobs

## Exercice 4

Objectif :

- utiliser des variables CI/CD

Actions :

1. creer une variable dans `Settings` > `CI/CD` > `Variables`
2. lire cette variable dans un job
3. afficher sa presence sans exposer une valeur sensible

Resultat attendu :

- le job voit bien la variable

Ce que vous apprenez :

- stockage de configuration
- difference entre code et secret

## Exercice 5

Objectif :

- controler quand un job doit s'executer

Actions :

1. ajouter des `rules`
2. declencher certains jobs seulement sur la branche par defaut
3. faire varier les commits entre branche principale et branche de test

Resultat attendu :

- certains jobs ne se lancent que dans des cas precis

Ce que vous apprenez :

- filtration des jobs
- pipelines plus rapides et plus ciblés

## Exercice 6

Objectif :

- simuler une mini chaine CI/CD complete

Actions :

1. utiliser l'exemple intermediaire
2. ajouter un job `deploy-dev` manuel
3. faire ecrire un message de deploiement simulé

Resultat attendu :

- un pipeline avec `lint`, `test`, `build`, `package`, `deploy`

Ce que vous apprenez :

- distinction CI et CD
- jobs manuels
- notion d'environnement cible

## Exercice 7

Objectif :

- explorer le debug d'un pipeline en echec

Actions :

1. introduire volontairement une erreur dans un script
2. relancer le pipeline
3. analyser le log
4. corriger puis relancer

Resultat attendu :

- premier pipeline en echec
- second pipeline reussi

Ce que vous apprenez :

- lecture des logs
- investigation d'echec
- boucle de correction rapide

## Progression recommandee

Ordre conseille :

1. pipeline minimal
2. stages
3. artifacts
4. variables
5. rules
6. job manuel de deploiement
7. gestion d'echec

## Bonnes pratiques a retenir

- garder les jobs petits et lisibles
- nommer clairement les stages
- versionner le pipeline avec le code
- utiliser les variables GitLab pour les secrets
- eviter les scripts trop longs dans `.gitlab-ci.yml`

## Suite logique

Apres ce parcours, vous pouvez approfondir :

- `cache`
- `needs`
- environnements
- merge requests
- templates de pipeline reutilisables
