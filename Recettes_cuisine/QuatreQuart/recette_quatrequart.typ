// ============================================================
// Recette : [NOM DE VOTRE RECETTE]
// ============================================================
// Ce fichier lit automatiquement les données depuis le fichier TOML
// ============================================================

// IMPORTANT: Import style FIRST to apply page setup with footer
#import "../assets/style/style_recettes.typ": *

// Define recipe folder name (relative to Recettes_cuisine root)
#let recipe-folder-name = "QuatreQuart"

// Load recipe data
#let recipe-data = toml("informations_quatrequart.toml")
#let recipe = process-recipe-data(recipe-data, recipe-folder: "../../" + recipe-folder-name)

// Configure footer at document level
#set page(footer: context {
  set text(size: 9pt, fill: inkl)

  grid(
    columns: (auto, 1fr, auto),
    column-gutter: 1em,
    align: horizon,
    // Left: Logo
    image("../assets/images/canopee_logo.jpg", height: 1cm),
    // Center: Generation date
    align(center)[
      #text(style: "italic")[
        Généré le #datetime.today().display("[day]/[month]/[year]")
      ]
    ],
    // Right: Pagination
    align(right)[
      Page #counter(page).get().first()/#counter(page).final().first()
    ]
  )
})

// ============================================================
// RECETTE
// ============================================================

#recipe_title(
  recipe.name,
  // TODO: Remplacez par le chemin vers votre image (ou none si pas d'image)
  "../../QuatreQuart/images/4quart.jpeg"
)

// Ingrédients et Préparation en 2 colonnes
#grid(
  columns: (1fr, 2fr),
  column-gutter: 1.5em,
  [#ingredients_section(recipe.ingredients)],
  [#preparation_section(recipe.steps)]
)

// Cuisson et Service en 2 colonnes
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.5em,
  [
    #if recipe.cooking.time != none [
      #cooking_info(
        recipe.cooking.time,
        recipe.cooking.temperature,
        recipe.cooking.recipient,
        precautions: recipe.cooking.precautions
      )
    ]
  ],
  [
    #if recipe.serving.persons != none [
      #serving_info(
        recipe.serving.persons,
        items: recipe.serving.items,
        time_after: recipe.serving.time_after
      )
    ]
  ]
)

// ============================================================
// EXERCICES POUR LES ENFANTS
// ============================================================

#pagebreak()

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

#english_box[
  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1.5em,
    [#ingredients_section_english(recipe.ingredients)],
    [#ustensiles_section_english(recipe.ustensiles)]
  )
]

= Notes et astuces

#v(1em)

#tips_box[
  *Astuce du chef :* Personnalisez cette section avec vos propres astuces !
]

#fun_fact[
  Ajoutez ici des faits amusants ou l'histoire de votre recette !
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
