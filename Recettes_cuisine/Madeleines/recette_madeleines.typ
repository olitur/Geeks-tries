// ============================================================
// Recette : Madeleines au beurre
// ============================================================
// Pure Typst - reads metadata from informations_madeleines.txt
// ============================================================

#import "../assets/style/style_recettes.typ": *
#import "../assets/style/parse_recipe.typ": parse_recipe_file

// ============================================================
// LOAD RECIPE DATA
// ============================================================

#let recipe = parse_recipe_file("/Madeleines/informations_madeleines.txt")
#let recipe_image = "/Madeleines/images/madeleines_au_citron.jpg"

// ============================================================
// RECIPE DOCUMENT
// ============================================================

#recipe_title(recipe.name, recipe_image)

// IngrÃ©dients
#ingredients_section(recipe.ingredients)

// PrÃ©paration
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
// EXERCICES POUR LES ENFANTS
// ============================================================

= ActivitÃ©s ludiques

#exercise_box(
  "Compte les ingrÃ©dients",
  [
    Combien d'ingrÃ©dients diffÃ©rents utilise-t-on pour cette recette ?

    #v(1em)
    RÃ©ponse : \_\_\_\_\_\_\_
  ]
)

#exercise_box(
  "Les Ã©tapes de prÃ©paration",
  [
    Dessine les 3 Ã©tapes principales de la prÃ©paration :

    #v(1em)
    #grid(
      columns: (1fr, 1fr, 1fr),
      column-gutter: 1em,
      [
        #box(height: 6cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[Ãtape 1]
        ]
      ],
      [
        #box(height: 6cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[Ãtape 2]
        ]
      ],
      [
        #box(height: 6cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[Ãtape 3]
        ]
      ]
    )
  ]
)

#fun_fact[
  Sais-tu que les madeleines sont devenues cÃ©lÃ¨bres grÃ¢ce Ã  l'Ã©crivain Marcel Proust ? Dans son livre, il raconte comment le goÃ»t d'une madeleine trempÃ©e dans du thÃ© lui rappelle ses souvenirs d'enfance !
]

#exercise_box(
  "Calcul gourmand",
  [
    Si la recette est pour 6 personnes, combien faut-il d'ingrÃ©dients pour 12 personnes ?

    #v(0.5em)
    _Multiplie chaque quantitÃ© par 2 !_
  ]
)

#tips_box[
  N'oublie pas de toujours demander l'aide d'un adulte pour utiliser le four ! =h
=i
=g
=f
]
