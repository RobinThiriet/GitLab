# Projet GitLab prêt à importer : Apache Guacamole

Ce dossier est autonome : vous pouvez l'importer comme nouveau projet GitLab, définir une variable CI/CD, puis lancer le pipeline pour déployer Guacamole sur l'hote Docker de votre runner local.

## Contenu

- `.gitlab-ci.yml` : pipeline GitLab prêt a l'emploi
- `docker-compose.yml` : stack Guacamole
- `.env.example` : valeurs locales par defaut
- `scripts/prepare-initdb.sh` : generation officielle du schema PostgreSQL
- `scripts/wait-for-guacamole.sh` : verification post-deploiement

## Ce que deploie le projet

- `guacd` : proxy natif Guacamole
- `postgres` : base applicative
- `guacamole` : interface web

URL par defaut :

```text
http://localhost:8081
```

## Import dans GitLab

1. Creez un projet vide dans votre GitLab local.
2. Importez ou poussez le contenu de `guacamole-project/` dans ce projet.
3. Dans `Settings > CI/CD > Variables`, ajoutez au minimum `GUACAMOLE_DB_PASSWORD`.
4. Verifiez que votre runner Docker local est disponible pour le projet.
5. Lancez le pipeline sur la branche par defaut.

## Variables CI/CD

Obligatoire :

- `GUACAMOLE_DB_PASSWORD`

Optionnelles :

- `GUACAMOLE_HTTP_PORT` : port HTTP externe, defaut `8081`
- `GUACAMOLE_DB_NAME` : base PostgreSQL, defaut `guacamole_db`
- `GUACAMOLE_DB_USER` : utilisateur PostgreSQL, defaut `guacamole_user`
- `GUACAMOLE_IMAGE_TAG` : version Guacamole, defaut `1.6.0`

## Ce que fait le pipeline

1. `validate` : genere le schema SQL officiel puis valide `docker compose`
2. `deploy` : cree `.guacamole.env` et demarre la stack
3. `verify` : attend la reponse HTTP de Guacamole
4. `cleanup` : job manuel pour supprimer la stack et les volumes

## Premiere connexion

- URL : `http://localhost:8081`
- utilisateur : `guacadmin`
- mot de passe : `guacadmin`

Pensez a changer ce mot de passe des la premiere connexion.

## Execution locale hors GitLab

```bash
cp .env.example .env
chmod +x scripts/*.sh
./scripts/prepare-initdb.sh
docker compose --env-file .env up -d
./scripts/wait-for-guacamole.sh 8081
```

## Hypotheses

- le runner GitLab a acces au socket Docker de l'hote
- le deploiement vise un lab local, pas une production exposee sur Internet
