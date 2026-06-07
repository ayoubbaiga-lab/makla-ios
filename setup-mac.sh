#!/bin/bash
# Setup automatique Makla iOS sur Mac
# Usage: curl -fsSL https://raw.githubusercontent.com/ayoubbaiga-lab/makla-ios/main/setup-mac.sh | bash

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

say() { echo -e "${BLUE}==>${NC} $1"; }
ok()  { echo -e "${GREEN}✓${NC} $1"; }
warn(){ echo -e "${YELLOW}!${NC} $1"; }
err() { echo -e "${RED}✗${NC} $1"; }

say "🍎 Setup Makla iOS sur Mac"

# 1. Verifier Xcode
if ! command -v xcodebuild >/dev/null 2>&1 || ! xcodebuild -version >/dev/null 2>&1; then
  err "Xcode n'est pas installé."
  warn "Ouvre l'App Store, cherche 'Xcode', clique Obtenir, attends que ça finisse (~30 min), puis relance ce script."
  open -a "App Store" 2>/dev/null || true
  exit 1
fi
ok "Xcode installé : $(xcodebuild -version | head -1)"

# Accept license
sudo xcodebuild -license accept 2>/dev/null || true

# 2. Verifier le .p8
if [ ! -f ~/Downloads/AuthKey_VTJTP9HYJD.p8 ]; then
  err "Le fichier AuthKey_VTJTP9HYJD.p8 n'est pas dans ~/Downloads."
  warn "Envoie-toi le fichier depuis ton PC (par mail ou OneDrive) et mets-le dans ~/Downloads, puis relance ce script."
  warn "Sur le PC il est dans : C:\\Users\\ayoub\\maklaeat-store\\_apple_keys_BACKUP_NE_PAS_PARTAGER\\AuthKey_VTJTP9HYJD.p8"
  exit 1
fi
ok ".p8 trouvé : ~/Downloads/AuthKey_VTJTP9HYJD.p8"

# 3. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  say "Installation de Homebrew (gestionnaire de paquets Mac)..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Add brew to PATH (M1/M2/M5)
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi
ok "Homebrew : $(brew --version | head -1)"

# 4. Node 20 (node@20 est keg-only, on force le PATH explicite)
if ! brew list node@20 >/dev/null 2>&1; then
  say "Installation de Node.js 20..."
  brew install node@20
fi
# Force le PATH vers node@20 (keg-only ne se link pas automatiquement)
export PATH="/opt/homebrew/opt/node@20/bin:$PATH"
# Persiste dans .zprofile pour les sessions futures
grep -q 'node@20/bin' ~/.zprofile 2>/dev/null || echo 'export PATH="/opt/homebrew/opt/node@20/bin:$PATH"' >> ~/.zprofile
if ! command -v node >/dev/null 2>&1; then
  err "Node n'est pas trouvable dans le PATH apres installation. Verifier /opt/homebrew/opt/node@20/bin/node"
  exit 1
fi
ok "Node : $(node -v)"

# 5. CocoaPods
if ! command -v pod >/dev/null 2>&1; then
  say "Installation de CocoaPods..."
  brew install cocoapods
fi
ok "CocoaPods : $(pod --version)"

# 6. Cloner ou mettre à jour le repo
cd ~
if [ ! -d makla-ios ]; then
  say "Clone du repo makla-ios..."
  git clone https://github.com/ayoubbaiga-lab/makla-ios.git
fi
cd makla-ios
git pull origin main
ok "Repo a jour"

# 7. npm install + Capacitor iOS
say "Installation des dépendances npm..."
npm install

say "Génération du projet iOS Capacitor..."
if [ ! -d ios ]; then
  npx cap add ios
fi
npx cap sync ios

say "Génération des icônes et splash..."
npx capacitor-assets generate --ios 2>/dev/null || true

say "Installation des Pods iOS..."
cd ios/App
pod install
cd ../..

# 8. Configurer le Team ID
say "Configuration du Team ID dans le projet Xcode..."
cd ios/App
sed -i '' 's|DEVELOPMENT_TEAM = "";|DEVELOPMENT_TEAM = TMGTQKGVFJ;|g' App.xcodeproj/project.pbxproj
sed -i '' 's|DEVELOPMENT_TEAM = ;|DEVELOPMENT_TEAM = TMGTQKGVFJ;|g' App.xcodeproj/project.pbxproj
cd ../..
ok "Team ID configuré : TMGTQKGVFJ"

# 9. Build number
cd ios/App
agvtool new-version -all $(($(date +%s) / 60)) >/dev/null 2>&1 || true
cd ../..

# 10. Build + Archive
say "🔨 Compilation + signature + archive (5-15 min)..."
mkdir -p ~/makla-ios/build

xcodebuild \
  -workspace ios/App/App.xcworkspace \
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

ok "Archive créée"

# 11. Export + upload TestFlight
say "📤 Upload vers TestFlight..."
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

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}🎉 MAKLA EST SUR TESTFLIGHT !${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Va sur : https://appstoreconnect.apple.com/apps/6777566399/testflight"
echo "Tu vas voir le build en 'Processing' pendant 5-20 min."
echo ""
echo "Sur ton iPhone :"
echo "  1. Installe l'app TestFlight depuis l'App Store si pas déjà fait"
echo "  2. Attends l'email Apple (~15 min)"
echo "  3. Clique le bouton dans l'email → 'Install' → Makla apparaît"
echo ""
