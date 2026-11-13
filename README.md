# MDD - Monde de Dév

Socle du projet 5 : un réseau social pour développeurs.

Ce dépôt reprend le [starter OpenClassrooms](https://github.com/OpenClassrooms-Student-Center/DFSJS-Prenez-en-charge-le-d-veloppement-d-une-application-full-stack-JavaScript-compl-te) au commit `0f1b3ea`. L'historique initial est conservé ; `origin` désigne le dépôt du projet et `upstream` le starter.

## État du projet

L'environnement de développement est configuré. La page d'accueil provient du starter. L'authentification, les profils, thèmes, abonnements, articles et commentaires restent à développer ; les liens de connexion et d'inscription conduisent actuellement à une page 404.

## Prérequis

- Node.js **22**, version précise dans `.node-version` et `.nvmrc`.
- npm 10 (version indiquée dans `packageManager`).
- Docker Desktop démarré, avec le moteur Linux.
- Ports locaux 3000 (application) et 5432 (PostgreSQL) disponibles.

### Windows PowerShell

Depuis la racine du projet, activer Node.js pour le terminal courant :

```powershell
. .\scripts\dev-shell.ps1
```

Le script télécharge si nécessaire la version Windows x64 officielle de Node.js, vérifie son SHA-256 et la conserve dans `%LOCALAPPDATA%\mdd-dev\node`. Il adapte le `PATH` de ce terminal. Relancer cette commande dans chaque nouveau terminal du projet.

Sur les autres systèmes, utiliser son gestionnaire de versions Node.js avec `.nvmrc` ou `.node-version`.

## Installation et lancement

```bash
npm ci
npm run setup:env
npm run db:up
npm run dev
```

Ouvrir [http://localhost:3000](http://localhost:3000).

`setup:env` crée `.env` à partir de `.env.example`, avec un mot de passe PostgreSQL et un secret d'authentification aléatoires. Il conserve un `.env` déjà présent. Ce fichier est ignoré par Git. Le secret est préparé pour la future authentification ; celle-ci n'est pas encore installée.

PostgreSQL 17 est accessible uniquement sur l'interface locale, avec un volume Docker persistant. Les identifiants et le port sont dans `.env`. Après création du volume, modifier `POSTGRES_PASSWORD` dans `.env` ne modifie pas le mot de passe déjà enregistré dans PostgreSQL.

## Commandes

| Commande | Usage |
| --- | --- |
| `npm run dev` | Serveur Next.js avec rechargement automatique |
| `npm run check` | ESLint et vérification TypeScript |
| `npm run build` | Compilation de production |
| `npm start` | Serveur de production après compilation |
| `npm run db:up` | Démarrer PostgreSQL et attendre qu'il soit prêt |
| `npm run db:status` | État du conteneur |
| `npm run db:down` | Arrêter PostgreSQL en conservant les données |
| `npm run db:generate` | Générer le client Prisma après ajout des modèles |
| `npm run db:migrate -- --name nom_migration` | Créer et appliquer une migration de développement |
| `npm run db:studio` | Explorer les données après ajout des modèles |

Le schéma Prisma du starter est vide. Le client Prisma et les tables métier seront créés lors de la définition des premiers modèles. Les migrations seront versionnées dans `prisma/migrations/`.

## Stack et organisation

- Next.js 16 App Router, React 19 et TypeScript.
- Tailwind CSS 4 et shadcn/ui.
- PostgreSQL 17, Prisma 6 et Zod 4.
- `app/` : pages et layouts Next.js.
- `lib/` : utilitaires partagés.
- `prisma/` : schéma et futures migrations.
- `scripts/` : configuration locale.
- `compose.yaml` : service PostgreSQL de développement.

Les futurs composants client et traitements serveur seront organisés dans ce même dépôt. Les frontières serveur/client et la sécurisation des accès seront définies pendant l'implémentation.

## Audit des dépendances

Audit du 13 novembre 2026 : les mises à jour de Next.js, React, Prisma, Zod et des dépendances compatibles ramènent le total de 34 à 18 alertes, sans alerte critique. Il reste 1 alerte faible, 11 modérées et 6 élevées, notamment dans les dépendances des outils Prisma, shadcn et ESLint. `npm audit --omit=dev` signale également la chaîne Prisma/config/deepmerge-ts, car Prisma est une dépendance pair du client.

Ces alertes restent à traiter. Les corrections proposées impliquant des changements majeurs ou une rétrogradation des outils n'ont pas été appliquées automatiquement. Relancer `npm audit` pour consulter l'état courant.

## Références

- [Next.js](https://nextjs.org/docs)
- [Prisma](https://www.prisma.io/docs)
- [shadcn/ui](https://ui.shadcn.com)
- [TypeScript](https://www.typescriptlang.org/docs)
