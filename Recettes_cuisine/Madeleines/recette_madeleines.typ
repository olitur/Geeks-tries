// ============================================================
// Recette : Madeleines au beurre
// ============================================================
// Ce fichier lit automatiquement les données depuis informations_madeleines.txt
// ============================================================

#import "../assets/style/style_recettes.typ": *
#import "../assets/style/parser.typ": parse-recipe-file

// Charger les données de la recette
#let recipe = parse-recipe-file("../../Madeleines/informations_madeleines.txt")

// ============================================================
// RECETTE
// ============================================================

#recipe_title(
  recipe.name,
  "../../Madeleines/images/madeleines_au_citron.jpg"
)

// Ingrédients
#ingredients_section(recipe.ingredients)

// Préparation
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
// EXERCICES POUR LES ENFANTS
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

#exercise_box(
  "Calcul gourmand",
  [
    Si la recette est pour #recipe.serving.persons, combien faut-il d'ingrédients pour le double de personnes ?

    #v(0.5em)
    _Multiplie chaque quantité par 2 !_

    #v(1em)
    #grid(
      columns: (2fr, 1fr, 1fr),
      row-gutter: 0.5em,
      align: (left, center, center),
      [*Ingrédient*], [*Quantité×1*], [*Quantité×2*],
      ..for ing in recipe.ingredients {
        (
          [#ing.name],
          [#ing.quantity],
          [\_\_\_\_\_\_],
        )
      }.flatten()
    )
  ]
)

#tips_box[
  N'oublie pas de toujours demander l'aide d'un adulte pour utiliser le four ! 👨‍👩‍👧‍👦
]

#pagebreak()

= Notes et astuces

#v(1em)

#tips_box[
  *Astuce du chef :* Pour des madeleines bien bombées, laisse reposer la pâte au réfrigérateur pendant au moins 1 heure avant la cuisson.
]

#fun_fact[
  Les madeleines sont originaires de Lorraine, en France. Elles sont célèbres grâce à l'écrivain Marcel Proust qui les mentionne dans son livre "À la recherche du temps perdu" !
]

// Vérifications pendant et après cuisson
#if recipe.cooking.verification_during != none or recipe.cooking.verification_end != none [
  == ✓ Vérifications importantes

  #if recipe.cooking.verification_during != none [
    *Pendant la cuisson :* #recipe.cooking.verification_during
  ]

  #v(0.5em)

  #if recipe.cooking.verification_end != none [
    *En fin de cuisson :* #recipe.cooking.verification_end
  ]
]
