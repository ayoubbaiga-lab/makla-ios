# HANDOFF MAC — Publier Makla sur TestFlight via Mac M5

> **À Claude Code sur le Mac d'Ayoub** : Lis ce fichier en entier puis execute toutes les etapes
> de facon autonome. Demande l'aide d'Ayoub UNIQUEMENT pour les actions qui necessitent son
> iPhone, son mot de passe Apple ID, ou un clic dans Xcode. Sinon fais le travail tout seul.

## Contexte

- **Projet** : Makla, app de cuisine de quartier (Mantes-la-Jolie)
- **App web live** : https://maklaeat-store.vercel.app (deja fonctionne, mais on veut aussi App Store)
- **User** : Ayoub Baiga, email `ayoub.baiga@hotmail.com`
- **Mac** : Mac M5 tout neuf, macOS recent

## Donnees Apple (Apple Developer paye et configure)

| Champ | Valeur |
|---|---|
| Apple ID | ayoub.baiga@hotmail.com |
| Team ID | TMGTQKGVFJ |
| Team Name | ayoub baiga |
| Bundle ID | com.makla.app (deja cree sur developer.apple.com) |
| App Store Connect App ID | 6777566399 |
| App Store Connect App Name | Maklaeat |
| API Key Issuer ID | 2c8b5515-524d-459e-872b-b2eceb66189e |
| API Key ID | VTJTP9HYJD |
| API Key fichier | `~/Downloads/AuthKey_VTJTP9HYJD.p8` (transfere manuellement depuis le PC Windows d'Ayoub) |

## DSA Trader status : DEJA FAIT (sur App Store Connect)

## Tentatives precedentes (Codemagic cloud) — ECHEC

6 builds Codemagic ont echoue sur la signature iOS. Le repo a un `codemagic.yaml`
mais on l'IGNORE — on va builder localement sur ce Mac et uploader vers TestFlight via Xcode.

## ETAPES A EXECUTER

### 1. Verifier que le user a transfere le .p8

```bash
ls -la ~/Downloads/AuthKey_VTJTP9HYJD.p8
```

Si le fichier n'existe pas, demande a Ayoub :

> "J'ai besoin que tu transferes le fichier `AuthKey_VTJTP9HYJD.p8` depuis ton PC Windows
> vers ce Mac. Sur le PC, il est dans :
> `C:\Users\ayoub\maklaeat-store\_apple_keys_BACKUP_NE_PAS_PARTAGER\AuthKey_VTJTP9HYJD.p8`
>
> Methodes :
> - **AirDrop** depuis ton iPhone si tu peux d'abord le mettre sur iCloud Drive
> - **Email** a toi-meme
> - **Cle USB**
>
> Une fois sur le Mac, depose-le dans ~/Downloads/. Dis-moi quand c'est fait."

Sinon → continue.

### 2. Verifier Xcode

```bash
xcodebuild -version
```

Si Xcode pas installe → dis a Ayoub d'installer Xcode via l'App Store
(`open -a "App Store"` puis recherche "Xcode" → bouton Obtenir).
Xcode pese 10-15 GB, telechargement 20-40 min. **Attends sa confirmation avant de continuer.**

Si Xcode installe → continue.

### 3. Xcode Command Line Tools

```bash
xcode-select --install 2>&1 || true
xcode-select -p  # doit afficher /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -license accept 2>&1 || true
```

### 4. Installer Homebrew si absent + Node + CocoaPods

```bash
# Homebrew
if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Node 20
brew install node@20 || brew upgrade node@20
echo 'export PATH="/opt/homebrew/opt/node@20/bin:$PATH"' >> ~/.zshrc
export PATH="/opt/homebrew/opt/node@20/bin:$PATH"
node -v  # doit afficher v20.x

# CocoaPods
sudo gem install cocoapods || brew install cocoapods
pod --version
```

### 5. Cloner le repo (si pas deja fait)

```bash
cd ~
if [ ! -d makla-ios ]; then
  git clone https://github.com/ayoubbaiga-lab/makla-ios.git
fi
cd makla-ios
git pull origin main
```

### 6. Installer npm deps + Capacitor iOS

```bash
npm install
if [ ! -d ios ]; then
  npx cap add ios
fi
npx cap sync ios
npx capacitor-assets generate --ios || true
cd ios/App && pod install && cd ../..
```

### 7. Mettre le team ID dans le projet Xcode

Le projet est genere par Capacitor sans team. On le configure en automatique :

```bash
cd ios/App

# Force automatic code signing avec notre team
/usr/libexec/PlistBuddy -c "Set :objects:CDA269D72243F8240008B97F:buildSettings:DEVELOPMENT_TEAM TMGTQKGVFJ" App.xcodeproj/project.pbxproj 2>/dev/null || true

# Methode alternative : sed sur le pbxproj
sed -i '' 's|DEVELOPMENT_TEAM = "";|DEVELOPMENT_TEAM = TMGTQKGVFJ;|g' App.xcodeproj/project.pbxproj
sed -i '' 's|DEVELOPMENT_TEAM = ;|DEVELOPMENT_TEAM = TMGTQKGVFJ;|g' App.xcodeproj/project.pbxproj

# Si DEVELOPMENT_TEAM n'existe pas du tout, on ajoute aux build settings :
grep -q "DEVELOPMENT_TEAM" App.xcodeproj/project.pbxproj || \
  sed -i '' '/CODE_SIGN_STYLE = Automatic;/a\
				DEVELOPMENT_TEAM = TMGTQKGVFJ;' App.xcodeproj/project.pbxproj

cd ../..
```

### 8. Build + Archive en ligne de commande

```bash
cd ios/App

# Auto-increment build number
agvtool new-version -all $(($(date +%s) / 60))

# Archive avec automatic signing + allowProvisioningUpdates
xcodebuild \
  -workspace App.xcworkspace \
  -scheme App \
  -configuration Release \
  -archivePath ~/makla-ios/build/App.xcarchive \
  -allowProvisioningUpdates \
  -authenticationKeyIssuerID "2c8b5515-524d-459e-872b-b2eceb66189e" \
  -authenticationKeyID "VTJTP9HYJD" \
  -authenticationKeyPath ~/Downloads/AuthKey_VTJTP9HYJD.p8 \
  CODE_SIGN_STYLE=Automatic \
  DEVELOPMENT_TEAM=TMGTQKGVFJ \
  clean archive

cd ../..
```

Si ca echoue : LIS l'erreur, corrige (ex: nettoyer DerivedData, accepter Xcode license, etc.),
et reessaye. Ne donne PAS la main a Ayoub avant d'avoir essaye 2-3 fixes evidents.

### 9. Export .ipa

```bash
mkdir -p ~/makla-ios/build/ipa

# Cree l'exportOptions.plist
cat > ~/makla-ios/build/exportOptions.plist <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>method</key>
  <string>app-store-connect</string>
  <key>teamID</key>
  <string>TMGTQKGVFJ</string>
  <key>uploadBitcode</key>
  <false/>
  <key>uploadSymbols</key>
  <true/>
  <key>signingStyle</key>
  <string>automatic</string>
  <key>destination</key>
  <string>upload</string>
</dict>
</plist>
EOF

xcodebuild \
  -exportArchive \
  -archivePath ~/makla-ios/build/App.xcarchive \
  -exportPath ~/makla-ios/build/ipa \
  -exportOptionsPlist ~/makla-ios/build/exportOptions.plist \
  -allowProvisioningUpdates \
  -authenticationKeyIssuerID "2c8b5515-524d-459e-872b-b2eceb66189e" \
  -authenticationKeyID "VTJTP9HYJD" \
  -authenticationKeyPath ~/Downloads/AuthKey_VTJTP9HYJD.p8
```

Avec `destination = upload`, ca uploadera directement vers App Store Connect.

### 10. Verification

```bash
ls -la ~/makla-ios/build/ipa/
```

Si un .ipa est genere → l'upload est en cours / fait.

Va sur https://appstoreconnect.apple.com/apps/6777566399 → TestFlight → tu dois voir le build
"Processing" (5-20 min) puis "Ready to Test".

Dis a Ayoub :

> "C'EST UPLOADE ! 🎉
> Va sur App Store Connect (https://appstoreconnect.apple.com) → ton app Maklaeat → onglet TestFlight.
> Tu dois voir le build en 'Processing' pendant 5-20 minutes.
> Quand il passe en 'Ready to Test', tu vas recevoir un email automatique.
>
> Pour tester :
> 1. Installe l'app TestFlight sur ton iPhone (App Store > recherche 'TestFlight')
> 2. Ouvre l'email Apple → bouton 'View in TestFlight'
> 3. Bouton 'Installer' → Makla apparait sur ton iPhone"

## Si quelque chose echoue de facon critique

Reporte a Ayoub avec :
- L'etape exacte
- Le message d'erreur complet
- 2-3 hypotheses sur la cause
- Ce que tu as deja essaye

Ne le laisse JAMAIS dans le flou. Sois explicite.

## Recap final attendu

Une fois TestFlight live :
- Ayoub peut installer Makla sur son iPhone
- Apres tests, il pourra soumettre a la review App Store publique (depuis App Store Connect, bouton "Submit for Review")
- Review Apple : 1 a 7 jours
- Apres review : Makla disponible dans l'App Store publique
