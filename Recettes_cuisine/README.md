# 📖 Livre de Recettes - Générateur de PDF

Système simple pour créer de beaux PDFs de recettes avec exercices pour enfants.

## 🌟 Caractéristiques

- ✏️ **Facile à utiliser** : Éditez un simple fichier texte, compilez en PDF
- 🎨 **Joli design** : Couleurs chaudes, emojis, mise en page professionnelle
- 👨‍👩‍👧‍👦 **Pour les enfants** : Exercices ludiques inclus dans chaque recette
- 💰 **Calcul de coût** : Analyse détaillée du coût de revient
- 🌐 **100% Typst** : Pas besoin de Python, juste Typst!

## 🚀 Démarrage rapide

### Installation

Vous avez besoin seulement de Typst :

**Option 1 : Utiliser Typst en ligne (le plus simple)**

⚠️ **ATTENTION avant d'uploader** :
- Le dossier `assets/fonts/` fait ~50 MB (beaucoup de polices)
- Supprimez les polices inutilisées pour gagner de l'espace
- Ou ne gardez que : Alegreya, DejaVu Sans, Lato
- Supprimez aussi `Questions_to-IA.md` si présent

Étapes :
1. Allez sur https://typst.app/
2. Créez un compte gratuit
3. Uploadez le dossier complet `Recettes_cuisine` (ou une version allégée)
4. Les polices dans `assets/fonts/` seront automatiquement détectées !

**Option 2 : Installer Typst localement**

Windows/Mac/Linux : Téléchargez depuis https://github.com/typst/typst/releases

Ou avec votre gestionnaire de paquets :
```bash
# Linux
sudo snap install typst

# Mac
brew install typst

# Windows (avec Scoop)
scoop install typst
```

### Créer votre première recette

1. **Copiez le dossier template**
   ```bash
   cp -r "Recipe TEMPLATE" "MaRecette"
   ```

2. **Éditez les informations**
   - Ouvrez `MaRecette/informations_MaRecette.txt`
   - Remplissez le nom, les ingrédients, les étapes, etc.
   - Laissez vide (`[ ]`) les champs non utilisés

3. **Ajoutez une image (optionnel)**
   - Mettez votre image dans `MaRecette/images/`
   - Format : JPG ou PNG
   - Nom recommandé : `marecette.jpg`

4. **Renommez les fichiers**
   - `recette_recipe TEMPLATE.typ` → `recette_marecette.typ`
   - `cout-revient_recipe TEMPLATE.typ` → `cout-revient_marecette.typ`

5. **Modifiez les chemins dans les .typ**

   Dans `recette_marecette.typ` :
   ```typst
   #let recipe = parse_recipe_file("/MaRecette/informations_MaRecette.txt")
   #let recipe_image = "/MaRecette/images/marecette.jpg"
   ```

6. **Compilez !**
   ```bash
   cd Recettes_cuisine
   typst compile --root . --font-path assets/fonts MaRecette/recette_marecette.typ
   typst compile --root . --font-path assets/fonts MaRecette/cout-revient_marecette.typ
   ```

   💡 **Note** : `--font-path assets/fonts` permet à Typst de trouver les polices incluses

## 📝 Format du fichier informations

Exemple simplifié :

```
name: Madeleines au citron

ingredient#1_name: Farine
ingredient#1_quantity: 250 g
ingredient#1_price: 2,05 euros
# bulk quantity: 1 kg
# bulk price: 2,05 euros
# resulting cost: 0,51 euros

ingredient#2_name: Sucre
ingredient#2_quantity: 150 g
...

preparation_step#1: Mélanger la farine et le sucre.
preparation_step#2: Ajouter les œufs un à un.
...

cooking_time: 10 minutes
cooking_temperature: 200 °C (thermostat 6-7)
cooking_recipient: Moules à madeleines
cooking_prior_precautions: Beurrer et fariner les moules.

serving_number_of_persons: 6 personnes
serving_number_of_items: 12 madeleines
```

**Règles importantes :**
- Mettez un espace après le `:` (ex: `name: Madeleines` ✅, `name:Madeleines` ❌)
- Utilisez `[ ]` pour les champs vides
- Les commentaires commencent par `#`
- Jusqu'à 10 ingrédients et 10 étapes supportés

## 🎨 Personnalisation

### Changer les couleurs

Éditez `assets/style/style_recettes.typ` :

```typst
#let orange = rgb("#ff8c42")  // Couleur principale
#let cream = rgb("#fff5eb")   // Fond
#let brown = rgb("#8b4513")   // Texte foncé
```

### Changer le logo

Remplacez `assets/images/canopee_logo.jpg` par votre logo

### Changer les exercices

Éditez directement les sections "EXERCICES" dans votre fichier `recette_*.typ`

## 📂 Structure du projet

```
Recettes_cuisine/
├── assets/
│   ├── fonts/          # Polices Typst (déjà incluses)
│   ├── images/
│   │   └── canopee_logo.jpg
│   └── style/
│       ├── style_recettes.typ     # Style principal
│       └── parse_recipe.typ       # Parseur de métadonnées
│
├── Recipe TEMPLATE/    # Template à copier
│   ├── images/
│   ├── informations_recipe TEMPLATE.txt
│   ├── recette_recipe TEMPLATE.typ
│   └── cout-revient_recipe TEMPLATE.typ
│
├── Madeleines/         # Exemple complet
│   ├── images/
│   │   └── madeleines_au_citron.jpg
│   ├── informations_madeleines.txt
│   ├── recette_madeleines.typ
│   ├── recette_madeleines.pdf      # ← Généré
│   ├── cout-revient_madeleines.typ
│   └── cout-revient_madeleines.pdf # ← Généré
│
└── README.md           # Ce fichier
```

## 🆘 Problèmes courants

### Erreur : "file not found"

**Solution** : Utilisez toujours `--root .` et des chemins absolus depuis la racine :
```bash
cd Recettes_cuisine
typst compile --root . --font-path assets/fonts MaRecette/recette_marecette.typ
```

Les chemins dans vos fichiers `.typ` doivent commencer par `/` :
```typst
parse_recipe_file("/MaRecette/informations_marecette.txt")
#let recipe_image = "/MaRecette/images/marecette.jpg"
```

### Erreur : "file is not valid utf-8"

**Solution** : Assurez-vous que tous vos fichiers `.typ` et `.txt` sont en UTF-8.

Windows : Utilisez Notepad++ ou VSCode avec "UTF-8" encoding.

### Avertissement : "unknown font family: alegreya"

**Pas grave !** Typst utilisera automatiquement une police de remplacement (DejaVu Sans).

Pour installer Alegreya :
1. Téléchargez depuis https://fonts.google.com/specimen/Alegreya
2. Installez les fichiers `.ttf` dans `assets/fonts/`

### Les emoji ne s'affichent pas

Vérifiez que votre système a des polices emoji installées. Sur Linux :
```bash
sudo apt-get install fonts-noto-color-emoji
```

## 💡 Astuces

### Utiliser Typst Web

Uploadez le dossier complet sur https://typst.app/ et compilez directement dans votre navigateur. Idéal pour partager avec d'autres membres de la famille qui veulent ajouter des recettes !

### Partager vos recettes

Compilez en PDF et partagez simplement le PDF. Ou partagez le dossier complet via Git/Dropbox pour que d'autres puissent modifier.

### Ajouter plus d'exercices

Dans votre fichier `recette_*.typ`, dupliquez un bloc `#exercise_box` :

```typst
#exercise_box(
  "Titre de l'exercice",
  [
    Contenu de l'exercice...
  ]
)
```

## 📧 Support

Questions ? Créez une issue sur GitHub ou modifiez ce README pour ajouter vos propres astuces !

## 🎉 Exemple complet

Consultez le dossier `Madeleines/` pour voir un exemple complet fonctionnel.

Compilez-le :
```bash
cd Recettes_cuisine
typst compile --root . --font-path assets/fonts Madeleines/recette_madeleines.typ
typst compile --root . --font-path assets/fonts Madeleines/cout-revient_madeleines.typ
```

Ouvrez les PDFs générés pour voir le résultat !

---

*Bon appétit et amusez-vous bien en cuisinant ! 👨‍🍳*
