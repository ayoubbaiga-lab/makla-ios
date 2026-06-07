# 📋 État actuel — Reprends ici Claude

> **À Claude Code sur le Mac d'Ayoub** : lis ce fichier ET HANDOFF_MAC.md, puis
> termine le boulot. Ayoub est ÉPUISÉ par 6h de galère, ne lui pose AUCUNE
> question inutile. Fais le maximum en autonome.

## Le problème en 1 ligne

Compiler + uploader l'app iOS "Makla" sur TestFlight, depuis ce Mac M5 (Xcode déjà installé).

## État ACTUEL (n'oublie aucun détail)

### Ce qui est FAIT
- ✅ Xcode 26.5 installé sur ce Mac
- ✅ Homebrew installé
- ✅ Node 20.20.2 installé (mais keg-only, PATH à forcer)
- ✅ CocoaPods 1.16.2 installé
- ✅ Repo cloné dans `~/makla-ios`
- ✅ `npm install` fait
- ✅ Projet Capacitor iOS généré dans `~/makla-ios/ios/App/`
- ✅ Pods installés
- ✅ Team ID configuré dans Xcode project (TMGTQKGVFJ)
- ✅ Fichier `.p8` dans `~/Downloads/AuthKey_VTJTP9HYJD.p8`
- ✅ App déjà créée sur App Store Connect (ID 6777566399, Bundle ID `com.makla.app`)
- ✅ DSA Trader status validé

### Ce qui RESTE à faire
- ⏳ Build + Archive avec xcodebuild
- ⏳ Export .ipa et upload TestFlight

### Le script setup-mac.sh
- À l'URL : https://raw.githubusercontent.com/ayoubbaiga-lab/makla-ios/main/setup-mac.sh
- Il est idempotent — relance-le, il saute ce qui est fait, continue où il s'est arrêté

## Commande pour reprendre où on en est

```bash
cd ~/makla-ios && git pull && bash setup-mac.sh
```

C'est TOUT ce qu'il faut. Le script fait :
1. Verifie Xcode (déjà OK)
2. Verifie .p8 (déjà OK)
3. Skip Homebrew/Node/CocoaPods (déjà OK)
4. Re-sync Capacitor
5. Re-install Pods
6. Build + Archive + Upload vers TestFlight

## Credentials et IDs

| Champ | Valeur |
|---|---|
| Apple ID | ayoub.baiga@hotmail.com |
| Team ID | TMGTQKGVFJ |
| App Store Connect App ID | 6777566399 |
| App Store Connect App Name | Maklaeat |
| Bundle ID | com.makla.app |
| API Issuer ID | 2c8b5515-524d-459e-872b-b2eceb66189e |
| API Key ID | VTJTP9HYJD |
| .p8 file path | ~/Downloads/AuthKey_VTJTP9HYJD.p8 |
| GitHub repo | https://github.com/ayoubbaiga-lab/makla-ios (PUBLIC) |

## Si le build échoue

Lit le log Xcode exact (`/tmp/xcodebuild_logs/*.log`), identifie la cause, propose un fix.

**Erreurs déjà rencontrées et NON résolues sur Codemagic** :
- "App nécessite un profil de provisionnement"
- "Impossible d'enregistrer les certificats sans la clé privée"
- "No matching profiles found for bundle identifier"

**Hypothèse principale** : Apple a accumulé des Distribution certs sans clé privée
(max 2 par compte). Si le build échoue avec un message similaire sur le Mac,
il faut soit :
- (a) Aller sur developer.apple.com/account/resources/certificates/list,
  révoquer TOUS les certs IOS_DISTRIBUTION, puis relancer le script
- (b) Ou via la commande : `xcrun altool` ou Transporter app
  pour upload direct sans signature locale

## Ce qu'Ayoub veut vraiment

- Voir Makla dans TestFlight sur son iPhone
- Pouvoir installer Makla sur son iPhone via TestFlight
- Plus tard : la mettre sur l'App Store public (review Apple)

## URL utiles
- App web (déjà live) : https://maklaeat-store.vercel.app
- App Store Connect : https://appstoreconnect.apple.com/apps/6777566399
- Apple Developer certs : https://developer.apple.com/account/resources/certificates/list
- GitHub repo : https://github.com/ayoubbaiga-lab/makla-ios

## Le mot de la fin

Ayoub a passé sa journée à galérer avec Apple. Sois empathique mais EFFICACE.
Ne demande pas son avis sur chaque étape — décide et exécute.
