# Makla — Projet iOS (App Store sans Mac)

Ce dossier est un projet **Capacitor** prêt à builder sur l'App Store via **Codemagic** (cloud, aucun Mac requis).

L'app charge l'interface depuis le dossier `www/` (embarquée dans l'app = fonctionne hors-ligne, meilleur pour la validation Apple).

---

## ✅ Ce qui est déjà fait
- Code de l'app dans `www/` (Makla, direction Édition, sans fausse barre de statut)
- `capacitor.config.json` configuré (appId `com.makla.app`, nom "Makla")
- `codemagic.yaml` (build cloud + envoi App Store Connect)
- Icône source `resources/icon.png` (1024px) + `resources/splash.png`
- Toutes les tailles d'icônes dans `www/icons/`

---

## ÉTAPE 1 — Pousser sur GitHub

Installe Git si besoin (https://git-scm.com), puis dans ce dossier :

```bash
cd makla-ios
git init
git add .
git commit -m "Makla iOS — projet initial"
git branch -M main
```

Crée un repo vide sur https://github.com/new (nom: `makla-ios`, privé), puis :

```bash
git remote add origin https://github.com/TON_PSEUDO/makla-ios.git
git push -u origin main
```

---

## ÉTAPE 2 — Clé API App Store Connect (5 min)

1. https://appstoreconnect.apple.com → **Users and Access → Integrations → App Store Connect API**
2. Clique **(+)**, rôle **App Manager**, nomme-la "Codemagic"
3. Télécharge le fichier **`.p8`** (téléchargeable UNE seule fois !)
4. Note le **Key ID** et l'**Issuer ID** (affichés sur la page)

---

## ÉTAPE 3 — Créer l'app dans App Store Connect

1. **Mes apps → (+) → Nouvelle app**
2. Plateforme: iOS · Nom: **Makla** · Langue: Français · Bundle ID: **com.makla.app**
   (si le Bundle ID n'existe pas, crée-le sur https://developer.apple.com/account/resources/identifiers)
3. SKU: `makla-001`
4. Une fois créée, note l'**Apple ID** numérique de l'app (ex: 6480000000) → à mettre dans `codemagic.yaml` (champ `APP_STORE_APP_ID`)

---

## ÉTAPE 4 — Codemagic (build cloud)

1. https://codemagic.io → inscris-toi (gratuit, 500 min/mois)
2. **Add application** → connecte ton GitHub → choisis `makla-ios`
3. Codemagic détecte le `codemagic.yaml` automatiquement
4. **Teams → Integrations → App Store Connect → Connect** :
   - uploade ton fichier `.p8`
   - colle **Key ID** + **Issuer ID**
   - nomme l'intégration **`makla_api_key`** (doit correspondre au yaml)
5. Dans `codemagic.yaml`, remplace `APP_STORE_APP_ID: 0000000000` par l'Apple ID numérique de l'étape 3, commit/push.
6. Clique **Start new build** → workflow **"Makla iOS — App Store"**
7. ~15-20 min plus tard, le build apparaît dans **App Store Connect → TestFlight**

---

## ÉTAPE 5 — Tester puis soumettre

1. **TestFlight** : installe l'app sur ton iPhone pour tester en vrai (gratuit)
2. Quand tu es satisfait → App Store Connect → ton app :
   - Ajoute les **captures** (dans `www/screenshots/`)
   - Colle la **fiche** (voir `STORE_LISTING.md`)
   - Ajoute le **message aux reviewers** (voir `STORE_LISTING.md`)
   - URL privacy: `https://maklaeat-store.vercel.app/privacy.html`
3. Sélectionne le build → **Soumettre pour examen**
4. Validation Apple: 24-48h

---

## Notes
- Le dossier `ios/` n'est pas versionné : Codemagic le génère via `npx cap add ios` à chaque build.
- Pour mettre à jour l'app plus tard : modifie `www/index.html`, commit/push, relance un build Codemagic.
- Tu peux aussi garder `www/` synchronisé avec https://maklaeat-store.vercel.app (même code).

Besoin d'aide sur une étape ? Reviens me voir avec le message d'erreur exact.
