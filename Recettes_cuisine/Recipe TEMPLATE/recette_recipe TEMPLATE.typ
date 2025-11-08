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
#import "../assets/style/parser.typ": parse-recipe-file

// ============================================================
// LOAD RECIPE DATA
// ============================================================

// Parse the informations file
#let recipe = parse-recipe-file("../../Recipe TEMPLATE/informations_recipe TEMPLATE.txt")

// Set image path (update to match your image filename)
#let recipe_image = "../../Recipe TEMPLATE/images/image_recipe TEMPLATE.jpg"

// ============================================================
// RECIPE DOCUMENT
// ============================================================

#recipe_title(recipe.name, recipe_image)

// Ingr�dients
#ingredients_section(recipe.ingredients)

// Pr�paration
#preparation_section(recipe.steps)

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

= Activit�s ludiques

#exercise_box(
  "Compte les ingr�dients",
  [
    Combien d'ingr�dients diff�rents utilise-t-on pour cette recette ?

    #v(1em)
    R�ponse : \_\_\_\_\_\_\_
  ]
)

#exercise_box(
  "Les �tapes de pr�paration",
  [
    Dessine les 3 �tapes principales de la pr�paration :

    #v(1em)
    #grid(
      columns: (1fr, 1fr, 1fr),
      column-gutter: 1em,
      [
        #box(height: 6cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[�tape 1]
        ]
      ],
      [
        #box(height: 6cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[�tape 2]
        ]
      ],
      [
        #box(height: 6cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[�tape 3]
        ]
      ]
    )
  ]
)

#fun_fact[
  Sais-tu que la cuisine est une science ? Quand tu m�langes les ingr�dients et que tu les chauffes, des r�actions chimiques se produisent ! C'est ce qui donne le bon go�t et la belle forme � tes g�teaux.
]

#tips_box[
  N'oublie pas de toujours demander l'aide d'un adulte pour utiliser le four ! =h=i=g=f
]
