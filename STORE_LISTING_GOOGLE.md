# Fiche Google Play — Makla (copier-coller)

> Format Google Play Console. Android = priorité (cible familles/parents, majoritairement Android en France).
> Packaging via PWABuilder (TWA — Trusted Web Activity) à partir de https://maklaeat-store.vercel.app

---

## Nom de l'application (≤ 30 car.)
Makla

## Description courte (≤ 80 car.)
La cuisine de votre quartier, faite maison. Reservez, retirez, regalez-vous.

## Description complete (≤ 4000 car.)
Makla, c'est la cuisine de votre quartier, faite maison par vos voisins.

A deux rues de chez vous, quelqu'un prepare le meilleur couscous que vous n'avez jamais goute. Dans l'immeuble d'en face, une main experte roule des nems comme a Hanoi. Ces talents existent — Makla les revele.

Nous les appelons les cuisiniez : des passionnes qui transforment des recettes familiales en plats authentiques. Pas de restaurant, pas de chaine industrielle. Juste une cuisine, un savoir-faire, et l'envie de partager.

COMMENT CA MARCHE
• Parcourez le menu du jour, cuisine ce soir meme
• Reservez votre plat en quelques secondes
• Retirez-le chez le cuisiniez, payez en especes
• Regalez-vous

POUR LES FAMILLES PRESSEES
Plus besoin de choisir entre "bien manger" et "pas le temps de cuisiner". Makla vous fait gagner du temps tout en mangeant fait maison, prepare a quelques rues de chez vous.

CE QUI REND MAKLA DIFFERENT
• Cuisine artisanale, jamais industrielle
• Echelle locale : vous collectez chez le cuisiniez, a quelques pas
• Allergenes clairs, portions enfant, plats du jour
• Vous cuisinez aussi ? Ouvrez votre atelier et recevez les reservations de vos voisins

PHASE DE LANCEMENT
Pendant 3 mois, Makla est gratuit : aucune commission, aucun frais. Le paiement se fait en especes a la collecte. Le paiement en ligne arrivera prochainement.

Makla demarre a Mantes-la-Jolie. Cuisine par le voisinage. Servi a votre table.

## Catégorie
Application · Catégorie : Cuisine et boissons (Food & Drink)
Tags : repas faits maison, cuisine locale, traiteur de quartier

## Coordonnees
- Email developpeur : contact@makla.app
- Site web : https://maklaeat-store.vercel.app
- Politique de confidentialite (OBLIGATOIRE) : https://maklaeat-store.vercel.app/privacy.html

## Ressources graphiques (toutes prêtes dans store-screenshots/)
- Icone 512x512 : play-icon-512.png ✓
- Feature graphic 1024x500 : feature-graphic-1024x500.png ✓ (OBLIGATOIRE Play)
- Captures telephone (min 2) : home.png, menu.png, cart.png, role.png, profile.png, confirmation.png

## Classification du contenu (questionnaire IARC)
- Pas de violence, contenu sexuel, drogue, jeux d'argent
- Interactions sociales : non (pas de chat public en phase test)
- Resultat attendu : Tous publics / PEGI 3

## Section "Sécurité des données" (Data safety — OBLIGATOIRE)
- Collecte de données : Minimale
  • Localisation approximative : OPTIONNELLE, avec consentement, pour situer les cuisiniez proches — non partagee, non utilisee pour le suivi
  • Nom (prenom) : uniquement si reservation, transmis au cuisiniez pour preparer la commande
- Aucune donnee bancaire (paiement en especes)
- Pas de partage avec des tiers
- Données chiffrees en transit (HTTPS)
- L'utilisateur peut demander la suppression : oui (contact@makla.app)

## Public cible
- Tranche d'age : 18+ (commande de repas)
- Pays : France (lancement Mantes-la-Jolie)

═══════════════════════════════════════════════════════════
## ⚙️ ÉTAPE TECHNIQUE IMPORTANTE — assetlinks.json (TWA)
═══════════════════════════════════════════════════════════
Quand PWABuilder génère le package Android, il crée une app "TWA" (Trusted Web
Activity) qui affiche ta PWA en plein écran SANS barre d'adresse de navigateur.
Pour que Android FASSE CONFIANCE au site, il faut publier un fichier de
vérification sur le domaine :

  https://maklaeat-store.vercel.app/.well-known/assetlinks.json

PWABuilder te donnera le contenu exact (il contient l'empreinte SHA-256 de la
clé de signature). DÈS QUE TU AS CE CONTENU :
→ donne-le moi, je le déploie sur Vercel en 1 minute.

Sans ce fichier, l'app Android marchera mais affichera une barre d'adresse
(moins "natif"). Avec, c'est plein écran comme une vraie app.

═══════════════════════════════════════════════════════════
## PARCOURS DE SOUMISSION GOOGLE PLAY
═══════════════════════════════════════════════════════════
1. Créer un compte Google Play Console : https://play.google.com/console
   → frais uniques de 25 $ (à vie, pas par an)
2. Create app → Nom "Makla" · Français · App · Gratuite
3. PWABuilder : https://www.pwabuilder.com → entrer l'URL → Package For Stores → Android
   → Package ID : app.makla.twa  (ou com.makla.app)
   → Télécharger le .aab + le assetlinks.json
4. Me donner le assetlinks.json → je le déploie sur Vercel
5. Play Console → Production → Create release → uploader le .aab
6. Remplir la fiche (textes ci-dessus) + icône 512 + feature graphic + captures
7. Remplir "Data safety" + classification du contenu
8. Envoyer en révision → validation Google : 1 à 7 jours (souvent 1-2j)
