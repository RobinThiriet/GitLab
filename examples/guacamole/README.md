# Exemple complet : Guacamole par GitLab CI/CD

Ce dossier montre comment deployer Apache Guacamole via GitLab CI/CD dans un environnement de lab.

## Ce que contient ce dossier

- `.gitlab-ci.yml` pour le pipeline GitLab
- `docker-compose.guacamole.yml` pour la stack applicative
- `.env.example` pour les variables locales

## Stack applicative

Services :

- `guacamole` pour l'interface web
- `guacd` pour le proxy natif Guacamole
- `postgres` pour l'authentification et la configuration

## Port retenu

Guacamole est expose sur :

- `http://localhost:8081`

Ce choix evite le conflit avec GitLab qui utilise deja `8080`.

## Variables GitLab a creer

Variables minimales :

- `GUACAMOLE_DB_PASSWORD`

Variables optionnelles :

- `GUACAMOLE_HTTP_PORT`
- `GUACAMOLE_DB_NAME`
- `GUACAMOLE_DB_USER`

## Pipeline

Le pipeline suit 3 etapes :

1. `validate`
2. `deploy`
3. `verify`

## Deploiement

Le job `deploy` :

- genere un fichier d'environnement
- lance `docker compose up -d`
- cree ou recree les conteneurs necessaires

## Verification

Le job `verify` :

- execute un smoke test HTTP
- verifie que l'interface repond

## Premiere connexion

URL :

```text
http://localhost:8081
```

Compte par defaut :

- utilisateur : `guacadmin`
- mot de passe : `guacadmin`

Apres la premiere connexion :

- changer le mot de passe
- creer vos connexions RDP, SSH ou VNC

## Remarques importantes

- cet exemple est concu pour un lab
- il utilise le socket Docker de l'hote via le runner
- ce n'est pas une architecture de production
