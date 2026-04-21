# GitLab local pour se former au CI/CD

Ce depot fournit un lab local base sur Docker pour apprendre :

- l'administration de base de GitLab
- la creation de runners
- l'ecriture de pipelines `.gitlab-ci.yml`
- les premiers usages CI/CD en environnement local

La stack est volontairement simple :

- `GitLab CE` pour l'interface, les projets, les pipelines et la registry Git
- `GitLab Runner` pour executer les jobs CI

Les documents complementaires sont disponibles dans :

- [docs/ARCHITECTURE.md](/root/GitLab/docs/ARCHITECTURE.md)
- [docs/RUNBOOK.md](/root/GitLab/docs/RUNBOOK.md)
- [docs/LEARNING-PATH.md](/root/GitLab/docs/LEARNING-PATH.md)
- [docs/CI-CD-FOUNDATIONS.md](/root/GitLab/docs/CI-CD-FOUNDATIONS.md)
- [docs/BEST-PRACTICES.md](/root/GitLab/docs/BEST-PRACTICES.md)
- [docs/GUACAMOLE-CICD.md](/root/GitLab/docs/GUACAMOLE-CICD.md)

## Objectifs pedagogiques

Ce lab est adapte pour :

- comprendre le cycle `commit -> pipeline -> resultat`
- apprendre a enregistrer un runner Docker
- tester des jobs simples de build, test et lint
- manipuler un GitLab local sans cout cloud

Ce lab n'est pas cible pour :

- la haute disponibilite
- la production
- l'exposition publique sur Internet

## Architecture

Vue simplifiee :

```text
Navigateur
    |
    v
localhost:8080
    |
    v
Docker host
    |
    +--> conteneur gitlab
    |      - Nginx
    |      - Puma / Rails
    |      - Sidekiq
    |      - PostgreSQL
    |      - Redis
    |
    +--> conteneur gitlab-runner
           - executor Docker
           - jobs CI
```

Flux principal :

1. vous poussez du code dans un projet GitLab
2. GitLab detecte le pipeline via `.gitlab-ci.yml`
3. GitLab confie le job au runner enregistre
4. le runner lance un conteneur de job
5. le resultat remonte dans l'interface GitLab

Une vue plus complete, avec schema et decomposition des flux, est disponible dans [docs/ARCHITECTURE.md](/root/GitLab/docs/ARCHITECTURE.md).

## Prerequis

- Docker
- Docker Compose
- 8 Go de RAM disponibles au minimum
- 2 vCPU ou plus recommandes

Verification rapide :

```bash
docker --version
docker compose version
```

## Structure du depot

```text
.
├── docker-compose.yml
├── README.md
├── docs/
│   ├── ARCHITECTURE.md
│   ├── BEST-PRACTICES.md
│   ├── CI-CD-FOUNDATIONS.md
│   ├── GUACAMOLE-CICD.md
│   ├── LEARNING-PATH.md
│   └── RUNBOOK.md
├── examples/
│   ├── basic/.gitlab-ci.yml
│   ├── guacamole/
│   └── intermediate/.gitlab-ci.yml
├── scripts/
│   └── register-runner.sh
└── templates/
    └── runner-config.toml
```

## Variables d'environnement

Le fichier `.env.example` contient les valeurs par defaut pour un usage local.

Variables principales :

- `GITLAB_HOST=localhost`
- `GITLAB_EXTERNAL_URL=http://localhost:8080`
- `GITLAB_HTTP_PORT=8080`
- `GITLAB_HTTPS_PORT=8443`
- `GITLAB_SSH_PORT=2224`

## Mise en route

1. Copier les variables d'environnement :

```bash
cp .env.example .env
```

2. Demarrer la stack :

```bash
docker compose up -d
```

3. Suivre le demarrage :

```bash
docker compose ps
docker logs -f gitlab
```

4. Attendre que GitLab reponde sur :

```text
http://localhost:8080
```

Le premier demarrage peut prendre plusieurs minutes.

5. Recuperer le mot de passe initial `root` :

```bash
docker exec gitlab grep 'Password:' /etc/gitlab/initial_root_password
```

6. Se connecter avec :

- identifiant : `root`
- mot de passe : celui retourne par la commande precedente

## Enregistrer le runner

Avant le premier enregistrement, preparer un fichier de config minimal :

```bash
mkdir -p data/runner/config
cp templates/runner-config.toml data/runner/config/config.toml
docker restart gitlab-runner
```

Dans GitLab :

1. aller dans `Admin`
2. ouvrir `CI/CD`
3. ouvrir `Runners`
4. creer un nouveau runner
5. copier le token fourni

Puis, dans le terminal :

```bash
./scripts/register-runner.sh VOTRE_TOKEN
```

## Premier pipeline

Un exemple minimal est fourni dans [examples/basic/.gitlab-ci.yml](/root/GitLab/examples/basic/.gitlab-ci.yml).

Exemple :

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

Parcours conseille pour apprendre :

1. lancer ce pipeline minimal
2. ajouter un job `lint`
3. ajouter un job `build`
4. tester les `stages`
5. tester les `artifacts`
6. tester les `rules`

Un exemple plus complet est aussi disponible dans [examples/intermediate/.gitlab-ci.yml](/root/GitLab/examples/intermediate/.gitlab-ci.yml).

Il montre :

- plusieurs `stages`
- des `artifacts`
- des variables CI
- un job de deploiement manuel avec `rules`

Le parcours detaille d'apprentissage est documente dans [docs/LEARNING-PATH.md](/root/GitLab/docs/LEARNING-PATH.md).

## Comprendre la CI/CD dans sa globalite

Pour comprendre :

- comment fonctionne une chaine CI/CD
- comment GitLab, le pipeline et le runner interagissent
- quelle est la difference entre CI, delivery et deployment

consultez [docs/CI-CD-FOUNDATIONS.md](/root/GitLab/docs/CI-CD-FOUNDATIONS.md).

## Bonnes pratiques globales

Pour avoir une vue d'ensemble sur :

- la structuration des pipelines
- la gestion des secrets
- les strategies de deploy
- les controles post-deploiement

consultez [docs/BEST-PRACTICES.md](/root/GitLab/docs/BEST-PRACTICES.md).

## Cas complet avec Guacamole

Un cas de bout en bout est disponible pour montrer comment deployer une vraie application via GitLab CI/CD :

- [docs/GUACAMOLE-CICD.md](/root/GitLab/docs/GUACAMOLE-CICD.md)
- [examples/guacamole/README.md](/root/GitLab/examples/guacamole/README.md)

Ce cas montre :

- une stack applicative multi-conteneurs
- un pipeline GitLab dedie
- un deploy via runner
- une verification post-deploiement

## Commandes utiles

Demarrer :

```bash
docker compose up -d
```

Verifier l'etat :

```bash
docker compose ps
```

Voir les logs GitLab :

```bash
docker logs -f gitlab
```

Voir les logs Runner :

```bash
docker logs -f gitlab-runner
```

Arreter :

```bash
docker compose down
```

Supprimer aussi les donnees :

```bash
docker compose down -v
rm -rf data
```

## Troubleshooting

### `http://localhost:8080` ne repond pas

Verifier :

```bash
docker compose ps
docker logs --tail 100 gitlab
```

Causes frequentes :

- GitLab est encore en phase d'initialisation
- la machine manque de RAM
- un port local est deja utilise

### Le navigateur affiche `502 Bad Gateway`

Cela indique souvent que `nginx` repond mais que `puma/rails` n'est pas encore pret.

Attendre un peu puis verifier :

```bash
docker exec gitlab gitlab-ctl status
```

### Le runner apparait mais n'execute pas les jobs

Verifier :

```bash
docker logs --tail 100 gitlab-runner
```

Points a controler :

- le token utilise
- la presence de `data/runner/config/config.toml`
- l'acces au socket Docker `/var/run/docker.sock`

### GitLab est lent

Ca arrive souvent sur une machine de lab.

Actions utiles :

- fermer les applications lourdes
- allouer plus de RAM a Docker
- patienter au premier demarrage

## Limites et securite

Cette stack monte le socket Docker de l'hote dans le runner :

- c'est pratique pour apprendre
- ce n'est pas adapte a un environnement multi-utilisateur sensible

En production, il faut prevoir :

- une separation des roles
- une strategie reseau plus stricte
- une gestion des sauvegardes
- une gestion TLS propre
- des runners isoles

## Suite recommandee

Pour aller plus loin apres cette base :

1. creer un projet d'application de test
2. ajouter un pipeline `lint + test + build`
3. publier des artifacts
4. tester les variables CI/CD
5. simuler un deploiement vers un environnement de lab
