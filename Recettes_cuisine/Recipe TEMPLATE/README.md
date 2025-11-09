# 📋 Template de Recette

Ce dossier est un modèle pour créer vos propres recettes.

## 🚀 Utilisation rapide

### Étape 1 : Copier ce dossier

```bash
cd Recettes_cuisine
cp -r "Recipe TEMPLATE" "Ma_Recette"
```

Ou sur Windows dans l'explorateur :
1. Clic droit sur le dossier "Recipe TEMPLATE"
2. Copier
3. Coller dans le dossier "Recettes_cuisine"
4. Renommer en "Ma_Recette" (ou le nom de votre recette)

### Étape 2 : Renommer les fichiers

Dans votre nouveau dossier "Ma_Recette", renommez les 3 fichiers :

**Important : Retirez "_TEMPLATE" et remplacez "recipe" par le nom de votre recette**

| Ancien nom | Nouveau nom | Action |
|------------|-------------|--------|
| `informations_recipe_TEMPLATE.toml` | `informations_ma_recette.toml` | Retirer `_TEMPLATE`, remplacer `recipe` par `ma_recette` |
| `recette_recipe_TEMPLATE.typ` | `recette_ma_recette.typ` | Retirer `_TEMPLATE`, remplacer `recipe` par `ma_recette` |
| `cout-revient_recipe_TEMPLATE.typ` | `cout-revient_ma_recette.typ` | Retirer `_TEMPLATE`, remplacer `recipe` par `ma_recette` |

**Exemple pour une recette "Cookies" :**
- `informations_recipe_TEMPLATE.toml` → `informations_cookies.toml`
- `recette_recipe_TEMPLATE.typ` → `recette_cookies.typ`
- `cout-revient_recipe_TEMPLATE.typ` → `cout-revient_cookies.typ`

### Étape 3 : Mettre à jour les fichiers .typ

Dans **recette_ma_recette.typ** et **cout-revient_ma_recette.typ**, changez cette ligne :

```typst
// De ceci :
#let recipe-data = toml("informations_recipe_TEMPLATE.toml")

// À ceci :
#let recipe-data = toml("informations_ma_recette.toml")
```

### Étape 4 : Remplir le fichier TOML

Éditez `informations_ma_recette.toml` et remplissez vos informations :

```toml
name = "Nom de votre recette"

[[ingredients]]
name = "Farine"
quantity = "250 g"
bulk_quantity = "1 kg"
bulk_price = "2,50 euros"

# ... etc.
```

**Important :**
- Les prix doivent être entre guillemets : `"2,50 euros"`
- Les unités doivent correspondre : `"250 g"` et `"1 kg"` → OK
- Pour ajouter plus d'ingrédients ou d'étapes, décommentez les sections du template

**Formatage des étapes :**
Vous pouvez utiliser le formatage Typst dans les étapes de préparation :
```toml
[[steps]]
text = """*Titre de l'étape :*
Description détaillée de l'étape."""
```
- Utilisez `*texte*` pour mettre en **gras** (titres d'étapes)
- Utilisez `"""triple guillemets"""` pour le texte multi-lignes
- Les sauts de ligne sont préservés dans les triple guillemets

### Étape 5 : Ajouter une image (optionnel)

1. Placez votre image dans le dossier `images/`
2. Dans `recette_ma_recette.typ`, changez :

```typst
// De ceci :
none  // "../../VotreRecette/images/votre_image.jpg"

// À ceci :
"../../Ma_Recette/images/ma_recette.jpg"
```

### Étape 6 : Compiler les PDFs

Depuis le dossier `Recettes_cuisine/` :

```bash
typst compile --root . Ma_Recette/recette_ma_recette.typ
typst compile --root . Ma_Recette/cout-revient_ma_recette.typ
```

## 📝 Contenu du template

### Fichiers principaux

- **informations_recipe_TEMPLATE.toml** : Données de la recette (ingrédients, étapes, etc.)
- **recette_recipe_TEMPLATE.typ** : Document Typst pour la recette avec exercices
- **cout-revient_recipe_TEMPLATE.typ** : Document Typst pour l'analyse des coûts
- **images/** : Dossier pour vos photos de recette

### Fonctionnalités incluses

✅ **Calculs automatiques**
- Coût par ingrédient calculé automatiquement
- Coût énergétique du four (basé sur le temps de cuisson)
- Coût total, par personne, et par pièce

✅ **Pied de page professionnel**
- Logo Canopée
- Date de génération
- Numérotation des pages

✅ **Exercices pour enfants**
- Comptage d'ingrédients
- Zones de dessin
- Calculs mathématiques simples

✅ **Extensible**
- Jusqu'à 8 ingrédients (modèles commentés inclus)
- Jusqu'à 8 étapes de préparation (modèles commentés inclus)

## 💡 Astuces

### Modifier les exercices

Les exercices pour enfants sont dans `recette_ma_recette.typ`. Vous pouvez :
- Changer les questions
- Ajuster la taille des zones de dessin
- Ajouter vos propres faits amusants

### Personnaliser les astuces

Remplacez les textes génériques dans les sections :
```typst
#tips_box[
  *Astuce du chef :* Votre astuce personnalisée ici !
]

#fun_fact[
  Fait amusant ou histoire de votre recette !
]
```

### Ajouter plus d'ingrédients

Dans le fichier TOML, décommentez simplement les sections :
```toml
# [[ingredients]]    ← Supprimez le #
# name = ""          ← Supprimez le # et remplissez
# quantity = ""      ← Supprimez le # et remplissez
# bulk_quantity = "" ← Supprimez le # et remplissez
# bulk_price = ""    ← Supprimez le # et remplissez
```

## 🔧 Résolution de problèmes

### Les calculs de coûts ne fonctionnent pas
- Vérifiez que les unités correspondent (g avec g, œufs avec œufs)
- Format des prix : `"2,50 euros"` (avec guillemets et virgule)

### Le pied de page n'apparaît pas
- Vérifiez que vous compilez avec `--root .` depuis `Recettes_cuisine/`
- Le chemin du logo doit être : `../assets/images/canopee_logo.jpg`

### L'image ne s'affiche pas
- Vérifiez que le chemin est correct dans `recette_ma_recette.typ`
- Format relatif depuis le dossier racine : `../../Ma_Recette/images/ma_image.jpg`

## 📚 Documentation complète

Pour plus d'informations, consultez :
- **README.md** principal dans `Recettes_cuisine/`
- **Exemple complet** dans le dossier `Madeleines/`
- **Documentation Typst** : https://typst.app/docs
- **Format TOML** : https://toml.io

## ✅ Checklist de création

- [x] Copier et renommer le dossier template
- [ ] Renommer les 3 fichiers (.toml et les 2 .typ)
- [ ] Mettre à jour les références au fichier TOML dans les .typ
- [ ] Remplir le fichier TOML avec vos données
- [ ] Ajouter une image (optionnel)
- [ ] Mettre à jour le chemin de l'image dans le .typ (optionnel)
- [ ] Compiler les 2 PDFs
- [ ] Vérifier que les calculs sont corrects
- [ ] Vérifier que le pied de page apparaît

---

**Bon appétit et bonne cuisine ! 🍰**
