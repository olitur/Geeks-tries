// ============================================================
// RECIPE TEMPLATE
// ============================================================
// 1. Copy this entire folder and rename it to your recipe name
// 2. Edit informations_[recipe].txt with your recipe details
// 3. Rename this file to: recette_[your recipe name].typ
// 4. Update the paths below to match your folder name
// 5. Compile with: typst compile recette_[your recipe name].typ
// ============================================================

#import "../assets/style/style_recettes.typ": *
#import "../assets/style/parse_recipe.typ": parse_recipe_file

// ============================================================
// LOAD RECIPE DATA
// ============================================================

// Parse the informations file
#let recipe = parse_recipe_file("informations_recipe TEMPLATE.txt")

// Set image path (update to match your image filename)
#let recipe_image = "images/image_recipe TEMPLATE.jpg"

// ============================================================
// RECIPE DOCUMENT
// ============================================================

#recipe_title(recipe.name, recipe_image)

// Ingrédients
#ingredients_section(recipe.ingredients)

// Préparation
#preparation_section(recipe.preparation_steps)

// Cuisson
#if recipe.cooking.time != none [
  #cooking_info(
    recipe.cooking.time,
    recipe.cooking.temperature,
    recipe.cooking.recipient,
    precautions: recipe.cooking.precautions
  )
]

// Service
#if recipe.serving.persons != none [
  #serving_info(
    recipe.serving.persons,
    items: recipe.serving.items,
    time_after: recipe.serving.time_after
  )
]

// ============================================================
// EXERCISES FOR CHILDREN
// ============================================================

= Activités ludiques

#exercise_box(
  "Compte les ingrédients",
  [
    Combien d'ingrédients différents utilise-t-on pour cette recette ?

    #v(1em)
    Réponse : \_\_\_\_\_\_\_
  ]
)

#exercise_box(
  "Les étapes de préparation",
  [
    Dessine les 3 étapes principales de la préparation :

    #v(1em)
    #grid(
      columns: (1fr, 1fr, 1fr),
      column-gutter: 1em,
      [
        #box(height: 6cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[Étape 1]
        ]
      ],
      [
        #box(height: 6cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[Étape 2]
        ]
      ],
      [
        #box(height: 6cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[Étape 3]
        ]
      ]
    )
  ]
)

#fun_fact[
  Sais-tu que la cuisine est une science ? Quand tu mélanges les ingrédients et que tu les chauffes, des réactions chimiques se produisent ! C'est ce qui donne le bon goût et la belle forme à tes gâteaux.
]

#tips_box[
  N'oublie pas de toujours demander l'aide d'un adulte pour utiliser le four ! =h=i=g=f
]
