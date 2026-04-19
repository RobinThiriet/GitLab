# GitLab local pour se former au CI/CD

Cette stack lance :

- `GitLab CE` pour l'interface web, les dépots et les pipelines
- `GitLab Runner` pour executer les jobs CI

## Prerequis

- Docker
- Docker Compose
- au moins 8 Go de RAM disponibles si possible

## Mise en route

1. Copier le fichier d'environnement :

```bash
cp .env.example .env
```

Un fichier `.env` par defaut est deja fourni pour un usage local sur `http://localhost:8080`.

2. Demarrer la stack :

```bash
docker compose up -d
```

3. Attendre que GitLab soit pret. Le premier demarrage peut prendre plusieurs minutes.

4. Recuperer le mot de passe initial `root` :

```bash
docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password
```

5. Ouvrir GitLab :

`http://localhost:8080`

Identifiant par defaut :

```text
root
```

## Enregistrer le runner

Dans GitLab :

1. Aller dans `Admin` > `CI/CD` > `Runners`
2. Creer un nouveau runner
3. Copier le token d'enregistrement

Puis executer :

```bash
./scripts/register-runner.sh VOTRE_TOKEN
```

Avant le premier enregistrement, vous pouvez preparer un fichier de config minimal :

```bash
mkdir -p data/runner/config
cp templates/runner-config.toml data/runner/config/config.toml
docker restart gitlab-runner
```

## Pipeline de test

Creer un projet GitLab puis ajouter ce fichier `.gitlab-ci.yml` :

```yaml
stages:
  - test

hello-ci:
  stage: test
  image: alpine:3.20
  script:
    - echo "CI/CD GitLab fonctionne"
    - uname -a
```

Une copie d'exemple est disponible dans `examples/basic/.gitlab-ci.yml`.

## Arreter la stack

```bash
docker compose down
```

Pour supprimer aussi les donnees :

```bash
docker compose down -v
rm -rf data
```

## Notes utiles

- `GITLAB_EXTERNAL_URL` doit correspondre exactement a l'URL reelle utilisee dans le navigateur, port compris
- le service peut etre un peu long a initialiser au premier lancement
- pour un usage purement local, `http://localhost:8080` est le plus simple
