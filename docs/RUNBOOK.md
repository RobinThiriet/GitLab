# Runbook du lab GitLab

Ce document sert de guide d'exploitation rapide pour le lab local GitLab.

## Demarrage

Lancer la stack :

```bash
docker compose up -d
```

Verifier l'etat :

```bash
docker compose ps
```

Suivre les logs GitLab :

```bash
docker logs -f gitlab
```

Suivre les logs Runner :

```bash
docker logs -f gitlab-runner
```

## Verification de sante

Verifier l'URL web :

```bash
curl -I http://localhost:8080/users/sign_in
```

Verifier les services internes GitLab :

```bash
docker exec gitlab gitlab-ctl status
```

Verifier le mot de passe root initial :

```bash
docker exec gitlab grep 'Password:' /etc/gitlab/initial_root_password
```

## Acces

Interface web :

```text
http://localhost:8080
```

SSH Git :

```text
ssh://git@localhost:2224
```

## Runner

Preparer la configuration minimale :

```bash
mkdir -p data/runner/config
cp templates/runner-config.toml data/runner/config/config.toml
docker restart gitlab-runner
```

Enregistrer le runner :

```bash
./scripts/register-runner.sh VOTRE_TOKEN
```

Verifier les logs :

```bash
docker logs --tail 100 gitlab-runner
```

## Incidents frequents

### GitLab ne repond pas

Verifier :

```bash
docker compose ps
docker logs --tail 100 gitlab
```

Causes probables :

- initialisation encore en cours
- manque de RAM
- port local occupe

### `502 Bad Gateway`

Verifier :

```bash
docker exec gitlab gitlab-ctl status
docker logs --tail 100 gitlab
```

Interpretation :

- `nginx` repond
- `puma/rails` n'est pas encore pret ou a redemarre

### Le runner ne prend aucun job

Verifier :

```bash
docker logs --tail 100 gitlab-runner
cat data/runner/config/config.toml
```

Verifier aussi :

- le token du runner
- l'etat du socket Docker
- le statut du runner dans GitLab

## Maintenance courante

Redemarrer GitLab :

```bash
docker restart gitlab
```

Redemarrer le runner :

```bash
docker restart gitlab-runner
```

Recreer la stack :

```bash
docker compose up -d --force-recreate
```

Arreter :

```bash
docker compose down
```

## Sauvegarde simple

Pour ce lab, la persistance repose surtout sur :

- `data/gitlab/config`
- `data/gitlab/logs`
- `data/gitlab/data`
- `data/runner/config`

Sauvegarde simple :

```bash
tar czf gitlab-lab-backup.tar.gz data
```

Restauration simple :

```bash
tar xzf gitlab-lab-backup.tar.gz
docker compose up -d
```

## Reinitialisation complete

Arreter et supprimer les conteneurs :

```bash
docker compose down -v
```

Supprimer les donnees :

```bash
rm -rf data
```

Puis relancer :

```bash
docker compose up -d
```

## Checklist de fin de mise en route

- GitLab repond sur `http://localhost:8080`
- le compte `root` fonctionne
- le runner est visible dans GitLab
- un pipeline d'exemple passe avec succes
