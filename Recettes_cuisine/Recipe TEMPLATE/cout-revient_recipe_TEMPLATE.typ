// ============================================================
// Coût de revient : [NOM DE VOTRE RECETTE]
// ============================================================
// Ce fichier lit automatiquement les données depuis le fichier TOML
// ============================================================

// IMPORTANT: Import style FIRST to apply page setup with footer
#import "../assets/style/style_recettes.typ": *

// Charger les données de la recette depuis TOML
// TODO: Remplacez "informations_recipe_TEMPLATE.toml" par le nom de votre fichier
#let recipe-data = toml("informations_recipe_TEMPLATE.toml")
#let recipe = process-recipe-data(recipe-data)

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
// COST ANALYSIS DOCUMENT
// ============================================================

#align(center)[
  #v(2em)
  #text(size: 24pt, weight: "bold", fill: orange)[
    Coût de revient
  ]
  #v(0.5em)
  #text(size: 18pt, fill: lightbrown)[
    #recipe.name
  ]
  #v(2em)
]

= Récapitulatif de la recette

#box(
  fill: cream.darken(5%),
  stroke: 1pt + orange,
  radius: 0.5em,
  inset: 1em,
  width: 100%
)[
  *Nom :* #recipe.name \
  #if recipe.serving.persons != none [*Pour :* #recipe.serving.persons \ ]
  #if recipe.serving.items != none [*Nombre de pièces :* #recipe.serving.items \ ]
  #if recipe.cooking.time != none [*Temps de cuisson :* #recipe.cooking.time]
]

= Détail des coûts par ingrédient

#table(
  columns: (2fr, 1fr, 1fr, 1fr, 1fr),
  align: (left, center, center, center, right),
  stroke: 0.5pt + inkl,
  fill: (col, row) => if row == 0 { orange.lighten(70%) },
  inset: 0.7em,

  // Header
  [*Ingrédient*], [*Quantité achetée*], [*Prix d'achat*], [*Quantité utilisée*], [*Coût*],

  // Rows
  ..for ing in recipe.ingredients {
    (
      [#ing.name],
      [#ing.at("bulk_quantity", default: "—")],
      [#ing.at("bulk_price", default: "—")],
      [#ing.quantity],
      [*#ing.at("cost", default: "—")*],
    )
  }.flatten()
)

= Résumé des coûts

#cost_table(
  recipe.ingredients,
  energy_cost: recipe.prices.energy,
  total: recipe.prices.total
)

// Coût par personne et par pièce en 2 colonnes
#grid(
  columns: (1fr, 1fr),
  column-gutter: 1.5em,
  [
    #if recipe.serving.persons != none [
      = Coût par personne

      #let persons-match = recipe.serving.persons.match(regex("(\\d+)"))
      #if persons-match != none [
        #let persons = int(persons-match.captures.at(0))
        #let total-val = extract-price-value(recipe.prices.total)
        #let cost-per-person = total-val / persons

        #align(center)[
          #box(
            fill: green.lighten(80%),
            stroke: 2pt + green,
            radius: 0.8em,
            inset: 1.5em,
          )[
            #text(size: 18pt, weight: "bold", fill: green)[
              #format-price(cost-per-person) par personne
            ]
          ]
        ]

        #v(1em)
      ]
    ]
  ],
  [
    #if recipe.serving.items != none [
      = Coût par pièce

      #let items-match = recipe.serving.items.match(regex("(\\d+)"))
      #if items-match != none [
        #let items = int(items-match.captures.at(0))
        #let total-val = extract-price-value(recipe.prices.total)
        #let cost-per-item = total-val / items

        #align(center)[
          #box(
            fill: orange.lighten(85%),
            stroke: 2pt + orange,
            radius: 0.8em,
            inset: 1.5em,
          )[
            #text(size: 16pt, weight: "bold", fill: orange)[
              #format-price(cost-per-item) par pièce
            ]
          ]
        ]

        #v(1em)
      ]
    ]
  ]
)

= Économies potentielles

#tips_box[
  *Comment réduire le coût :*
  - Acheter les ingrédients en plus grande quantité permet souvent de réduire le coût unitaire
  - Comparer les prix entre différents magasins
  - Privilégier les produits de saison
  - Éviter le gaspillage en pesant précisément les quantités
]

#fun_fact[
  En cuisinant toi-même, tu économises souvent 50% par rapport aux produits tout faits du commerce !
]

= Analyse économique

#let total-val = extract-price-value(recipe.prices.total)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 1em,

  // Box 1: Ingredient breakdown
  box(
    fill: rgb("#fff5eb"),
    stroke: 1pt + orange,
    radius: 0.5em,
    inset: 1em,
  )[
    #align(center)[
      #text(weight: "bold", fill: orange)[📊 Répartition des coûts]
    ]
    #v(0.5em)

    #let ing-costs = ()
    #for ing in recipe.ingredients [
      #if "cost" in ing and ing.cost != none [
        #let val = extract-price-value(ing.cost)
        #let percentage = if total-val > 0 { calc.round(val / total-val * 100, digits: 1) } else { 0 }
        - *#ing.name* : #str(percentage)% \
      ]
    ]
  ],

  // Box 2: Energy cost
  box(
    fill: rgb("#e8f5e9"),
    stroke: 1pt + green,
    radius: 0.5em,
    inset: 1em,
  )[
    #align(center)[
      #text(weight: "bold", fill: green)[⚡ Coût énergétique]
    ]
    #v(0.5em)

    #if recipe.prices.energy != none [
      Électricité (four) : *#recipe.prices.energy*

      #let energy-val = extract-price-value(recipe.prices.energy)
      #let percentage = if total-val > 0 { calc.round(energy-val / total-val * 100, digits: 1) } else { 0 }

      Soit #str(percentage)% du coût total
    ] else [
      _Non renseigné_
    ]
  ]
)
