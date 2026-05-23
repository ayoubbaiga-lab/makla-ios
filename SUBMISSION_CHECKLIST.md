# SUBMISSION_CHECKLIST — Makla iOS → App Store

Checklist complète, de la validation Apple jusqu'à la mise en ligne.
Coche au fur et à mesure.

---

## Phase 0 — Préparation repo (FAIT par l'audit)
- [x] Aucun fichier sensible commité
- [x] capacitor.config.json conforme (com.makla.app / Makla / www)
- [x] codemagic.yaml corrigé (groupe fantôme retiré, Xcode 16.2 figé)
- [x] Icône 1024 sans canal alpha
- [x] Screenshots regénérés en 1290×2796 (iPhone 6.9")
- [x] STORE_LISTING.md complet + message anti-4.2 renforcé
- [x] privacy.html : base légale + durées de conservation ajoutées
- [ ] **Committer + pusher ces corrections sur GitHub** (attendre ton OK)

## Phase 1 — Validation Apple Developer
- [ ] Email Apple "Welcome to the Apple Developer Program" reçu (vérif pièce d'identité OK, ~2 jours)
- [ ] Connexion possible à https://appstoreconnect.apple.com

## Phase 2 — Bundle ID
- [ ] https://developer.apple.com/account/resources/identifiers → (+) → App IDs → App
- [ ] Description : `Makla` · Bundle ID **Explicit** = `com.makla.app`
- [ ] Capabilities : laisser par défaut (Push Notifications si on veut les notifs natives plus tard)
- [ ] Register

## Phase 3 — Créer l'app dans App Store Connect
- [ ] https://appstoreconnect.apple.com/apps → (+) → Nouvelle app
- [ ] Plateforme iOS · Nom **Makla** · Langue **Français (France)** · Bundle ID **com.makla.app** · SKU **makla-001** · Accès complet
- [ ] Créer
- [ ] Aller dans **App Information** → copier l'**Apple ID numérique** (ex : 6480000000)

## Phase 4 — Brancher Codemagic au build
- [ ] Remplacer `APP_STORE_APP_ID: 0000000000` par l'Apple ID numérique dans `codemagic.yaml` (je peux le faire et pusher dès que tu me donnes le numéro)
- [ ] https://codemagic.io → Sign up with GitHub
- [ ] Add application → repo **makla-ios** (autoriser l'accès au repo privé)
- [ ] Teams → Integrations → **App Store Connect** → Connect :
  - [ ] Uploader le fichier **.p8**
  - [ ] Coller **Key ID** + **Issuer ID**
  - [ ] Nommer l'intégration EXACTEMENT **`makla_api_key`**

## Phase 5 — Lancer le build
- [ ] Codemagic → Start new build → workflow **"Makla iOS — App Store"**
- [ ] Build vert (~15-20 min). Si rouge → copier le log et demander de l'aide.
- [ ] Vérifier l'arrivée du build dans **App Store Connect → TestFlight** (statut "Processing" puis "Ready to Submit")

## Phase 6 — Tester (TestFlight, gratuit)
- [ ] Installer **TestFlight** sur l'iPhone
- [ ] S'ajouter comme testeur interne → installer Makla → tester les 2 parcours (client + cuisiniez)
- [ ] Vérifier : plus de fausse barre "5G/9:41", navigation OK, pas de cul-de-sac

## Phase 7 — Remplir la fiche App Store
- [ ] **Description / Sous-titre / Mots-clés / Texte promo** → copier depuis `STORE_LISTING.md`
- [ ] **Captures** → uploader les 6 de `store-screenshots/` (1290×2796)
- [ ] **Catégorie** : Food & Drink (secondaire : Lifestyle)
- [ ] **URL Support / Marketing** : https://maklaeat-store.vercel.app
- [ ] **URL Confidentialité** : https://maklaeat-store.vercel.app/privacy.html
- [ ] **App Privacy** (questionnaire) : aucune donnée liée à l'identité ; si géoloc activée → "Localisation, usage app, non liée à l'identité, pas de tracking"
- [ ] **App Review Information → Notes** → coller le message reviewers (anti-4.2) de `STORE_LISTING.md`
- [ ] **Sign-in required ?** → Non (aucun identifiant requis)
- [ ] Prix : **Gratuit**

## Phase 8 — Soumettre
- [ ] Sélectionner le build TestFlight
- [ ] **Ajouter pour examen** → **Soumettre**
- [ ] Statut : "Waiting for Review" → review Apple 24-48h
- [ ] Email "Ready for Sale" 🎉

---

## Plan B — En cas de refus

### Refus 4.2 (Minimum Functionality)
- Répondre dans le Resolution Center en réutilisant l'argumentaire (push, géoloc, offline, 2 parcours, usage local quotidien).
- Si insuffisant : enrichir une vraie fonction native (ex : notifications push réelles via APNs, ou partage natif), rebuild, re-soumettre.

### Refus 5.1.1 (Data Collection / Privacy)
- Vérifier que le questionnaire App Privacy correspond exactement à la privacy policy.
- S'assurer que la demande de géolocalisation a bien un texte d'usage clair (NSLocationWhenInUseUsageDescription) — à ajouter dans Info.plist si on active la géoloc.

### Refus 2.1 (Performance / App Complete)
- Souvent : l'app n'a pas chargé (besoin réseau au 1er lancement). Action : embarquer React/Babel en local dans `www/` pour un fonctionnement 100% hors-ligne dès l'install (me demander, je le fais).
- Fournir des identifiants de démo si jamais un login était ajouté (ici : aucun login, donc préciser "no account needed").

### Refus 4.3 (Spam / Design minimal)
- Peu probable (design éditorial original). Si évoqué : mettre en avant l'identité visuelle unique et la valeur locale.
