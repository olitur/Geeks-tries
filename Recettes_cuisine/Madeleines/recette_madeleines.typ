// ============================================================
// Recette : Madeleines au beurre
// ============================================================
// Ce fichier lit automatiquement les données depuis informations_madeleines.txt
// ============================================================

// IMPORTANT: Import style FIRST to apply page setup with footer
#import "../assets/style/style_recettes.typ": *

// Define recipe folder name (relative to Recettes_cuisine root)
#let recipe-folder-name = "Madeleines"

// Charger les données de la recette depuis TOML
#let recipe-data = toml("informations_madeleines.toml")
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
  "../../Madeleines/images/madeleines_au_citron.jpg"
)

// Ingrédients et Ustensiles en 2 colonnes sous l'image
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.5em,
  [#ingredients_section(recipe.ingredients)],
  [#ustensiles_section(recipe.ustensiles)]
)

#pagebreak()

// Préparation en 1 colonne sur la page suivante
#preparation_section(recipe.steps)

#v(1em)

// Cuisson et Service en 2 colonnes sous préparation
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
  "Reconnais les ingrédients",
  [
    Peux-tu reconnaître les ingrédients utilisés dans cette recette dans les photos ci-dessous ?

    #v(1em)
    #grid(
      columns: (1fr, 1fr, 1fr),
      column-gutter: 1em,
      row-gutter: 1em,
      [
        #box(height: 3.5cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[#image("images/beurre.jpg", width: 100%, height: auto)]
        ]
      ],
      [
        #box(height: 3.5cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[#image("images/farine.jpg", width: 100%, height: auto)]
        ]
      ],
      [
        #box(height: 3.5cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[#image("images/oeuf.jpg", width: 100%, height: auto)]
        ]
      ],
      [
        #box(height: 3.5cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[#image("images/lait.jpg", width: 100%, height: auto)]
        ]
      ],
      [
        #box(height: 3.5cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[#image("images/fleur-oranger.jpg", width: 100%, height: auto)]
        ]
      ],
      [
        #box(height: 3.5cm, width: 100%, stroke: 1pt + gray, radius: 0.3em)[
          #align(center + horizon)[#image("images/sucre.jpg", width: 100%, height: auto)]
        ]
      ]
    )
  ]
)

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

// ============================================================
= Notes et astuces

#v(1em)

#tips_box[
  *Astuce du chef :* Pour des madeleines bien bombées --- _si tu as le temps_ --- laisse reposer la pâte au réfrigérateur pendant au moins 1 heure avant la cuisson.
]

#fun_fact[
  Les madeleines sont originaires de Lorraine, en France. Elles sont célèbres grâce à l'écrivain Marcel Proust qui les mentionne dans son livre "À la recherche du temps perdu" !

  La madeleine est depuis toujours l’un des plaisirs coupables favoris des Français. Son origine remonte à 1775. C’est au château de Commercy qu’elle fut inventée par la cuisinière favorite du roi Stanislas de Pologne. La jeune femme donna ainsi son nom à ce délicieux gâteau fait à base de beurre, de sucre, de farine et de lait.
]


#fun_fact[
  Sais-tu que la cuisine est une science ? Quand tu mélanges les ingrédients et que tu les chauffes, des réactions chimiques se produisent ! C'est ce qui donne le bon goût et la belle forme à tes gâteaux.
]



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
