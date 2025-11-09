# 📚 Livre de Recettes - Guide d'utilisation

Système simple de génération de PDF de recettes avec exercices pour enfants et analyse des coûts.

## 🎯 Qu'est-ce que c'est ?

Ce système vous permet de créer facilement deux PDF pour chaque recette :
1. **Recette complète** avec exercices ludiques pour les enfants
2. **Analyse des coûts** avec calculs détaillés automatiques

**Aucun code à écrire !** Il suffit de remplir un fichier TOML simple et de compiler.

## ✨ Fonctionnalités

- ✅ **Format TOML** : Format standard, facile à lire et éditer
- ✅ **Calculs automatiques** : Coûts par ingrédient, coût total, coût énergétique
- ✅ **Pied de page personnalisé** : Logo, date de génération, numérotation des pages
- ✅ **Template extensible** : Jusqu'à 8 ingrédients et 8 étapes par défaut
- ✅ **Style professionnel** : Couleurs chaudes, mise en page familiale

## 📋 Pré-requis

Vous avez besoin uniquement de **Typst** installé sur votre ordinateur.

### Installation de Typst

**Sur Windows :**
1. Téléchargez l'installateur depuis https://github.com/typst/typst/releases
2. Ou installez via `winget install --id Typst.Typst`

**Sur Mac :**
```bash
brew install typst
```

**Sur Linux :**
```bash
# Ubuntu/Debian
sudo apt install typst

# Arch Linux
sudo pacman -S typst
```

### Alternative : Utiliser Typst Web

Si vous ne voulez rien installer, utilisez **Typst Web** (https://typst.app) :
- Créez un compte gratuit
- Uploadez tout le dossier `Recettes_cuisine`
- Compilez directement en ligne !

## 🚀 Utilisation rapide

### Étape 1 : Créer votre dossier de recette

Dupliquez le dossier `Madeleines` comme modèle et renommez-le :
```bash
cp -r Madeleines Ma_Recette
```

### Étape 2 : Remplir les informations TOML

Éditez le fichier `informations_madeleines.toml` (renommez-le en `informations_ma_recette.toml`) avec **n'importe quel éditeur de texte** (Notepad, VS Code, etc.) :

```toml
# Nom de la recette
name = "Gâteau au chocolat"

# Ingrédients
[[ingredients]]
name = "Chocolat noir"
quantity = "200 g"
bulk_quantity = "400 g"
bulk_price = "4,50 euros"

[[ingredients]]
name = "Beurre"
quantity = "150 g"
bulk_quantity = "250 g"
bulk_price = "2,80 euros"

# Étapes de préparation
[[steps]]
text = "Faire fondre le chocolat au bain-marie."

[[steps]]
text = "Ajouter le beurre et mélanger."

# Cuisson
[cooking]
time = "25 minutes"
temperature = "180 °C (thermostat 6)"
recipient = "Moule à cake"
precautions = "Beurrer et fariner le moule."
verification_during = "Surveiller la couleur après 20 min."
verification_end = "Piquer avec un couteau (doit ressortir sec)."

# Service
[serving]
time_after = "Laisser refroidir 10 minutes"
items = "1 gâteau"
persons = "8 personnes"
```

### Étape 3 : Mettre à jour les fichiers Typst

Modifiez les fichiers `.typ` pour pointer vers votre nouveau fichier TOML :

Dans `recette_ma_recette.typ` et `cout-revient_ma_recette.typ`, changez :
```typst
#let recipe-data = toml("informations_ma_recette.toml")
```

### Étape 4 : Ajouter une image (optionnel)

Placez une photo de votre recette dans le dossier `images/` :
- Format : JPG ou PNG
- Nom : `ma_recette.jpg`

Puis dans `recette_ma_recette.typ`, mettez à jour le chemin de l'image :
```typst
#recipe_title(
  recipe.name,
  "../../Ma_Recette/images/ma_recette.jpg"
)
```

### Étape 5 : Générer les PDF

**En ligne de commande :**
```bash
cd Recettes_cuisine
typst compile --root . Ma_Recette/recette_ma_recette.typ
typst compile --root . Ma_Recette/cout-revient_ma_recette.typ
```

**Avec Typst Web :**
1. Ouvrez `recette_ma_recette.typ`
2. Cliquez sur "Compile"
3. Le PDF se génère automatiquement !

## 📝 Format du fichier TOML

### Structure générale

Le fichier utilise le format TOML (Tom's Obvious, Minimal Language), un format de configuration simple et lisible.

**Avantages du TOML :**
- ✅ Format standard avec validation automatique
- ✅ Support natif dans Typst (pas de parser custom)
- ✅ Coloration syntaxique dans la plupart des éditeurs
- ✅ Plus rapide que le parsing de texte personnalisé

### Sections principales

#### 1. Nom de la recette
```toml
name = "Madeleines au beurre"
```

#### 2. Ingrédients (extensible)
```toml
[[ingredients]]
name = "Farine"
quantity = "250 g"
bulk_quantity = "1 kg"
bulk_price = "2,05 euros"

[[ingredients]]
name = "Beurre"
quantity = "100 g"
bulk_quantity = "1 kg"
bulk_price = "1,80 euros"
```

**Calcul automatique :** Le coût de chaque ingrédient est calculé automatiquement :
- Coût = (quantité recette / quantité achat) × prix d'achat
- Exemple : (100g / 1000g) × 1,80€ = 0,18€

**Pour ajouter des ingrédients :** Décommentez les templates à la fin de la section ingrédients.

#### 3. Étapes de préparation (extensible)
```toml
[[steps]]
text = "Mélanger la farine et le sucre."

[[steps]]
text = "Ajouter les œufs un à un."
```

**Pour ajouter des étapes :** Décommentez les templates à la fin de la section steps.

#### 4. Cuisson
```toml
[cooking]
time = "10 minutes"
temperature = "200 °C (thermostat 6-7)"
recipient = "Moules à madeleines"
precautions = "Beurrer et fariner les moules."
verification_during = "Surveiller la cuisson après 8 minutes."
verification_end = "Vérifier avec la pointe d'un couteau."
```

**Calcul automatique :** Le coût énergétique est calculé automatiquement :
- Four : 3,5 kW (configurable dans `style_recettes.typ`)
- Tarif : 0,51 €/kWh (configurable)
- Exemple : 10 min = 0,167 h × 3,5 kW × 0,51 €/kWh = 0,30 €

#### 5. Service
```toml
[serving]
time_after = "Immédiatement après refroidissement"
items = "12 madeleines"
persons = "6 personnes"
```

**Calculs automatiques :**
- Coût par personne = coût total / nombre de personnes
- Coût par pièce = coût total / nombre de pièces

### Template avec espaces réservés

Le fichier TOML inclut des emplacements commentés pour extension facile :

```toml
# Add more ingredients as needed (up to 8 total)
# Uncomment and fill in the following templates:

# [[ingredients]]
# name = ""
# quantity = ""
# bulk_quantity = ""
# bulk_price = ""
```

## 🎨 Personnalisation

### Modifier les couleurs

Éditez `assets/style/style_recettes.typ` :
```typst
#let orange = rgb("#ff8c42")      // Couleur des titres
#let cream = rgb("#fff5eb")       // Fond de page
#let green = rgb("#90be6d")       // Encadrés info
#let brown = rgb("#8b4513")       // Texte chocolat
```

### Modifier le logo dans le pied de page

Remplacez `assets/images/canopee_logo.jpg` par votre propre logo (recommandé : hauteur 1cm).

Le logo apparaît automatiquement dans le pied de page de chaque PDF avec :
- **Gauche :** Logo
- **Centre :** Date de génération
- **Droite :** Numérotation des pages

### Modifier les paramètres de coût énergétique

Dans `assets/style/style_recettes.typ`, fonction `calculate-energy-cost()` :
```typst
#let calculate-energy-cost(
  cooking-time-str,
  oven-power-kw: 3.5,      // Puissance du four en kW
  rate-per-kwh: 0.51       // Tarif électrique en €/kWh
)
```

### Modifier les exercices pour enfants

Éditez directement `recette_ma_recette.typ` pour personnaliser :
- Les questions
- Les zones de dessin
- Les calculs mathématiques
- Les faits amusants

## 📚 Exemple complet : Madeleines

Consultez le dossier `Madeleines/` pour un exemple fonctionnel complet :
- **informations_madeleines.toml** : Données de la recette au format TOML
- **recette_madeleines.typ** : Document Typst de la recette
- **cout-revient_madeleines.typ** : Document Typst de l'analyse des coûts
- **recette_madeleines.pdf** : PDF généré de la recette
- **cout-revient_madeleines.pdf** : PDF généré de l'analyse des coûts

## 🔧 Dépannage

### Erreur : "file not found"
- ✅ Vérifiez que vous compilez depuis le dossier `Recettes_cuisine/`
- ✅ Utilisez toujours `--root .` dans la commande
- ✅ Vérifiez que le nom du fichier TOML correspond à celui référencé dans le `.typ`

### Le PDF ne contient pas mes modifications
- ✅ Vérifiez que vous avez sauvegardé le fichier `.toml`
- ✅ Recompilez après chaque modification
- ✅ Vérifiez qu'il n'y a pas d'erreurs de syntaxe TOML

### Erreur de syntaxe TOML
- ✅ Vérifiez que toutes les chaînes de caractères sont entre guillemets : `name = "Farine"`
- ✅ Respectez la structure `[[section]]` pour les tableaux
- ✅ Utilisez des éditeurs avec support TOML pour la validation automatique

### Le pied de page n'apparaît pas
- ✅ Le pied de page est configuré au niveau du document dans chaque fichier `.typ`
- ✅ Vérifiez que le chemin vers le logo est correct : `../assets/images/canopee_logo.jpg`

### Les coûts sont incorrects
- ✅ Vérifiez que les unités sont cohérentes (g avec g, œufs avec œufs)
- ✅ Format des prix : `"2,05 euros"` (avec virgule et guillemets)
- ✅ Les calculs utilisent : coût = (quantité recette / quantité bulk) × prix bulk

## 💡 Astuces

1. **Copie rapide** : Dupliquez le dossier `Madeleines` et modifiez juste le fichier TOML
2. **Validation TOML** : Utilisez un éditeur avec support TOML (VS Code avec extension TOML)
3. **Images** : Utilisez des images compressées (< 500 KB) pour des PDF plus légers
4. **Partage** : Les PDFs générés sont autonomes, vous pouvez les partager facilement
5. **Template** : Les sections commentées dans le TOML permettent d'ajouter facilement des ingrédients/étapes
6. **Calculs** : Tous les coûts sont recalculés automatiquement à chaque compilation

## 🌐 Utilisation sur Typst Web

1. Créez un compte sur https://typst.app
2. Cliquez sur "New Project" → "Upload files"
3. Uploadez tout le dossier `Recettes_cuisine`
4. La structure de dossiers est préservée
5. Ouvrez `recette_madeleines.typ` et compilez !

**Avantages :**
- Pas d'installation nécessaire
- Collaboration en temps réel possible
- Sauvegarde automatique dans le cloud
- Support natif du format TOML

## 🆕 Changements récents

### Migration vers TOML (2025)

Le système a été migré du format texte personnalisé vers TOML standard :

**Avantages :**
- ✅ Format standardisé et reconnu
- ✅ Validation automatique de la syntaxe
- ✅ Parsing natif Typst (plus rapide)
- ✅ Pas de parser custom à maintenir
- ✅ Meilleure expérience développeur

**Migration depuis l'ancien format :**
Si vous avez des recettes au format `.txt`, convertissez-les en TOML en suivant l'exemple de `informations_madeleines.toml`.

## 📞 Support

Besoin d'aide ? Consultez :
- Documentation Typst : https://typst.app/docs
- Spécification TOML : https://toml.io
- Exemple complet dans le dossier `Madeleines/`

## 🎓 Pour aller plus loin

Une fois à l'aise, vous pouvez :
- Modifier les styles dans `assets/style/style_recettes.typ`
- Personnaliser les fonctions de calcul de coûts
- Ajouter de nouvelles sections aux recettes
- Créer vos propres exercices pour enfants
- Modifier les paramètres énergétiques selon votre four

## 🛠️ Architecture technique

```
Recettes_cuisine/
├── assets/
│   ├── fonts/           # Polices Alegreya (optionnelles)
│   ├── images/          # Logo Canopée
│   └── style/
│       └── style_recettes.typ  # Styles + fonctions de calcul
├── Madeleines/          # Exemple de recette
│   ├── informations_madeleines.toml  # Données TOML
│   ├── recette_madeleines.typ        # Document recette
│   ├── cout-revient_madeleines.typ   # Document coûts
│   └── images/          # Images de la recette
└── README.md
```

**Fonctions principales dans `style_recettes.typ` :**
- `process-recipe-data()` : Traite les données TOML et calcule tous les coûts
- `calculate-ingredient-cost()` : Calcul du coût par ingrédient
- `calculate-energy-cost()` : Calcul du coût énergétique
- `extract-price-value()` : Parsing des prix
- `format-price()` : Formatage des prix pour affichage
- `parse-quantity()` : Parsing et conversion des quantités

---

**Bon appétit et bonne cuisine ! 🍰**
