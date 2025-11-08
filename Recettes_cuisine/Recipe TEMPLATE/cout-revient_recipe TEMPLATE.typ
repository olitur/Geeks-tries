// ============================================================
// COST ANALYSIS TEMPLATE
// ============================================================
// 1. Copy this entire folder and rename it to your recipe name
// 2. Edit informations_[recipe].txt with pricing details
// 3. Rename this file to: cout-revient_[your recipe name].typ
// 4. Update the path below to match your folder name
// 5. Compile with: typst compile cout-revient_[your recipe name].typ
// ============================================================

#import "../assets/style/style_recettes.typ": *
#import "../assets/style/parser.typ": parse-recipe-file

// ============================================================
// LOAD RECIPE DATA
// ============================================================

// Parse the informations file
#let recipe = parse-recipe-file("../../Recipe TEMPLATE/informations_recipe TEMPLATE.txt")

// ============================================================
// COST ANALYSIS DOCUMENT
// ============================================================

#align(center)[
  #v(2em)
  #text(size: 24pt, weight: "bold", fill: orange)[
    Co�t de revient
  ]
  #v(0.5em)
  #text(size: 18pt, fill: lightbrown)[
    #recipe.name
  ]
  #v(2em)
]

= R�capitulatif de la recette

#box(
  fill: cream.darken(5%),
  stroke: 1pt + orange,
  radius: 0.5em,
  inset: 1em,
  width: 100%
)[
  *Nom :* #recipe.name \
  #if recipe.serving.persons != none [*Pour :* #recipe.serving.persons \ ]
  #if recipe.serving.items != none [*Nombre de pi�ces :* #recipe.serving.items \ ]
  #if recipe.cooking.time != none [*Temps de cuisson :* #recipe.cooking.time]
]

= D�tail des co�ts par ingr�dient

#table(
  columns: (2fr, 1fr, 1fr, 1fr, 1fr),
  align: (left, center, center, center, right),
  stroke: 0.5pt + inkl,
  fill: (col, row) => if row == 0 { orange.lighten(70%) },
  inset: 0.7em,

  // Header
  [*Ingr�dient*], [*Quantit� achet�e*], [*Prix d'achat*], [*Quantit� utilis�e*], [*Co�t*],

  // Ingredient rows
  ..recipe.ingredients.map(ing => (
    [#ing.name],
    [#ing.at("bulk_quantity", default: "—")],
    [#ing.at("bulk_price", default: "—")],
    [#ing.quantity],
    [*#ing.at("cost", default: "—")*]
  )).flatten()
)

= R�sum� des co�ts

#cost_table(
  recipe.ingredients,
  energy_cost: recipe.prices.energy,
  total: recipe.prices.total
)

// Cost per person (if serving info available)
#if recipe.serving.persons != none [
  = Co�t par personne

  #let persons_str = recipe.serving.persons
  #let persons_num = int(persons_str.split(" ").at(0))
  #let total_str = recipe.prices.total.replace("�", "").replace(",", ".").trim()

  // Simple division display
  #align(center)[
    #box(
      fill: green.lighten(80%),
      stroke: 2pt + green,
      radius: 0.8em,
      inset: 1.5em,
    )[
      #text(size: 18pt, weight: "bold", fill: green)[
        #recipe.prices.total � #persons_num personnes
      ]
    ]
  ]

  #v(1em)
]

= Astuces pour �conomiser

#tips_box[
  - Acheter les ingr�dients en plus grande quantit� permet souvent de r�duire le co�t unitaire
  - Comparer les prix entre diff�rents magasins
  - Privil�gier les produits de saison
  - �viter le gaspillage en pesant pr�cis�ment les quantit�s
]

#fun_fact[
  En cuisinant toi-m�me, tu �conomises souvent 50% par rapport aux produits tout faits du commerce !
]
