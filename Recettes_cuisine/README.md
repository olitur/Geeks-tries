# 📚 Livre de Recettes - Guide d'utilisation

Système simple de génération de PDF de recettes avec exercices pour enfants et analyse des coûts.

## 🎯 Qu'est-ce que c'est ?

Ce système vous permet de créer facilement deux PDF pour chaque recette :
1. **Recette complète** avec exercices ludiques pour les enfants
2. **Analyse des coûts** avec calculs détaillés

**Aucun code à écrire !** Il suffit de remplir un fichier texte simple et de compiler.

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

Dupliquez le dossier `Recipe TEMPLATE` et renommez-le :
```bash
cp -r "Recipe TEMPLATE" "Ma_Recette"
```

### Étape 2 : Remplir les informations

Éditez le fichier `informations_Ma_Recette.txt` avec **n'importe quel éditeur de texte** (Notepad, VS Code, etc.) :

```
name: Gâteau au chocolat

ingredient#1_name: Chocolat noir
ingredient#1_quantity: 200 g
ingredient#1_price: 2,50 euros

ingredient#2_name: Beurre
ingredient#2_quantity: 150 g
ingredient#2_price: 1,80 euros

preparation_step#1: Faire fondre le chocolat au bain-marie.
preparation_step#2: Ajouter le beurre et mélanger.

cooking_time: 25 minutes
cooking_temperature: 180 °C (thermostat 6)
cooking_recipient: Moule à cake

serving_number_of_persons: 8 personnes
serving_number_of_items: 1 gâteau
```

### Étape 3 : Ajouter une image (optionnel)

Placez une photo de votre recette dans le dossier `images/` :
- Format : JPG ou PNG
- Nom : `Ma_Recette.jpg` (même nom que votre dossier)

### Étape 4 : Générer les PDF

**En ligne de commande :**
```bash
cd Recettes_cuisine
typst compile --root . Ma_Recette/recette_Ma_Recette.typ
typst compile --root . Ma_Recette/cout-revient_Ma_Recette.typ
```

**Avec Typst Web :**
1. Ouvrez `recette_Ma_Recette.typ`
2. Cliquez sur "Compile"
3. Le PDF se génère automatiquement !

## 📝 Format du fichier d'informations

### Structure générale

Le fichier `informations_*.txt` est un simple fichier texte avec des paires `clé: valeur`.

**Important :**
- Toujours mettre un espace après le `:`
- Utiliser `[ ]` pour les champs vides
- Les lignes commençant par `#` sont des commentaires (ignorés)

### Champs disponibles

#### Nom de la recette
```
name: Nom de ma recette
```

#### Ingrédients (jusqu'à 10)
```
ingredient#1_name: Farine
ingredient#1_quantity: 250 g
ingredient#1_price: 2,05 euros
```

Pour les coûts détaillés, ajoutez en commentaires :
```
# bulk quantity: 1 kg
# bulk price: 2,05 euros
# resulting cost: 0,51 euros
```

#### Étapes de préparation (jusqu'à 10)
```
preparation_step#1: Préchauffer le four.
preparation_step#2: Mélanger tous les ingrédients.
```

#### Cuisson
```
cooking_time: 30 minutes
cooking_temperature: 180 °C (thermostat 6)
cooking_recipient: Moule rond
cooking_prior_precautions: Beurrer et fariner le moule.
cooking_verification_steps_during: Surveiller la couleur après 20 min.
cooking_verification_step_end: Piquer avec un couteau (doit ressortir sec).
```

#### Service
```
serving_time_after_cooking: Immédiatement
serving_number_of_items: 12 pièces
serving_number_of_persons: 6 personnes
```

#### Coûts (dans les commentaires à la fin)
```
# ingredient#1 price: 0,51 euros
# ingredient#2 price: 0,72 euros
# energy price (electric oven): 0,15 euros
```

## 🎨 Personnalisation

### Modifier les couleurs

Éditez `assets/style/style_recettes.typ` :
```typst
#let orange = rgb("#ff8c42")      // Couleur des titres
#let cream = rgb("#fff5eb")       // Fond de page
#let green = rgb("#90be6d")       // Encadrés info
```

### Modifier le logo

Remplacez `assets/images/canopee_logo.jpg` par votre propre logo.

### Modifier les exercices

Éditez directement `recette_Ma_Recette.typ` pour personnaliser les exercices pour enfants.

## 📚 Exemples

### Exemple complet : Madeleines

Consultez le dossier `Madeleines/` pour un exemple complet fonctionnel :
- `informations_madeleines.txt` : Fichier de données rempli
- `recette_madeleines.typ` : Fichier de recette
- `cout-revient_madeleines.typ` : Analyse des coûts
- `recette_madeleines.pdf` : PDF généré
- `cout-revient_madeleines.pdf` : PDF des coûts

## 🔧 Dépannage

### Erreur : "file not found"
- Vérifiez que vous compilez depuis le dossier `Recettes_cuisine/`
- Utilisez toujours `--root .` dans la commande

### Erreur : "unknown font"
- Ce n'est qu'un avertissement, le PDF se génère quand même
- Les polices de secours (DejaVu Sans, FreeSans) sont utilisées

### Le PDF ne contient pas mes modifications
- Vérifiez que vous avez sauvegardé le fichier `.txt`
- Recompilez après chaque modification

### Les coûts ne s'affichent pas
- Vérifiez la section des commentaires en fin de fichier `informations_*.txt`
- Format attendu : `# ingredient#1 price: 0,51 euros`

## 💡 Astuces

1. **Copie rapide** : Dupliquez un dossier de recette existante et modifiez juste les informations
2. **Images** : Utilisez des images compressées (< 500 KB) pour des PDF plus légers
3. **Partage** : Les PDFs générés sont autonomes, vous pouvez les partager facilement
4. **Impression** : Format A4 optimisé pour l'impression directe

## 🌐 Utilisation sur Typst Web

1. Créez un compte sur https://typst.app
2. Cliquez sur "New Project" → "Upload files"
3. Uploadez tout le dossier `Recettes_cuisine`
4. La structure de dossiers est préservée
5. Ouvrez `recette_Ma_Recette.typ` et compilez !

**Avantages :**
- Pas d'installation nécessaire
- Collaboration en temps réel possible
- Sauvegarde automatique dans le cloud

## 📞 Support

Besoin d'aide ? Consultez :
- Documentation Typst : https://typst.app/docs
- Exemples dans le dossier `Madeleines/`

## 🎓 Pour aller plus loin

Une fois à l'aise, vous pouvez :
- Modifier les styles dans `assets/style/style_recettes.typ`
- Ajouter de nouvelles sections aux recettes
- Créer vos propres exercices pour enfants
- Personnaliser les calculs de coûts

---

**Bon appétit et bonne cuisine ! 🍰**
