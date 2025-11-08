// ============================================================
// Coût de revient : Madeleines au beurre
// ============================================================
// Fichier généré automatiquement par generate_recipe.py
// ============================================================

#import "../assets/style/style_recettes.typ": *

// ============================================================
// ANALYSE DES COÛTS
// ============================================================

#align(center)[
  #v(2em)
  #text(size: 24pt, weight: "bold", fill: orange)[
    Coût de revient
  ]
  #v(0.5em)
  #text(size: 18pt, fill: lightbrown)[
    Madeleines au beurre
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
  *Nom :* Madeleines au beurre   *Pour :* 6 personnes   *Nombre de pièces :* 12 madeleines \
  *Temps de cuisson :* 10 minutes
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
  [Farine], [1 kg], [2,05 euros], [250 g], [*0,51 euros*],
  [Beurre], [250 g], [1,80 euros], [100 g], [*0,72 euros*],
  [Œufs], [12 units], [2,70 euros], [3 units], [*0,68 euros*],
  [Sucre], [1 kg], [0,60 euros], [150 g], [*0,09 euros*],
)

= Résumé des coûts

#cost_table(
  (
    (name: "Farine", quantity: "250 g", price: "0,51 euros"),
    (name: "Beurre", quantity: "100 g", price: "0,72 euros"),
    (name: "Œufs", quantity: "3 units", price: "0,68 euros"),
    (name: "Sucre", quantity: "150 g", price: "0,09 euros"),
  ),
  energy_cost: "0,15 €",
  total: "2,15 €"
)

= Coût par personne

#align(center)[
  #box(
    fill: green,lighten(80%),
    stroke: 2pt + green,
    radius: 0,8em,
    inset: 1,5em,
  )[
    #text(size: 18pt, weight: "bold", fill: green)[
      0,36 € par personne
    ]
  ]
]

#v(1em)

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
