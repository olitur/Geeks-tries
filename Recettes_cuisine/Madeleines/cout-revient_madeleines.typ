// ============================================================
// Coût de revient : Madeleines au beurre
// ============================================================
// Pure Typst - reads metadata from informations_madeleines.txt
// ============================================================

#import "../assets/style/style_recettes.typ": *
#import "../assets/style/parse_recipe.typ": parse_recipe_file

// ============================================================
// LOAD RECIPE DATA
// ============================================================

#let recipe = parse_recipe_file("/Madeleines/informations_madeleines.txt")

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

  // Ingredient rows
  ..recipe.ingredients.map(ing => (
    [#ing.name],
    [#ing.bulk_quantity],
    [#ing.bulk_price],
    [#ing.quantity],
    [*#ing.cost*]
  )).flatten()
)

= Résumé des coûts

#cost_table(
  recipe.ingredients,
  energy_cost: recipe.energy_cost,
  total: recipe.total_cost
)

// Cost per person (if serving info available)
#if recipe.serving.persons != none [
  = Coût par personne

  #let persons_str = recipe.serving.persons
  #let persons_num = int(persons_str.split(" ").at(0))
  #let total_str = recipe.total_cost.replace("¬", "").replace(",", ".").trim()

  // Simple division display
  #align(center)[
    #box(
      fill: green.lighten(80%),
      stroke: 2pt + green,
      radius: 0.8em,
      inset: 1.5em,
    )[
      #text(size: 18pt, weight: "bold", fill: green)[
        #recipe.total_cost ÷ #persons_num personnes
      ]
    ]
  ]

  #v(1em)
]

= Astuces pour économiser

#tips_box[
  - Acheter les ingrédients en plus grande quantité permet souvent de réduire le coût unitaire
  - Comparer les prix entre différents magasins
  - Privilégier les produits de saison
  - Éviter le gaspillage en pesant précisément les quantités
]

#fun_fact[
  En cuisinant toi-même, tu économises souvent 50% par rapport aux produits tout faits du commerce !
]
