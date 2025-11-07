# Rapport de surveillance - Mur de soutènement

Ce dossier contient tous les fichiers nécessaires pour générer un rapport complet de surveillance d'un mur de soutènement, incluant des graphiques R et des calculs de stabilité selon les Eurocodes.

## 📋 Contenu du dossier

```
retaining_wall_report/
├── mur_soutenement.csv              # Données de mesures (24 mois, 35 points)
├── rapport_mur_soutenement.typ      # Document source Typst
├── plot_plan_view.R                 # Script R : vue en plan du mouvement
├── plot_timeseries.R                # Script R : séries temporelles
├── plot_elevation.R                 # Script R : élévation et zonage
├── generate_wall-report.ps1         # Script PowerShell de génération
├── README.md                        # Ce fichier
└── images/                          # Dossier des graphiques générés
    ├── plan_view_movement.png
    ├── timeseries_keypoints.png
    ├── elevation_wall_status.png
    ├── inclination_profile.png
    ├── statistiques_points_cles.csv
    ├── analyse_elevation.csv
    └── synthese_verifications.csv
```

## 🎯 Objectif

Ce projet génère un rapport technique professionnel (format PDF A4) documentant :
- Les mesures de déplacement d'un mur de soutènement sur 24 mois
- Des graphiques R de haute qualité illustrant l'évolution des déplacements
- Des calculs de vérification structurelle selon les Eurocodes EN 1997-1 et EN 1992-1-1
- Des recommandations d'action basées sur l'analyse

## 📄 Caractéristiques du PDF généré

Le rapport PDF est généré avec les spécifications suivantes :
- **Standard PDF** : PDF 2.0 (ISO 32000-2:2020)
- **Format** : A4 (210 × 297 mm)
- **Métadonnées** : Titre, auteur, date, et mots-clés intégrés
- **Accessibilité** : PDF tagué par défaut pour meilleure accessibilité
- **Qualité** : Images haute résolution (300 DPI) pour impression professionnelle

**Avantages du PDF 2.0** :
- Support des fonctionnalités modernes d'accessibilité
- Meilleure compatibilité avec les outils récents
- Structure améliorée pour les lecteurs d'écran
- Métadonnées enrichies pour indexation et recherche

**Mots-clés intégrés** : mur de soutènement, surveillance structurelle, Eurocode, EN 1997-1, EN 1992-1-1, géotechnique, béton armé, stabilité, calculs structurels, monitoring, déplacement, topographie, renforcement, tirants d'ancrage, recommandations, BET structure, Regrain

## 🛠️ Prérequis

### Logiciels requis

1. **R** (version 4.0 ou supérieure)
   - Téléchargement : https://cran.r-project.org/bin/windows/base/
   - Ajout au PATH : `C:\Program Files\R\R-x.x.x\bin`

2. **Typst** (version 0.14 ou supérieure)
   - Installation via winget (recommandé) :
     ```powershell
     winget install --id Typst.Typst
     ```
   - Ou via Scoop :
     ```powershell
     scoop install typst
     ```
   - Ou téléchargement manuel : https://github.com/typst/typst/releases
   - **Note** : Typst 0.14+ requis pour support du PDF 2.0

3. **PowerShell** (version 5.1 ou supérieure, inclus dans Windows 11)

### Packages R requis

Le script d'installation vérifie et installe automatiquement les packages suivants :
- `ggplot2` : création de graphiques
- `dplyr` : manipulation de données
- `tidyr` : restructuration de données
- `scales` : mise à l'échelle des graphiques

Installation manuelle si nécessaire :
```R
install.packages(c("ggplot2", "dplyr", "tidyr", "scales"))
```

### Police de caractères

Le document utilise la police **Atkinson Hyperlegible** pour une meilleure lisibilité.
- Téléchargement : https://brailleinstitute.org/freefont
- Installation : Copier les fichiers de police dans `C:\Windows\Fonts`

Si la police n'est pas installée, Typst utilisera une police de substitution.

## 🚀 Utilisation

### Méthode automatique (recommandée)

#### Option 1 : Script Batch (plus simple, pas de problème de permissions)

1. Double-cliquez sur `generate_wall-report.bat` dans l'Explorateur Windows

   OU depuis l'invite de commande :
   ```cmd
   cd "c:\Users\oturl\Documents\Work\Canopee\siteweb\support\canopee.org.github\PDFs\retaining_wall_report"
   generate_wall-report.bat
   ```

#### Option 2 : Script PowerShell (plus de fonctionnalités, détection automatique de R)

⚠️ **Important** : Si vous obtenez l'erreur "L'exécution de scripts est désactivée", c'est à cause de la politique d'exécution PowerShell.

**Solution rapide** - Exécuter avec bypass (recommandé, ne modifie rien) :
```powershell
cd "c:\Users\oturl\Documents\Work\Canopee\siteweb\support\canopee.org.github\PDFs\retaining_wall_report"
powershell -ExecutionPolicy Bypass -File .\generate_wall-report.ps1
```

**Solution permanente** - Modifier la politique d'exécution (nécessite les droits administrateur) :
```powershell
# Ouvrir PowerShell en tant qu'administrateur, puis :
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Ensuite, vous pouvez exécuter normalement :
.\generate_wall-report.ps1
```

**Avantages du script PowerShell** :
- Détecte automatiquement R même s'il n'est pas dans le PATH
- Cherche dans `C:\Program Files\R\R-x.x.x\bin\x64\`
- Propose d'installer automatiquement les packages R manquants
- Messages colorés plus lisibles

Les deux scripts (batch et PowerShell) vont :
- Vérifier les dépendances (R, Typst, packages R)
- Générer les graphiques R dans le dossier `images/`
- Compiler le document Typst en PDF
- Proposer d'ouvrir le PDF généré

### Méthode manuelle

#### Étape 1 : Générer les graphiques R

```powershell
Rscript plot_plan_view.R
Rscript plot_timeseries.R
Rscript plot_elevation.R
```

#### Étape 2 : Compiler le PDF Typst

```powershell
typst compile rapport_mur_soutenement.typ Rapport_Surveillance_Mur_Soutenement.pdf
```

## 📊 Description des fichiers

### Données

**`mur_soutenement.csv`**
- 840 mesures (24 mois × 35 points)
- Colonnes : `mois`, `distance_m`, `deplacement_mm`, `date`
- Mesures de déplacement perpendiculaire au sommet du mur

### Scripts R

**`plot_plan_view.R`**
- Génère une vue en plan du mouvement de la crête du mur
- Affiche les évolutions mensuelles avec valeurs min, max et moyenne
- Sortie : `images/plan_view_movement.png`

**`plot_timeseries.R`**
- Crée des séries temporelles aux 4 points clés (1, 14, 16, 35 m)
- Met en évidence les variations saisonnières
- Sorties :
  - `images/timeseries_keypoints.png`
  - `images/statistiques_points_cles.csv`

**`plot_elevation.R`**
- Génère une élévation du mur avec zonage (vert/orange/rouge)
- Calcule les inclinaisons et identifie les zones critiques
- Sorties :
  - `images/elevation_wall_status.png`
  - `images/inclination_profile.png`
  - `images/analyse_elevation.csv`

### Document Typst

**`rapport_mur_soutenement.typ`**
- Document source du rapport (format A4 portrait)
- Police : Atkinson Hyperlegible 11 pt
- Structure :
  1. Page de titre
  2. Tableau des révisions
  3. Sommaire
  4. Introduction
  5. Description du mur
  6. Méthodologie de surveillance
  7. Résultats des mesures (avec graphiques R)
  8. Analyse des données (calculs Eurocode)
  9. Conclusion et recommandations d'action
  10. Annexes

### Variables personnalisables

En haut du fichier `rapport_mur_soutenement.typ`, vous pouvez modifier :

**Équipe technique** :
- `auteur-nom`, `auteur-trigramme`, `auteur-signature` : Informations et signature de l'auteur
- `verificateur-nom`, `verificateur-trigramme`, `verificateur-signature` : Informations et signature du vérificateur
- `controleur-nom`, `controleur-trigramme`, `controleur-signature` : Informations et signature du contrôleur

**Client** :
- `client-nom` : Nom du client
- `client-contact` : Nom du contact principal
- `client-fonction` : Fonction du contact
- `client-adresse` : Adresse du client
- `client-email` : Email du client
- `client-tel` : Téléphone du client

**Projet** :
- `lieu-mur` : Localisation du mur
- `date-creation` : Date de création du rapport
- `titre-principal` : Titre du rapport
- `sous-titre` : Sous-titre du rapport

**Société émettrice (bureau d'études)** :
- `societe-nom` : Nom de la société (ex: "Regrain - Bureau d'études structure")
- `societe-adresse` : Adresse de la société
- `societe-email` : Email de la société
- `societe-tel` : Téléphone de la société
- `societe-logo` : Chemin vers le logo du bureau d'études (ex: "images/231115_logo-regrain_V3-trans.png")

**Client (maître d'ouvrage)** :
- `client-logo` : Chemin vers le logo du client (ex: "images/canopee_logo.jpg")

**Révision** :
- `revision-actuelle` : Version actuelle (ex: "B1")
- `texte-revision` : Description de la révision

**Notes importantes** :
- Les signatures s'affichent automatiquement si les fichiers PNG existent dans `images/`. Sinon, un emplacement "_Signature_" est affiché.
- La page de titre affiche deux logos côte à côte :
  - **À gauche** : Logo du bureau d'études (`societe-logo`) avec mention "Bureau d'études"
  - **À droite** : Logo du client (`client-logo`) avec mention "Maître d'ouvrage"
- Si un logo n'est pas défini, son espace est simplement vide (pas d'erreur)

## 📐 Calculs Eurocode

Le rapport inclut des vérifications structurelles complètes selon :
- **EN 1997-1** : Eurocode 7 - Calcul géotechnique
- **EN 1992-1-1** : Eurocode 2 - Calcul des structures en béton

Vérifications effectuées :
1. Poussée des terres (théorie de Rankine)
2. Charges permanentes (voile, semelle, remblai)
3. Coefficient de sécurité au renversement
4. Coefficient de sécurité au glissement
5. Capacité portante du sol
6. Excentricité de la charge
7. Basculement acceptable

Toutes les formules sont numérotées et détaillées dans le rapport.

## 🎨 Personnalisation

### Modifier les seuils d'alerte

Dans `plot_elevation.R`, lignes 97-98 :
```R
seuil_critique <- 0.5  # % (zone rouge)
seuil_acceptable <- 0.3  # % (zone orange)
```

### Changer les couleurs du rapport

Dans `rapport_mur_soutenement.typ`, lignes 53-71 :
```typst
#show heading.where(level: 1): it => [
  #set text(18pt, fill: rgb("#0066CC"), weight: "bold")  // Bleu pour H1
  ...
]
```

### Ajouter un logo

1. Placez l'image du logo dans le dossier `images/` (ex: `logo_canopee.png`)
2. Dans `rapport_mur_soutenement.typ`, ajoutez dans la page de titre :
   ```typst
   #image("images/logo_canopee.png", width: 30%)
   ```

## 🐛 Dépannage

### Erreur PowerShell : "L'exécution de scripts est désactivée"

Votre politique d'exécution PowerShell est en mode "Restricted". Deux solutions :

**Solution 1 - Utiliser le script Batch** (recommandé si vous ne voulez pas modifier les paramètres) :
```cmd
generate_wall-report.bat
```

**Solution 2 - Bypass ponctuel** :
```powershell
powershell -ExecutionPolicy Bypass -File .\generate_wall-report.ps1
```

**Solution 3 - Modifier la politique** (permanent, nécessite les droits admin) :
```powershell
# Ouvrir PowerShell en tant qu'administrateur
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Erreur "R n'est pas reconnu"

R n'est pas dans le PATH système :
1. Recherchez l'installation de R : `C:\Program Files\R\R-x.x.x\bin`
2. Ajoutez ce chemin au PATH système
3. Redémarrez PowerShell

### Erreur "typst n'est pas reconnu"

Typst n'est pas installé ou pas dans le PATH :
```powershell
winget install --id Typst.Typst
```

### Erreur "Package 'ggplot2' introuvable"

Installez les packages R manuellement :
```R
install.packages(c("ggplot2", "dplyr", "tidyr", "scales"))
```

### Images manquantes dans le PDF

Vérifiez que les scripts R ont bien été exécutés et que les images existent dans `images/` :
```powershell
ls images\*.png
```

### Police Atkinson Hyperlegible non trouvée

Le PDF sera généré avec une police de substitution. Pour utiliser la police correcte :
1. Téléchargez depuis https://brailleinstitute.org/freefont
2. Installez dans Windows (Clic droit > Installer)
3. Recompilez le PDF

## 📦 Export et partage

### Créer une archive ZIP

```powershell
Compress-Archive -Path .\* -DestinationPath ..\retaining_wall_report.zip
```

### Inclure uniquement les fichiers essentiels

```powershell
$files = @(
    "mur_soutenement.csv",
    "rapport_mur_soutenement.typ",
    "plot_*.R",
    "generate_wall-report.ps1",
    "README.md",
    "Rapport_Surveillance_Mur_Soutenement.pdf"
)
Compress-Archive -Path $files -DestinationPath ..\retaining_wall_report.zip
```

## 📝 Versions

- **A0** (21 oct 2025) : Édition initiale
- **A1** (12 nov 2025) : Modification graphiques R
- **A2** (18 nov 2025) : Ajout contre-calcul Eurocodes
- **B0** (22 nov 2025) : Restructuration du document
- **B1** (26 nov 2025) : Ajout recommandations de surveillance *(version actuelle)*

## 👥 Auteurs

- **OLT** (Olivier LATURNUS) - Auteur
- **BCT** (Bernard COTTIN) - Vérificateur
- **ACB** (Anne-Claire BERNARD) - Contrôleur

## 📄 Licence

© 2025 Association Canopée - Document technique à usage interne

## 📞 Support

Pour toute question ou problème :
- Email : contact@canopee.org
- Téléphone : 06 XX XX XX XX

---

**Note** : Les données de ce rapport sont fictives et générées à des fins de démonstration. Ne pas utiliser pour des décisions d'ingénierie réelles sans validation par un bureau d'études qualifié.
