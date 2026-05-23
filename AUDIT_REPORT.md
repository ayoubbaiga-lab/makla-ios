# AUDIT_REPORT — Makla iOS (pré-soumission App Store)

> Audit réalisé sur le repo local `makla-ios` pendant la validation de l'adhésion Apple Developer.
> Objectif : repo 100% prêt pour build Codemagic + soumission dès qu'Apple valide.

---

## Résumé exécutif

| Section | Statut |
|---|---|
| 1. Inventaire / fichiers sensibles | ✅ OK (aucun secret commité) |
| 2. capacitor.config.json | ✅ OK |
| 3. codemagic.yaml | ✅ Corrigé (2 fixs appliqués) |
| 4. Icône 1024 | ✅ Corrigé (alpha retiré) |
| 5. Screenshots | ✅ Corrigé (regénérés en 1290×2796) |
| 6. STORE_LISTING.md | ✅ OK (message 4.2 renforcé) |
| 7. privacy.html | ✅ Corrigé (base légale + conservation ajoutées) |

**Verdict : le repo est prêt. Aucune action bloquante côté code.** Il ne reste que les étapes liées aux comptes (Apple + Codemagic), listées dans `SUBMISSION_CHECKLIST.md`.

---

## 1. Inventaire du repo

Arborescence (profondeur 3) :
```
makla-ios/
├── .gitignore
├── README.md
├── STORE_LISTING.md
├── AUDIT_REPORT.md            (ce fichier)
├── SUBMISSION_CHECKLIST.md
├── capacitor.config.json
├── codemagic.yaml
├── package.json
├── resources/
│   ├── icon.png               (1024×1024, sans alpha ✓)
│   └── splash.png
├── store-screenshots/         (6 × 1290×2796 ✓)
│   ├── home.png  menu.png  cart.png  confirmation.png  role.png  profile.png
└── www/
    ├── index.html  manifest.json  privacy.html  sw.js
    └── icons/  (48 → 1024 + maskable)
```
**Fichiers sensibles (.p8, .p12, .cer, .env, .keystore) : AUCUN.** ✅
Le dossier natif `ios/` est volontairement ignoré (régénéré par Codemagic via `npx cap add ios`).

## 2. capacitor.config.json — ✅ OK
- `appId` = `com.makla.app` ✓
- `appName` = `Makla` ✓
- `webDir` = `www` ✓
- Aucun placeholder `io.ionic.starter` ✓
- `bundledWebRuntime` : absent → correct pour Capacitor 6 (champ déprécié).
- StatusBar `overlaysWebView: true` + safe-area gérée dans l'app ✓

## 3. codemagic.yaml — ✅ Corrigé
**Problèmes trouvés et corrigés :**
1. ❌→✅ `groups: - app_store_credentials` référençait un groupe de variables **inexistant** → aurait fait échouer le build. **Supprimé** (l'auth passe par l'intégration `makla_api_key`, suffisant).
2. ❌→✅ `xcode: latest` (non reproductible, risque de casse) → **figé à `16.2`**. `cocoapods` figé à `1.15.2`.

**Conforme :**
- Bundle ID `com.makla.app` partout ✓
- `integrations: app_store_connect: makla_api_key` (nom EXACT) ✓
- `APP_STORE_APP_ID: 0000000000` présent (à remplacer après création de l'app) ✓
- `submit_to_testflight: true` + `submit_to_app_store: false` ✓
- `auth: integration` (provisioning auto via clé API, aucun cert manuel) ✓
- `node: 20.11.0` figé ✓
- Aucune clé .p8 / Key ID / Issuer ID en dur ✓

## 4. Icône — ✅ Corrigé
- `icon-1024.png` et `resources/icon.png` : **1024×1024**.
- ❌→✅ Le PNG contenait un **canal alpha** (Apple refuse les icônes avec transparence) → **aplati sur fond opaque + alpha retiré**.
- L'icône remplit tout le carré (pas de coins arrondis manuels — Apple les applique lui-même) ✓
- Le set complet d'icônes sera régénéré par `capacitor-assets` pendant le build à partir de `resources/icon.png`.

## 5. Screenshots — ✅ Corrigé
- ❌→✅ Étaient en **1170×2532** (iPhone 6.1"). Apple impose désormais le **6.9" (1290×2796)** comme taille obligatoire.
- **Regénérés en 1290×2796** (ratio quasi identique, aucune déformation visible) : home, menu, cart, confirmation, role, profile.
- ⚠️ Recommandé (non bloquant) : ajouter aussi un set 6.5" (1242×2688) pour couvrir les anciens iPhone. Pas obligatoire si le 6.9" est fourni.

## 6. STORE_LISTING.md — ✅ OK
- Nom : "Makla" (5 car. ≤ 30) ✓
- Sous-titre : "Cuisine de quartier maison" (26 car. ≤ 30) ✓
- Mots-clés : 93 car. ≤ 100 ✓ (sans espace après virgule ✓)
- Description : ~1 100 car. ≤ 4000 ✓, pas de promesse médicale, pas de nom de concurrent ✓
- ⚠️ Note : la mention "3 mois gratuits" décrit le **modèle de service** (pas le prix de l'app) → acceptable. Conseil : garder ce type de claim surtout dans le champ **Texte promotionnel** (modifiable sans review).
- URLs support / marketing / privacy présentes ✓ (privacy → https://maklaeat-store.vercel.app/privacy.html)
- Message reviewers : **renforcé** avec argumentaire anti-4.2 (push, géoloc, offline, 2 parcours) ✓

## 7. privacy.html — ✅ Corrigé
Sections présentes : responsable du traitement + email, données collectées, finalités, géolocalisation, notifications, droits RGPD, données cuisiniez, contact, date de MAJ.
- ❌→✅ Ajout **base légale** (contrat / consentement) par type de donnée.
- ❌→✅ Ajout **durée de conservation** (commande + 12 mois, puis suppression).
- ❌→✅ Ajout droits portabilité / limitation / opposition + mention CNIL.
- Version en ligne à vérifier identique : https://maklaeat-store.vercel.app/privacy.html (re-déployer si besoin).

---

## Actions AVANT build
- [ ] Adhésion Apple validée (en cours)
- [ ] Re-déployer le site Vercel si on veut la privacy mise à jour en ligne (le repo iOS embarque déjà la version corrigée dans `www/privacy.html`)
- [ ] (déjà fait) icône sans alpha, screenshots 1290×2796, codemagic.yaml corrigé — **à committer/pusher** (voir checklist)

## Actions AVANT soumission App Store
- [ ] App créée dans App Store Connect → récupérer Apple ID numérique → remplacer `APP_STORE_APP_ID`
- [ ] Intégration `makla_api_key` créée dans Codemagic
- [ ] Build Codemagic OK → présent dans TestFlight
- [ ] Fiche remplie (textes STORE_LISTING.md) + 6 captures 1290×2796 + message reviewers
- [ ] App Privacy renseignée dans App Store Connect (aucune donnée liée à l'identité)
